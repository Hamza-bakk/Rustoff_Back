# db/seeds.rb

# Clear existing records
Item.destroy_all

# Seed data for items
items_data = [
  {
    title: "Item 1",
    description: "Description for Item 1",
    price: 19.99,
    image_url: "image1.png",
    alt: "Image 1 Alt Text",
    category: "Animation",
    disabled: false
  },
  {
    title: "Item 2",
    description: "Description for Item 2",
    price: 29.99,
    image_url: "image2.png",
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
