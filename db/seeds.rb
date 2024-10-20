# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Clearing existing clients..."
Client.destroy_all

# Create 5 clients
puts "Creating 5 clients..."

5.times do |i|
  client = Client.create!(
    name: "Client #{i + 1}"
  )
  puts "Created client: #{client.name}"
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create client #{i + 1}: #{e.message}"
end

puts "Seeding completed!"

# Output the total number of clients
puts "Total number of clients: #{Client.count}"
