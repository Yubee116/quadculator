EU_COUNTRIES = %w[AT BE BG HR CY CZ DK EE FI FR DE EL HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE].freeze
BUYER_TYPES = %i[individual company].freeze
BUYER_COUNTRIES = %w[ES FR RU].freeze

describe 'Sale of  Onsite Services Tests' do
  include_context 'transaction setup'

  context 'When transaction is an Onsite Service' do
    let(:transaction_type) { %w[service onsite] }
    context 'provided in Spain' do
      let(:service_location) { 'ES' }

      BUYER_COUNTRIES.product(BUYER_TYPES).each do |country, buyer_type|
        context "and buyer is a/an #{buyer_type} in #{country} #{if country == 'ES'
                                                                   '(Spain)'
                                                                 else
                                                                   (EU_COUNTRIES.include?(country) ? '(In EU)' : '(Outside EU)')
                                                                 end}" do
          let(:buyer_type) { buyer_type }
          let(:buyer_type) { country }

          it 'applies Spanish VAT' do
            expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.21)
          end
        end
      end
    end

    context 'provided in Croatia' do
      let(:service_location) { 'HR' }

      BUYER_COUNTRIES.product(BUYER_TYPES).each do |country, buyer_type|
        context "and buyer is a/an #{buyer_type} in #{country} #{if country == 'ES'
                                                                   '(Spain)'
                                                                 else
                                                                   (EU_COUNTRIES.include?(country) ? '(In EU)' : '(Outside EU)')
                                                                 end}" do
          let(:buyer_type) { buyer_type }
          let(:buyer_type) { country }

          it 'applies Croatian VAT' do
            expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.25)
          end
        end
      end
    end
  end
end
