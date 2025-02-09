require 'set'
require_relative 'validators/transaction_validator'
require_relative 'strategies/goods_tax_strategy'
require_relative 'strategies/digital_services_tax_strategy'
require_relative 'strategies/onsite_services_tax_strategy'

class TaxCalculator
  extend TaxCalculatorConstants
  extend TransactionValidator # Include the validator methods

  def self.calculate_tax(transaction)
    validate_transaction(transaction) # Ensure transaction is valid

    # Duplicate transaction to prevent modifications to the original
    transaction_copy = transaction.dup
    transaction_copy[:transaction_type] = Set.new(transaction[:transaction_type])

    if transaction_copy[:transaction_type].include?('good')
      GoodsTaxStrategy.apply_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('digital')
      DigitalServicesTaxStrategy.apply_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('onsite')
      OnsiteServicesTaxStrategy.apply_tax(transaction_copy)
    else
      raise 'Invalid transaction: Unknown transaction type.'
    end

    transaction_copy
  end
end
