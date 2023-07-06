class TLWH
  class << self
    def new
      super(
        rpc_url: ENV['INFURA_SEPOLIA_URL'],
        contract_name: ENV['CONTRACT_NAME'],
        contract_address: ENV['CONTRACT_ADDRESS'],
        contract_abi_path: Rails.root.join('config', 'tlwh_abi.json')
      )
    end
  end

  attr_accessor :rpc_url, :eth_client,
    :contract_name, :contract_address, :contract_abi, :contract

  def initialize(options = {})
    @rpc_url = options[:rpc_url]
    @contract_name = options[:contract_name]
    @contract_address = options[:contract_address]
    @contract_abi = File.open(options[:contract_abi_path]).read
  end

  def fetch_events(topics = [])
    # Transfer topic name to signature
    # For example, input topics like: ['MetadataUpdate']
    # will be converted to ['0xf8e1a15aba9398e019f0b49df1a4fde98ee17ae345cb5f6b5e2c27f5033e8ce7']
    if topics.present?
      topics = topics.map do |topic|
        event = contract.events.find{ |event| event.name == topic }.try(:signature)
      end
      topics.compact!
    end
    params = {
      address: contract.address,
      fromBlock: 'earliest',
      toBlock: 'latest',
      topics: topics
    }
    eth_client.eth_get_logs(params)['result']
  end

  def func_mint
    @func_mint ||= contract.functions.find{ |function| function.name == 'mint' }
  end

  def eth_client
    @eth_client ||= Eth::Client.create(rpc_url)
  end

  def contract
    @contract ||= Eth::Contract.from_abi(
      name: contract_name,
      address: contract_address,
      abi: contract_abi
    )
  end
end
