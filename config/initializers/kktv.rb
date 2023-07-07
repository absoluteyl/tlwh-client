class Kktv
  class << self
    def client
      @client ||= new(
        host: ENV["KKTV_API_HOST"]
      )
    end
  end

  attr_accessor :host

  def initialize(options = {})
    @host = options[:host]
  end

  def watch_hist(user)
    if user.kktv_user_token.present?
      url = @host + "/v4/a/users/me/watch-history"
      headers = {
        'Authorization': "Bearer #{user.kktv_user_token}"
      }
      rest_client_params = {
        method:  :get,
        url:     url,
        headers: headers
      }
      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)
      parsed_body['data']['items'].map(&:deep_symbolize_keys)
    end
  rescue
    nil
  end

  def title_detail(user, title_id)
    if user.kktv_user_token.present?
      url = @host + "/v4/a/titles/#{title_id}"
      headers = {
        'Authorization': "Bearer #{user.kktv_user_token}"
      }
      rest_client_params = {
        method:  :get,
        url:     url,
        headers: headers
      }
      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)
      parsed_body['data']['title'].deep_symbolize_keys
    end
  rescue
    nil
  end
end
