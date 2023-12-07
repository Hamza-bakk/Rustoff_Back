# db/seeds.rb

# Clear existing records
Item.destroy_all

# Seed data for items
items_data = [
  {
    title: "Item 1",
    description: "Description for Item 1",
    price: 19.99,
    image_url: "https://imgs.search.brave.com/opW2mfM4WR2Q90zc9PDSY0rKCL08WJrBOrGR9sJs97I/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE2/MDc5MTc2Ny9mci9w/aG90by9jaGV2YWwt/cmlhbnQuanBnP3M9/NjEyeDYxMiZ3PTAm/az0yMCZjPUItWjdH/bzVqaXZyVFNOS0JR/clJJdG9rU1k2UV9w/U3NKQ0N5VnpmMFdP/a1U9",
    alt: "Image 1 Alt Text",
    category: "Animation",
    disabled: false
  },
  
  {
    title: "Item 2",
    description: "Description for Item 2",
    price: 29.99,
    image_url: "https://imgs.search.brave.com/I26EV9Z3LcNGfMwRWh5gzszGWqJcpUqv5a1IInn59is/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvNDcz/MDEyNjYwL2ZyL3Bo/b3RvLyVDMyVBOWN1/cmV1aWwtZ3Jpcy1i/JUMzJUEyaWxsZXIu/anBnP3M9NjEyeDYx/MiZ3PTAmaz0yMCZj/PThSM2JLUUNtb0Z2/a3RRNXEwUXNyeGNS/MjBITEpOREZLdXhz/SUJMb0R6ZVU9",
    alt: "Image 2 Alt Text",
    category: '3D',
    disabled: false
  }
]

# Create items with validations
items_data.each do |item_data|
  item = Item.new(item_data)
  if item.save
    puts "Item '#{item.title}' created successfully!"
  else
    puts "Error creating item '#{item.title}': #{item.errors.full_messages.join(', ')}"
  end
end

puts "Seed data for items created successfully!"
