module JsonApiHelpers
  def json
    JSON.parse(response.body)
  end

  def json_response
    json['data']
  end
end