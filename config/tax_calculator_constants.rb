require 'set'

module TaxCalculatorConstants
  EU_COUNTRIES_VAT_RATES = {
    'AT' => 0.20, 'BE' => 0.21, 'BG' => 0.20, 'HR' => 0.25, 'CY' => 0.19, 'CZ' => 0.21, 'DK' => 0.25, 'EE' => 0.20, 'FI' => 0.24, 'FR' => 0.20,
    'DE' => 0.19, 'EL' => 0.24, 'HU' => 0.27, 'IE' => 0.23, 'IT' => 0.22, 'LV' => 0.21, 'LT' => 0.21, 'LU' => 0.17, 'MT' => 0.18, 'NL' => 0.21,
    'PL' => 0.23, 'PT' => 0.23, 'RO' => 0.19, 'SK' => 0.23, 'SI' => 0.22, 'ES' => 0.21, 'SE' => 0.25
  }

  EU_COUNTRIES_VAT_RATES.each { |key, value| EU_COUNTRIES_VAT_RATES[key] = value.freeze }
  EU_COUNTRIES_VAT_RATES.freeze

  SPAIN_VAT = 0.21 # 21%

  VALID_BUYER_TYPES = Set.new(%i[individual company]).freeze
  VALID_TRANSACTION_TYPES = Set.new(%w[good service digital onsite]).freeze
end
