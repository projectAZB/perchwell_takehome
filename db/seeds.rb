
puts "Clearing existing clients, custom fields, and buildings..."
Client.destroy_all
CustomField.destroy_all
Building.destroy_all


puts "Seeding the database with clients, custom fields, and buildings..."

client_names =  ["Sigmund Freud", "Carl Jung", "William James", "Ivan Pavlov", "Pierre Janet"]
clients = []

# Seed Clients
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

# Seed Custom Fields
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
      name: "Live-In Super",
      value_type: 2,
      client: client,
      value: "Yes, No"
    )
    CustomField.create!(
      id: 4,
      name: "Floor",
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
      name: "Backyard Type",
      value_type: 2,
      client: client,
      value: "Grass, Concrete, None"
    )
  end
end

# Seed Buildings
clients.each do |client|
  if client.id == 1
    Building.create!(
      id: 1,
      client: client,
      address: "812 Northwood Drive",
      state: "PA",
      zip_code: "17042",
      custom_field_values: {
        1 => "2",
        2 => "Brick",
      }
    )
    Building.create!(
      id: 2,
      client: client,
      address: "12 Nowlen Street",
      state: "PA",
      zip_code: "17042",
      custom_field_values: {
        1 => "1",
        2 => "Stone",
      }
    )
  end
  if client.id == 2
    Building.create!(
      id: 3,
      client: client,
      address: "222 Mulberry Street",
      state: "NY",
      zip_code: "10012",
      custom_field_values: {
        3 => "No",
        4 => "3",
      }
    )
    Building.create!(
      id: 4,
      client: client,
      address: "3 Spring Street",
      state: "NY",
      zip_code: "10012",
      custom_field_values: {
        3 => "Yes",
        4 => "5",
      }
    )
  end
  if client.id == 3
    Building.create!(
      id: 5,
      client: client,
      address: "1 Old Mine Road",
      state: "PA",
      zip_code: "17042",
      custom_field_values: {
        5 => "20th",
        6 => "1",
      }
    )
    Building.create!(
      id: 6,
      client: client,
      address: "674 Maple Street",
      state: "PA",
      zip_code: "17042",
      custom_field_values: {
        5 => "21st",
        6 => "2",
      }
    )
  end
  if client.id == 4
    Building.create!(
      id: 7,
      client: client,
      address: "123 Prince Street",
      state: "NY",
      zip_code: "10012",
      custom_field_values: {
        7 => "500",
        8 => "Gothic",
        9 => "10",
      }
    )
  end
  if client.id == 5
    floors = ["1", "2", "3", "4", "5"]
    square_feet = ["200", "300", "400", "500", "600"]
    yard_types = ["Grass", "Concrete", "None"]
    # Make a lot of buildings for pagination 
    25.times do |i|
      Building.create!(
        client: client,
        address: "#{i} Bowery",
        state: "NY",
        zip_code: "10012",
        custom_field_values: {
          10 => floors.sample,
          11 => square_feet.sample,
          12 => yard_types.sample,
        }
      )
    end
  end
end

puts "Seeding completed!"
