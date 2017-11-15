class Purchaser
  def initialize(user, purchase_params)
    @user = user
    @purchase_params = purchase_params
    @value = (@purchase_params[:token_value] || 0).to_i
    @symbol = @purchase_params[:token_symbol]
  end

  def call
    purchase.user = @user
    return false unless purchase.save
    !(debit? ? debit.error? : credit.error?)
  end

  def error
    @error ||= (debit? ? debit : credit)
  end

  def purchase
    @purchase ||= Purchase.new(@purchase_params)
  end

  private

  def debit?
    @_debit ||= (@value || 0) > 0
  end

  def credit
    @credit ||= OmiseGO::Balance.credit(
      provider_user_id: @user.provider_user_id,
      symbol: @symbol,
      amount: purchase.price.cents
    )
  end

  def debit
    @debit ||= OmiseGO::Balance.debit(
      provider_user_id: @user.provider_user_id,
      symbol: @symbol,
      amount: @value
    )
  end
end
