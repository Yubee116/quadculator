RSpec.shared_context 'transaction setup', shared_context: :metadata do
  let(:transaction) do
    {
      transaction_type: transaction_type,
      buyer_country: buyer_country,
      buyer_type: buyer_type,
      service_location: service_location
    }
  end

  let(:transaction_type) { [] }
  let(:buyer_country) { nil }
  let(:buyer_type) { nil }
  let(:service_location) { nil }
end
