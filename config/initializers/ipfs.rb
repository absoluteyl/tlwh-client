class Ipfs
  class << self
    def client
      @client ||= new(
        host:       ENV['INFURA_IPFS_HOST'],
        api_key:    ENV['INFURA_IPFS_API_KEY'],
        api_secret: ENV['INFURA_IPFS_API_KEY_SECRET']
      )
    end

    def url(hash)
      "#{ENV['IPFS_HOST']}#{hash}"
    end
  end

  attr_accessor :host, :api_key, :api_secret

  def initialize(options = {})
    @host       = options[:host]
    @api_key    = options[:api_key]
    @api_secret = options[:api_secret]
  end

  # Upload and auto-pin a file to IPFS through Infura
  def add(file_path)
    rest_client_params = {
      method:  :post,
      url:     "#{host}/api/v0/add",
      headers: headers,
      payload: {
        file: File.new(file_path)
      }
    }
    begin
      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)
      # {"Name"=>"images.jpg", "Hash"=>"QmVBB9asE4uyhh4VLo2ai9sytcXVv5REGsQMrrMDqGi2J8", "Size"=>"6376"}
    rescue => e
      parsed_body = e.response.body
      raise parsed_body
    end
  end

  # Unpin a file on IPFS so it could be garbage collected
  def unpin(hash)
    rest_client_params = {
      method:  :post,
      url:     "#{host}/api/v0/pin/rm?arg=#{hash}",
      headers: headers
    }
    begin
      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)
    rescue => e
      parsed_body = e.response.body
      raise parsed_body
    end
  end

  private

  def encode_credentials
    @encode_credentials ||= Base64.strict_encode64("#{api_key}:#{api_secret}")
  end

  def headers
    @headers ||= {
      'Authorization': "Basic #{encode_credentials}",
    }
  end
end
