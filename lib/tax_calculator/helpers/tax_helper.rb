require_relative '../../../config/tax_calculator_constants'

module TaxHelper
  include TaxCalculatorConstants
  module_function

  def apply_tax(transaction, is_exportable:)
    buyer_country = transaction[:buyer_country]
    buyer_type = transaction[:buyer_type]

    if buyer_country == 'ES'
      transaction[:tax_rate] = SPAIN_VAT
    elsif EU_COUNTRIES_VAT_RATES.key?(buyer_country)
      transaction[:tax_rate] = (buyer_type == :individual) ? EU_COUNTRIES_VAT_RATES[buyer_country] : 0
      transaction[:transaction_type].add('reverse charge') if buyer_type == :company
    else
      transaction[:tax_rate] = 0
      transaction[:transaction_type].add('export') if is_exportable
    end
  end
end
