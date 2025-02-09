require 'set'
require_relative '../../../config/tax_calculator_constants'

module TransactionValidator

  def self.validate_transaction(transaction)
    transaction[:transaction_type] = Set.new(transaction[:transaction_type])

    validate_transaction_fields(transaction)
    validate_good_or_service(transaction)
    validate_transaction_type_constraints(transaction)
    validate_onsite_service_location(transaction) 
  end

  class << self
    private

    def validate_transaction_fields(transaction)
      required_keys = Set[:transaction_type, :buyer_country, :buyer_type]
      missing_keys = required_keys - transaction.keys
      raise "Invalid transaction: Missing required fields - #{missing_keys.to_a.join(', ')}." unless missing_keys.empty?

      valid_transaction_types = TaxCalculatorConstants::VALID_TRANSACTION_TYPES
      valid_buyer_types = TaxCalculatorConstants::VALID_BUYER_TYPES
      
      unless (transaction[:transaction_type] & valid_transaction_types).any?
        raise 'Invalid transaction: Unknown transaction type.'
      end

      raise 'Invalid transaction: Unknown buyer type.' unless valid_buyer_types.include?(transaction[:buyer_type])
    end

    def validate_good_or_service(transaction)
      unless transaction[:transaction_type].intersect?(Set['good', 'service'])
        raise 'Invalid transaction: A transaction must be a good or a service.'
      end
    end

    def validate_transaction_type_constraints(transaction)
      if transaction[:transaction_type].superset?(Set['good', 'service'])
        raise 'Invalid transaction: A transaction cannot be both a good and a service.'
      end

      if transaction[:transaction_type].superset?(Set['digital', 'onsite'])
        raise 'Invalid transaction: A transaction cannot be both onsite and digital.'
      end
    end

    def validate_onsite_service_location(transaction)
      if transaction[:transaction_type].include?('onsite') && transaction[:service_location].nil?
        raise 'Invalid transaction: Onsite service must have a service location.'
      end
    end
  end
end
