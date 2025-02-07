require_relative '../config/tax_calculator_constants'

class TaxCalculator
  extend TaxCalculatorConstants

  def self.calculate_tax(transaction)
    validate_transaction(transaction)

    is_good = transaction[:transaction_type].include?('good')
    is_service = transaction[:transaction_type].include?('service')
    is_digital = transaction[:transaction_type].include?('digital')
    is_onsite = transaction[:transaction_type].include?('onsite')

    # Check if transaction is both a good and a service
    raise 'Invalid transaction: A transaction cannot be both a good and a service.' if is_good && is_service

    # Check if transaction is both onsite and digital
    raise 'Invalid transaction: A transaction cannot be both onsite and digital.' if is_digital && is_onsite

    taxed_transaction = transaction.dup

    if is_good
      apply_goods_tax(taxed_transaction)
    elsif is_service
      if is_digital
        apply_digital_services_tax(taxed_transaction)
      elsif is_onsite
        apply_onsite_services_tax(taxed_transaction)
      end
    end

    taxed_transaction
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
          transaction[:transaction_type] << 'reverse charge'
        end
      else
        transaction[:tax_rate] = 0
        transaction[:transaction_type] << 'export' if is_exportable
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

    def validate_transaction(transaction)
      # check required fields
      required_keys = %i[transaction_type buyer_country buyer_type]
      missing_keys = required_keys.reject { |key| transaction.key?(key) }
      raise "Invalid transaction: Missing required fields - #{missing_keys.join(', ')}." unless missing_keys.empty?

      # check transaction_type is array and elements are valid
      unless transaction[:transaction_type].is_a?(Array) && transaction[:transaction_type].all? do |t|
        VALID_TRANSACTION_TYPES.include?(t)
      end
        raise 'Invalid transaction: Unknown transaction type.'
      end

      # check buyer type is valid
      raise 'Invalid transaction: Unknown buyer type.' unless VALID_BUYER_TYPES.include?(transaction[:buyer_type])
    end
  end
end
