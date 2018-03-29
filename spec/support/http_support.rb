module HttpSupport

  def player_1_headers
    {
      "X-Api-Key" => ENV["BATTLESHIFT_API_KEY"]
    }
  end

  def conn
    Faraday.new(url: "http://localhost:3000", player_1_headers)
  end

  def post_url(url, params)
    conn.post(url, params)
  end
  
end
