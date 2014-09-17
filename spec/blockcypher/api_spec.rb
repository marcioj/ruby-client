describe BlockCypher::Api do
  let(:api) { BlockCypher::Api.new(currency: BlockCypher::BTC, network: BlockCypher::TEST_NET_3, version: BlockCypher::V1) }

  let(:address_1) { 'miB9s4fcYCEBxPQm8vw6UrsYc2iSiEW3Yn' }
  let(:address_1_private_key) { 'f2a73451a726e81aec76a2bfd5a4393a89822b30cc4cddb2b4317efb2266ad47' }

  let(:address_2) { 'mnTBb2Fd13pKwNjFQz9LVoy2bqmDugLM5m' }
  let(:address_2_private_key) { '76a32c1e5b6f9e174719e7c1b555d6a55674fdc2fd99cfeee96a5de632775645' }

  let(:token) { 'testtoken' }

  describe '#transaction_new' do

    it 'should call the txs/new api' do
      input_addresses = [address_1]
      output_addresses = [address_2]
      satoshi_value = 20000
      res = api.transaction_new(input_addresses, output_addresses, satoshi_value)
      expect(res["tx"]["hash"]).to be_present
    end
  end

  describe '#transaction_sign_and_send' do

    it 'should call txs/send api' do

      input_addresses = [address_2]
      output_addresses = [address_1]
      satoshi_value = 10000

      new_tx = api.transaction_new(input_addresses, output_addresses, satoshi_value)
      res = api.transaction_sign_and_send(new_tx, address_2_private_key)
      expect(res["tx"]["hash"]).to be_present
    end

  end

  describe '#address_final_balance' do

    it 'should get the balance of an address' do
      balance = api.address_final_balance(address_1)
      expect(balance).to be_kind_of Integer
      expect(balance).to be > 0
    end

  end

  describe '#event_webhook_subscribe'  do

    it 'should create a tx-confirmation hook ' do
      hook_response = api.event_webhook_subscribe('http://requestb.in/yvrbljyv', 'tx-confirmation', token, address: 'mjU2XANrziNRB8T2vGPEvPRagY1uxwRzyT')
      expect(hook_response['event']).to eq('tx-confirmation')
      expect(hook_response['url']).to eq('http://requestb.in/yvrbljyv')
    end

  end

end
