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
    return false unless token
    return false unless purchase.save

    !(debit? ? debit.error? : credit.error?)
  end

  def error
    @error ||= lambda do
      settings if settings.error?
      'Minted Token ID not found on server' unless token
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
    @tokens ||= OmiseGO::Setting.all
  end

  def token
    @token ||= settings.tokens.find do |token|
      token.id == @token_id
    end
  end

  def calculate_points(price_in_cents)
    price_in_cents / 100 * token.subunit_to_unit
  end

  def credit
    @credit ||= OmiseGO::Wallet.credit(
      account_id: ENV['ACCOUNT_ID'],
      provider_user_id: @user.provider_user_id,
      token_id: @token_id,
      amount: calculate_points(purchase.price.cents),
      idempotency_token: purchase.idempotency_token
    )
  end

  def debit
    @debit ||= OmiseGO::Wallet.debit(
      account_id: ENV['ACCOUNT_ID'],
      provider_user_id: @user.provider_user_id,
      token_id: @token_id,
      amount: @value,
      idempotency_token: purchase.idempotency_token
    )
  end
end
