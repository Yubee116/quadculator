describe 'Sale of  Digital Services Tests' do
  include_context 'transaction setup'

  context 'When transaction is a Digital Service' do
    let(:transaction_type) { %w[service digital] }

    context 'and buyer is an Individual' do
      let(:buyer_type) { :individual }

      context 'in Spain' do
        let(:buyer_country) { 'ES' }
        it 'applies Spanish VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.21)
        end
      end
      context 'in EU Country - Sweden' do
        let(:buyer_country) { 'SE' }
        it 'applies Swedish VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.25)
        end
      end
      context 'Outside EU Country - United States' do
        let(:buyer_country) { 'USA' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
      end
    end

    context 'and buyer is a Company' do
      let(:buyer_type) { :company }

      context 'in Spain' do
        let(:buyer_country) { 'ES' }
        it 'applies Spanish VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.21)
        end
      end
      context 'in EU Country - Sweden' do
        let(:buyer_country) { 'SE' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
        it 'applies reverse charge' do
          expect(TaxCalculator.calculate_tax(transaction)[:transaction_type]).to include('reverse charge')
        end
      end
      context 'Outside EU Country - Canada' do
        let(:buyer_country) { 'CA' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
      end
    end
  end
end
