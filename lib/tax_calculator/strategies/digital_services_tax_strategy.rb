require_relative '../helpers/tax_helper'

module DigitalServicesTaxStrategy
  module_function

  def apply_tax(transaction)
    TaxHelper.apply_tax(transaction, is_exportable: false)
  end
end
