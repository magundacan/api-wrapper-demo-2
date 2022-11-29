class RawgApi::V2::Client
  class RawgApiError < StandardError; end
  class GameNotFound < RawgApiError; end

  BASE_URL = 'https://api.rawg.io/api'.freeze

  API_KEY = '21f2c8b48c3943af9d717b9e09bb4e24' # Rails.application.credentials.rawg_api_key

  ERROR_CODES = {
    404 => GameNotFound
  }.freeze

  def games(page=1, page_size=4)
    request(
      method: "get",
      endpoint: "games",
      params: { page: page, page_size: page_size }
    )
  end

  def game(id)
    request(
      method: "get",
      endpoint: "games/#{id}"
    )
  end

  # def another_endpoint
  #   request(
  #     method: "post",
  #     endpoint: "endpoint_here",
  #     params: { additional: "parameters" }
  #   )
  # end

  private

  def request(method:, endpoint:, params: {})
    response = connection.public_send(method, "#{endpoint}") do |request|
      params.each do |k, v|
        request.params[k] = v
      end
    end
    return JSON.parse(response.body) if response.success?
    raise ERROR_CODES[response.status]
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL, params: { key: API_KEY })
  end
end
