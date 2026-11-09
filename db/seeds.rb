require "net/http"
require "json"
require "faker"

# Clear old seed data before importing again
Categorization.delete_all
Vehicle.delete_all
Category.delete_all
Make.delete_all

# Create vehicle categories
categories = {
  "Passenger Car" => "Standard passenger cars and automobiles.",
  "SUV" => "Sport utility vehicles.",
  "Truck" => "Pickup trucks and other trucks.",
  "Van" => "Passenger and cargo vans."
}

category_records = {}

categories.each do |name, description|
  category_records[name] = Category.create!(
    name: name,
    description: description
  )
end

# Helper method to download JSON data from NHTSA
def get_nhtsa_data(url)
  uri = URI(url)
  response = Net::HTTP.start(
    uri.host,
    uri.port,
    use_ssl: true,
    open_timeout: 10,
    read_timeout: 30
  ) do |http|
    http.get(uri.request_uri)
  end

  raise "NHTSA API request failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

  JSON.parse(response.body)["Results"] || []
rescue StandardError => error
  puts "NHTSA API warning: #{error.message}"
  []
end

# Source 1: Get vehicle makes from NHTSA
puts "Importing vehicle makes from NHTSA..."

makes_url = "https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/car?format=json"
nhtsa_makes = get_nhtsa_data(makes_url)

# Import models for the first 10 makes
nhtsa_makes.first(10).each do |make_data|
  make_id = make_data["MakeId"] || make_data["Make_ID"]
  make_name = make_data["MakeName"] || make_data["Make_Name"]

  next if make_id.nil? || make_name.blank?

  make = Make.find_or_create_by!(name: make_name) do |record|
    record.country = "Unknown"
  end

  # Source 2: Get models for each make from NHTSA
  models_url = "https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMakeId/#{make_id}?format=json"
  nhtsa_models = get_nhtsa_data(models_url)

  nhtsa_models.each do |model_data|
    model_name = model_data["Model_Name"] || model_data["ModelName"]
    next if model_name.blank?

    vehicle = Vehicle.create!(
      make: make,
      model: model_name,
      model_year: Date.current.year,
      vehicle_type: "Car"
    )

    Categorization.find_or_create_by!(
      vehicle: vehicle,
      category: category_records["Passenger Car"]
    )
  end
end

# Source 3: Use Faker to generate additional sample vehicles
puts "Generating additional vehicles with Faker..."

vehicle_types = ["Car", "SUV", "Truck", "Van"]

while Vehicle.count < 200
  make_name = Faker::Vehicle.make

  make = Make.find_or_create_by!(name: make_name) do |record|
    record.country = "Unknown"
  end

  vehicle_type = vehicle_types.sample

  vehicle = Vehicle.create!(
    make: make,
    model: Faker::Vehicle.model,
    model_year: rand(2000..Date.current.year),
    vehicle_type: vehicle_type
  )

  category_name = vehicle_type == "Car" ? "Passenger Car" : vehicle_type

  Categorization.find_or_create_by!(
    vehicle: vehicle,
    category: category_records[category_name]
  )
end

puts "Vehicle Explorer seed completed!"
puts "Makes: #{Make.count}"
puts "Vehicles: #{Vehicle.count}"
puts "Categories: #{Category.count}"
puts "Categorizations: #{Categorization.count}"