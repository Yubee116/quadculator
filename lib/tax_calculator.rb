class TaxCalculator
  EU_COUNTRIES_VAT_RATES = {
    'AT' => 0.20, 'BE' => 0.21, 'BG' => 0.20, 'HR' => 0.25, 'CY' => 0.19, 'CZ' => 0.21, 'DK' => 0.25, 'EE' => 0.20, 'FI' => 0.24, 'FR' => 0.20,
    'DE' => 0.19, 'EL' => 0.24, 'HU' => 0.27, 'IE' => 0.23, 'IT' => 0.22, 'LV' => 0.21, 'LT' => 0.21, 'LU' => 0.17, 'MT' => 0.18, 'NL' => 0.21,
    'PL' => 0.23, 'PT' => 0.23, 'RO' => 0.19, 'SK' => 0.23, 'SI' => 0.22, 'ES' => 0.21, 'SE' => 0.25
  }

  EU_COUNTRIES_VAT_RATES.each { |key, value| EU_COUNTRIES_VAT_RATES[key] = value.freeze }
  EU_COUNTRIES_VAT_RATES.freeze

  SPAIN_VAT = 0.21 # 21%

  # considerations:
  # transaction_type: physical, good
  #                   service: digital, onsite
  # buyer_country: Spain, EU
  #                Non-EU
  # buyer_type: individual, company
  # service_location

  def self.calculate_tax(transaction)
    if transaction[:transaction_type].include?('good')
      apply_goods_tax(transaction)
    elsif transaction[:transaction_type].include?('service') && transaction[:transaction_type].include?('digital')
      apply_digital_services_tax(transaction)
    elsif transaction[:transaction_type].include?('service') && transaction[:transaction_type].include?('onsite')
      apply_onsite_services_tax(transaction)
    else
      raise 'Invalid transaction type'
    end
    transaction
  end

  def self.apply_goods_tax(transaction); end
  def self.apply_digital_services_tax(transaction); end

  def self.apply_onsite_services_tax(transaction)
    transaction[:tax_rate] = EU_COUNTRIES_VAT_RATES[service_location] || 0
  end
end
