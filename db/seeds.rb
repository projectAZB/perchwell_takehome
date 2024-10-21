
puts "Clearing existing clients, custom fields, and buildings..."
Client.destroy_all
CustomField.destroy_all
Building.destroy_all


# Create 5 clients
puts "Seeding the database with clients, buildings and custom fields..."

client_names =  ["Mark Jones", "Tom Dooley", "Stan Folie", "Jon Jackson", "Pierre Janet"]
clients = []

client_names.each_with_index do |client_name, i|
  client = Client.create!(
    id: i + 1,
    name: client_name,
  )
  clients.push(client)
  puts "Created client: #{client.name}"
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create client #{i + 1}: #{e.message}"
end

clients.each do |client|
  if client.id == 1
    CustomField.create!(
      id: 1,
      name: "Chimneys",
      value_type: 0,
      client: client,
    )
    CustomField.create!(
      id: 2,
      name: "Material",
      value_type: 2,
      client: client,
      value: "Brick, Wood, Concrete, or Stone",
    )
  end
  if client.id == 2
    CustomField.create!(
      id: 3,
      name: "Pool",
      value_type: 2,
      client: client,
      value: "Yes, No"
    )
    CustomField.create!(
      id: 4,
      name: "Chimneys",
      value_type: 0,
      client: client,
    )
  end
  if client.id == 3
    CustomField.create!(
      id: 5,
      name: "Century Built",
      value_type: 1,
      client: client,
    )
    CustomField.create!(
      id: 6,
      name: "Entrances",
      value_type: 0,
      client: client,
    )
  end
  if client.id == 4
    CustomField.create!(
      id: 7,
      name: "Square Feet",
      value_type: 0,
      client: client,
    )
    CustomField.create!(
      id: 8,
      name: "Architectural Style",
      value_type: 1,
      client: client,
    )
    CustomField.create!(
      id: 9,
      name: "Floors",
      value_type: 0,
      client: client,
    )
  end
  if client.id == 5
    CustomField.create!(
      id: 10,
      name: "Floors",
      value_type: 0,
      client: client,
    )
    CustomField.create!(
      id: 11,
      name: "Square Feet",
      value_type: 0,
      client: client,
    )
    CustomField.create!(
      id: 12,
      name: "Yard Type",
      value_type: 2,
      client: client,
      value: "Grass, Forest, None"
    )
  end
end

puts "Seeding completed!"

# Output the total number of clients
puts "Total number of clients: #{Client.count}"
