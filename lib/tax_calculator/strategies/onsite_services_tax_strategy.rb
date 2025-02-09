require_relative '../../../config/tax_calculator_constants'

module OnsiteServicesTaxStrategy
  include TaxCalculatorConstants

  module_function

  def apply_tax(transaction)
    transaction[:tax_rate] = EU_COUNTRIES_VAT_RATES[transaction[:service_location]] || 0
  end
end
