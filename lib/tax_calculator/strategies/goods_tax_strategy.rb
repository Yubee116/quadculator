require_relative '../helpers/tax_helper'

module GoodsTaxStrategy
  module_function 

  def apply_tax(transaction)
    TaxHelper.apply_tax(transaction, is_exportable: true)
  end
end
