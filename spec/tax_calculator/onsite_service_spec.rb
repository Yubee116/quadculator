describe 'Sale of  Onsite Services Tests' do
  include_context 'transaction setup'

  EU_COUNTRIES_VAT_RATES = TaxCalculatorConstants::EU_COUNTRIES_VAT_RATES
  BUYER_TYPES = TaxCalculatorConstants::VALID_BUYER_TYPES.to_a
  BUYER_COUNTRIES = {
    'Spain' => 'ES',
    'France' => 'FR',
    'Russia' => 'RU'
  }.freeze

  def self.country_label(country_code)
    return '' if country_code == 'ES'

    EU_COUNTRIES_VAT_RATES.key?(country_code) ? '(In EU)' : '(Outside EU)'
  end

  context 'When transaction is an Onsite Service' do
    let(:transaction_type) { %w[service onsite] }

    SERVICE_LOCATIONS = {
      'Spain' => 'ES',
      'Croatia' => 'HR',
      'USA' => 'US'
    }.freeze

    SERVICE_LOCATIONS.each do |service_country, service_country_code|
      context "provided in #{service_country} #{country_label(service_country_code)}" do
        let(:service_location) { service_country_code }

        BUYER_COUNTRIES.to_a.product(BUYER_TYPES).each do |(buyer_country, buyer_country_code), buyer_type|
          context "and buyer is a/an #{buyer_type} in #{buyer_country} #{country_label(buyer_country_code)}" do
            let(:buyer_type) { buyer_type }
            let(:buyer_country) { buyer_country_code }

            vat_rate = EU_COUNTRIES_VAT_RATES[service_country_code] || 0

            it "applies #{vat_rate * 100}% VAT" do
              expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(vat_rate)
            end
          end
        end
      end
    end
  end
end
