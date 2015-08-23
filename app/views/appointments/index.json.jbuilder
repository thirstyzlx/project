json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :gametime, :player1ID, :player2ID
  json.url appointment_url(appointment, format: :json)
end
