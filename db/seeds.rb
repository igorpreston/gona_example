seeds_dir = File.join(Rails.root, 'db', 'seeds')

Dir[File.join(seeds_dir, '*.rb')].sort.each do |file|
  puts "Loading seed file: #{file}"
  load file
end

# App::TEMPLATES.each do |template, _klass|
#   App.find_or_create_by(template:) do |app|
#     app.published = true
#   end
# end

# if Rails.env.development?
#   # Create organization
#   #
#   igor = User.find_or_create_by(
#     email: 'igor@gona.test'
#   ) do |user|
#     user.first_name = 'Igor'
#     user.last_name = 'Preston'
#     user.password = 'admin123'
#     user.role = :owner
#     user.color = :teal
#   end

#   organization = Organization.find_or_create_by(
#     name: 'Kinton Ramen',
#     legal_name: 'Kinton Ramen Inc.'
#   ) do |org|
#     org.nickname = 'kinton_ramen'
#     org.email = 'hq@kinton.com'
#     org.stripe_account_id = 'acct_1MbZncBQRzqmpRRX'
#     org.owner_id = igor.id
#     org.address_attributes = {
#       line_one: '123 Main St',
#       line_two: 'Suite 100',
#       city: 'Toronto',
#       state: 'ON',
#       zip: 'L5B 1M2',
#       country: 'CA',
#       default: true
#     }
#   end

#   anton = User.find_or_create_by(
#     email: 'anton@gona.test'
#   ) do |user|
#     user.first_name = 'Anton'
#     user.last_name = 'Sergeev'
#     user.password = 'admin123'
#     user.color = :sky
#   end

#   organization.users << [igor, anton]

#   # Create locations
#   #
#   location_one = organization.locations.find_or_create_by(
#     name: 'Toronto'
#   ) do |location|
#     location.tax_rate = Rails.application.config.tax_rate
#     location.application_fee_rate = Rails.application.config.application_fee_rate
#     location.auto_accept_order = true
#     location.expected_preparation_time_seconds = 1_800 # 30 minutes
#     location.address_attributes = {
#       line_one: '123 Main St',
#       line_two: 'Suite 100',
#       city: 'Toronto',
#       state: 'ON',
#       zip: 'L5B 1M2',
#       country: 'CA'
#     }
#   end

#   location_two = organization.locations.find_or_create_by(
#     name: 'Vancouver'
#   ) do |location|
#     location.tax_rate = Rails.application.config.tax_rate
#     location.application_fee_rate = Rails.application.config.application_fee_rate
#   end

#   # Menus
#   breakfast = Menu.find_or_create_by(name: 'Breakfast', organization:)
#   lunch = Menu.find_or_create_by(name: 'Lunch', organization:)
#   dinner = Menu.find_or_create_by(name: 'Dinner', organization:)

#   # Categories
#   dish_category = Category.find_or_create_by(name: 'Dishes', organization:)
#   sushi_category = Category.find_or_create_by(name: 'Sushi', organization:)
#   coffee_category = Category.find_or_create_by(name: 'Coffee', organization:)
#   tea_category = Category.find_or_create_by(name: 'Tea', organization:)
#   dessert_category = Category.find_or_create_by(name: 'Desserts', organization:)

#   # Items
#   10.times do
#     dish_category.category_items.create(
#       item: Item.find_or_create_by(
#         name: Faker::Food.unique.dish,
#         price_cents: rand(100..900),
#         source: :catalog,
#         organization:
#       ),
#       organization:
#     )
#   end

#   5.times do
#     sushi_category.category_items.create(
#       item: Item.find_or_create_by(
#         name: Faker::Food.unique.sushi,
#         price_cents: rand(100..900),
#         source: :catalog,
#         organization:
#       ),
#       organization:
#     )
#   end

#   4.times do
#     coffee_category.category_items.create(
#       item: Item.find_or_create_by(
#         name: Faker::Coffee.unique.blend_name,
#         price_cents: rand(100..900),
#         source: :catalog,
#         organization:
#       ),
#       organization:
#     )
#   end

#   3.times do
#     tea_category.category_items.create(
#       item: Item.find_or_create_by(
#         name: Faker::Tea.unique.variety,
#         price_cents: rand(100..900),
#         source: :catalog,
#         organization:
#       ),
#       organization:
#     )
#   end

#   2.times do
#     dessert_category.category_items.create(
#       item: Item.find_or_create_by(
#         name: Faker::Dessert.unique.variety,
#         price_cents: rand(100..900),
#         source: :catalog,
#         organization:
#       ),
#       organization:
#     )
#   end

#   # Add categories to menus
#   [coffee_category, tea_category, dessert_category].map do |category|
#     mc = breakfast.menu_categories.find_or_create_by(
#       category:,
#       organization:
#     )

#     category.items.map do |item|
#       mc.menu_category_items.find_or_create_by(
#         item:,
#         organization:
#       )
#     end
#   end

#   [dish_category, sushi_category, coffee_category, tea_category, dessert_category].map do |category|
#     mc = lunch.menu_categories.find_or_create_by(
#       category:,
#       organization:
#     )

#     category.items.map do |item|
#       mc.menu_category_items.find_or_create_by(
#         item:,
#         organization:
#       )
#     end
#   end

#   [dish_category, sushi_category, tea_category, dessert_category].map do |category|
#     mc = dinner.menu_categories.find_or_create_by(
#       category:,
#       organization:
#     )

#     category.items.map do |item|
#       mc.menu_category_items.find_or_create_by(
#         item:,
#         organization:
#       )
#     end
#   end

#   # Add menus to locations
#   menus_one = [breakfast, lunch, dinner]
#   menus_two = [lunch, dinner]

#   menus_one.each do |menu_one|
#     LocationMenu.find_or_create_by(location: location_one, menu: menu_one, organization:)
#   end

#   menus_two.each do |menu_two|
#     LocationMenu.find_or_create_by(location: location_two, menu: menu_two, organization:)
#   end
# end
