require 'set'
require_relative 'validators/transaction_validator'
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
    def apply_tax(transaction, is_exportable:)
      buyer_country = transaction[:buyer_country]
      buyer_type = transaction[:buyer_type]

      if buyer_country == 'ES'
        transaction[:tax_rate] = SPAIN_VAT
      elsif EU_COUNTRIES_VAT_RATES.key?(buyer_country)
        if buyer_type == :individual
          transaction[:tax_rate] = EU_COUNTRIES_VAT_RATES[buyer_country]
        elsif buyer_type == :company
          transaction[:tax_rate] = 0
          transaction[:transaction_type].add('reverse charge')
        end
      else
        transaction[:tax_rate] = 0
        transaction[:transaction_type].add('export') if is_exportable
      end
    end

    def apply_goods_tax(transaction)
      apply_tax(transaction, is_exportable: true)
    end

    def apply_digital_services_tax(transaction)
      apply_tax(transaction, is_exportable: false)
    end

    def apply_onsite_services_tax(transaction)
      service_location = transaction[:service_location]
      raise 'Invalid transaction: Onsite service must have a service location.' if service_location.nil?

      transaction[:tax_rate] = EU_COUNTRIES_VAT_RATES[service_location] || 0
    end
  end
end
