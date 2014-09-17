describe BlockCypher::Api, :vcr do
  subject do
    BlockCypher::Api.new(currency: BlockCypher::BTC, network: BlockCypher::TEST_NET_3, version: BlockCypher::V1)
  end

  let(:address_1) { "n2JLznPZCUnLRmSLzr9UAE22psexCVdz8i" }
  let(:address_2) { "mxZUdSxjxFZvmVpo2NuLSQ1CZZonhns8w5" }

  let(:token) { 'testtoken' }

  # describe '#transaction_new' do
  #
  #   it 'should call the txs/new api' do
  #     input_addresses = [address_1]
  #     output_addresses = [address_2]
  #     satoshi_value = 20000
  #     res = api.transaction_new(input_addresses, output_addresses, satoshi_value)
  #     expect(res["tx"]["hash"]).to be_present
  #   end
  # end
  #
  # describe '#transaction_sign_and_send' do
  #
  #   it 'should call txs/send api' do
  #
  #     input_addresses = [address_2]
  #     output_addresses = [address_1]
  #     satoshi_value = 10000
  #
  #     new_tx = api.transaction_new(input_addresses, output_addresses, satoshi_value)
  #     res = api.transaction_sign_and_send(new_tx, address_2_private_key)
  #     expect(res["tx"]["hash"]).to be_present
  #   end
  #
  # end

  describe "#address_final_balance" do
    let!(:balance_1) { subject.address_final_balance(address_1) }
    let!(:balance_2) { subject.address_final_balance(address_2) }

    it "gets the balance of address 1" do
      expect(balance_1).to eq(10000000)
    end

    it "gets the balance of address 2" do
      expect(balance_2).to eq(12000000)
    end
  end

  describe "#event_webhook_subscribe"  do
    let!(:hook_response) do
      subject.event_webhook_subscribe("http://requestb.in/yvrbljyv", "tx-confirmation", token, address: address_1)
    end

    it { expect(hook_response["event"]).to eq("tx-confirmation") }
    it { expect(hook_response["url"]).to eq("http://requestb.in/yvrbljyv") }
  end
end
