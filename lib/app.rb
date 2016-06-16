require 'json'

def start
  setup_files
  create_report
end

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def average_price(sales, quantities)
  sales / quantities.count
end


# Print "Sales Report" in ascii art
def print_sales_report
  puts "               .__                                                        __    "
  puts "  ___________  |  |   ____   ______  _______   ____ ______  ____________/  |_  "
  puts " /  ___/\\__  \\ |  | _/ __ \\ /  ___/  \\_  __ \\_/ __ \\____ \\ /  _ \\_  __ \\   __\\ "
  puts " \\___\\   /  __\\|  |_\\  ___/ \\___ \\    |  | \\/\\  ___/|  |_>>  <_> )  | \\/|  |   "
  puts "/____  >(____  /____/\\___  >____  >   |__|    \\___  >   __/\\____/|__|   |__|   "
  puts "     \\/      \\/          \\/     \\/                \\/|__|                        "
  puts
end

# Print today's date
def print_time
  time = Time.now
  puts time.strftime("Printed on %m/%d/%Y")
end

def print_product_report
  print_product_report_header
  print_product_report_data
end

# Print "Products" in ascii art
def print_product_report_header
  puts "                     _            _       "
  puts "                    | |          | |      "
  puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  puts "| |                                       "
  puts "|_|                                       "
  puts
end

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
def print_product_report_data
  $products_hash["items"].each do |product|

  # Print the name of the toy
  puts "Product name: " + product["title"]

  # Print the retail price of the toy
  puts "Retail price: $" + product["full-price"]

  # Calculate and print the total number of purchases
  puts "Total number of purchases: " + product["purchases"].count.to_s

  # Calculate and print the total amount of sales
  sales = []
  product["purchases"].each do |price|
    sales << price["price"]
  end
  total_sales = sales.inject(0) { |result, element| result + element }
  puts "Total amount of sales: $" + total_sales.to_s

  # Calculate and print the average price the toy sold for
  puts "Average price is $" + average_price(total_sales, product["purchases"]).to_s

  # Calculate and print the average discount (% or $) based off the average sales price
  # average_discount = ( product["full-price"].to_f - average_price ) / product["full-price"].to_f * 100
  # puts "Average discount: " + average_discount.round(2).to_s + "%"

  #add line divider
  50.times { print "_" }
  puts
  end
end

# Print "Brands" in ascii art
def print_brand_report
  print_brand_report_header
  print_brand_report_data
end

def print_brand_report_header
  puts " _                         _     "
  puts "| |                       | |    "
  puts "| |__  _ __ __ _ _ __   __| |___ "
  puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  puts "| |_) | | | (_| | | | | (_| \\__ \\"
  puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  puts
end

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total sales volume of all the brand's toys combined
def print_brand_report_data
  brands = []
  $products_hash["items"].each do |product|
    brands << product["brand"] unless brands.include? product["brand"]
  end
  puts "There are " + brands.count.to_s + " brands. They are: " + brands.to_s

  #add line divider
  65.times { print "_" }
  puts

  brands.each do |brand|
    brand_stock = 0
    brand_price = 0
    brand_revenue = 0
    brand_qty_sold = 0
    brand_item_counter = 0

    $products_hash["items"].each do |product|
      if product["brand"] == brand
        brand_item_counter += 1
        brand_stock += product["stock"]
        brand_price += product["full-price"].to_f
        product["purchases"].each do |purchase|
          brand_qty_sold += 1
          brand_revenue += purchase["price"]
        end
      end
    end
    # Count and print the number of the brand's toys we stock
    puts brand.to_s + " has " + brand_stock.to_s + " quantities in stock"
    # Calculate and print the average price of the brand's toys
    puts "The average price for " + brand + " brand is: $" + (brand_price / brand_item_counter).round(2).to_s
    # Calculate and print the total revenue of all the brand's toy sales combined
    puts "The store has sold " + brand + " brand for a total of: $" + brand_revenue.round(2).to_s
    #add line divider
    65.times { print "_" }
    puts
  end
end

def create_report
  print_sales_report
  print_time
  print_product_report
  print_brand_report
end

start