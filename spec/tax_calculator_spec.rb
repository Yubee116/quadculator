describe 'Invalid Transactions Tests' do
  context 'When transaction is missing required fields' do
    let(:transaction) { {} }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error(RuntimeError,
                         include('Invalid transaction: Missing required fields - '))
    end
  end

  context 'When transaction type is unknown' do
    let(:transaction) { { transaction_type: %w[some-value], buyer_country: 'AT', buyer_type: :individual } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: Unknown transaction type.')
    end
  end

  context 'When transaction type is both good and service' do
    let(:transaction) { { transaction_type: %w[good service], buyer_country: 'BE', buyer_type: :individual } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: A transaction cannot be both a good and a service.')
    end
  end

  context 'When transaction type is neither good nor service' do
    let(:transaction) { { transaction_type: %w[digital some-value], buyer_country: 'EL', buyer_type: :individual } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: A transaction must be a good or a service.')
    end
  end

  context 'When transaction type is both onsite and digital' do
    let(:transaction) { { transaction_type: %w[service digital onsite], buyer_country: 'BG', buyer_type: :company } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: A transaction cannot be both onsite and digital.')
    end
  end

  context 'When transaction is onsite service but missing service location' do
    let(:transaction) { { transaction_type: %w[service onsite], buyer_country: 'CY', buyer_type: :individual } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: Onsite service must have a service location.')
    end
  end

  context 'When buyer type is invalid' do
    let(:transaction) { { transaction_type: %w[good], buyer_country: 'HR', buyer_type: :invalid_type } }
    it 'raises an error' do
      expect do
        TaxCalculator.calculate_tax(transaction)
      end.to raise_error('Invalid transaction: Unknown buyer type.')
    end
  end
end
