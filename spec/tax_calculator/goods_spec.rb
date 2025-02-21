describe 'Sale of Goods Tests' do
  include_context 'transaction setup'

  context 'When transaction is a Good' do
    let(:transaction_type) { ['good'] }

    context 'and buyer is an Individual' do
      let(:buyer_type) { :individual }

      context 'in Spain' do
        let(:buyer_country) { 'ES' }
        it 'applies Spanish VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.21)
        end
      end
      context 'in EU Country - Ireland' do
        let(:buyer_country) { 'IE' }
        it 'applies Irish VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0.23)
        end
      end
      context 'Outside EU Country - United States' do
        let(:buyer_country) { 'US' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
        it 'applies export' do
          expect(TaxCalculator.calculate_tax(transaction)[:transaction_type]).to include('export')
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
      context 'in EU Country - Ireland' do
        let(:buyer_country) { 'IE' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
        it 'applies reverse charge' do
          expect(TaxCalculator.calculate_tax(transaction)[:transaction_type]).to include('reverse charge')
        end
      end
      context 'Outside EU Country - United States' do
        let(:buyer_country) { 'USA' }
        it 'applies no VAT' do
          expect(TaxCalculator.calculate_tax(transaction)[:tax_rate]).to eq(0)
        end
        it 'applies export' do
          expect(TaxCalculator.calculate_tax(transaction)[:transaction_type]).to include('export')
        end
      end
    end
  end
end
