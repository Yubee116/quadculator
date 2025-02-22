require 'set'
require_relative '../../config/tax_calculator_constants'
require_relative 'utils/transaction_validator'
require_relative 'utils/transaction_normalizer'
require_relative 'strategies/goods_tax_strategy'
require_relative 'strategies/digital_services_tax_strategy'
require_relative 'strategies/onsite_services_tax_strategy'

class TaxCalculator

  def self.calculate_tax(transaction)
    # Ensure transaction is in expected format
    transaction_copy = TransactionNormalizer.normalize(transaction) 

    # Ensure transaction is valid
    TransactionValidator.validate_transaction(transaction_copy) 

    # Apply tax
    if transaction_copy[:transaction_type].include?('good')
      GoodsTaxStrategy.apply_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('digital')
      DigitalServicesTaxStrategy.apply_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('onsite')
      OnsiteServicesTaxStrategy.apply_tax(transaction_copy)
    end

    transaction_copy
  end
end
