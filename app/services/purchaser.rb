class Purchaser
  def initialize(user, purchase_params, idempotency_token)
    @user = user
    @purchase_params = purchase_params
    @value = (@purchase_params[:token_value] || 0).to_i
    @token_id = @purchase_params.delete(:token_id)
    @purchase_params[:idempotency_token] = idempotency_token || SecureRandom.uuid
  end

  def call
    purchase.user = @user
    return false if settings.error?
    return false unless minted_token
    return false unless purchase.save

    !(debit? ? debit.error? : credit.error?)
  end

  def error
    @error ||= lambda do
      settings if settings.error?
      'Minted Token ID not found on server' unless minted_token
      debit? ? debit : credit
    end.call
  end

  def purchase
    @purchase ||= Purchase.new(@purchase_params)
  end

  private

  def debit?
    @_debit ||= (@value || 0) > 0
  end

  def settings
    @minted_tokens ||= OmiseGO::Setting.all
  end

  def minted_token
    @minted_token ||= settings.minted_tokens.find do |minted_token|
      minted_token.id == @token_id
    end
  end

  def calculate_points(price_in_cents)
    price_in_cents / 100 * minted_token.subunit_to_unit
  end

  def credit
    @credit ||= OmiseGO::Balance.credit(
      provider_user_id: @user.provider_user_id,
      token_id: @token_id,
      amount: calculate_points(purchase.price.cents),
      idempotency_token: purchase.idempotency_token
    )
  end

  def debit
    @debit ||= OmiseGO::Balance.debit(
      provider_user_id: @user.provider_user_id,
      token_id: @token_id,
      amount: @value,
      idempotency_token: purchase.idempotency_token
    )
  end
end
