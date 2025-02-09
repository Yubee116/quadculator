require 'set'
require_relative 'validators/transaction_validator'
require_relative 'helpers/tax_helper'
require_relative '../../config/tax_calculator_constants'

class TaxCalculator
  extend TaxCalculatorConstants
  extend TransactionValidator # Include the validator methods

  def self.calculate_tax(transaction)
    validate_transaction(transaction) # Ensure transaction is valid

    # Duplicate transaction to prevent modifications to the original
    transaction_copy = transaction.dup
    transaction_copy[:transaction_type] = Set.new(transaction[:transaction_type])

    if transaction_copy[:transaction_type].include?('good')
      apply_goods_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('digital')
      apply_digital_services_tax(transaction_copy)
    elsif transaction_copy[:transaction_type].include?('onsite')
      apply_onsite_services_tax(transaction_copy)
    else
      raise 'Invalid transaction: Unknown transaction type.'
    end

    transaction_copy
  end

  class << self
    def apply_goods_tax(transaction)
      TaxHelper.apply_tax(transaction, is_exportable: true)
    end

    def apply_digital_services_tax(transaction)
      TaxHelper.apply_tax(transaction, is_exportable: false)
    end

    def apply_onsite_services_tax(transaction)
      transaction[:tax_rate] = EU_COUNTRIES_VAT_RATES[transaction[:service_location]] || 0
    end
  end
end
