module RapidApi::Requests
  class BaseRequest < Base::Request
    def base_url
      Rails.application.secrets.rapidapi_base_url
    end

    def headers
      {
        "X-RapidAPI-KEY": Rails.application.secrets.rapidapi_key,
        "X-RapidAPI-host": Rails.application.secrets.rapidapi_host,
      }
    end
  end
end
