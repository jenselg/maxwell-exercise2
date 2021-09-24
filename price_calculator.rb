#!/usr/bin/env ruby
require 'json'

module PriceCalculator

    # start program and get user input
    def self.init

        puts "\nPlease enter all the items purchased separated by a comma:"

        product_array = gets.chomp
        product_array = product_array.split(',')
        product_array = product_array.map { |item| item.strip }

        if product_array.size > 0
            calculate_prices(product_array)
        else
            puts "You did not enter any valid items."
        end

    end # self.init ...

    # get output from init method and calculate prices based on quantity
    def self.calculate_prices(products)

        product_price_array = []
        prices = JSON.parse(File.open('prices.json').read) rescue nil
        
        unless prices.nil?

            products.each do |product|

                curr_product_index = product_price_array.find_index { |product_price| product_price["name"].downcase == product.downcase }
                curr_price_index = prices.find_index { |price| price["name"].downcase == product.downcase }
                
                if curr_product_index.nil? && !curr_price_index.nil?
                    curr_product_price = {}
                    curr_product_price["name"] = prices[curr_price_index]["name"]
                    curr_product_price["quantity"] = 1
                    curr_product_price["price"] = prices[curr_price_index]["price"].to_f
                    curr_product_price["total"] = (prices[curr_price_index]["price"].to_f * curr_product_price["quantity"]).round(2)
                    product_price_array << curr_product_price
                elsif !curr_price_index.nil?
                    product_price_array[curr_product_index]["quantity"] += 1
                    product_price_array[curr_product_index]["total"] = (product_price_array[curr_product_index]["quantity"] * product_price_array[curr_product_index]["price"]).round(2)
                end

            end

            if product_price_array.size > 0
                calculate_discounts(product_price_array)
            else
                puts "The item(s) you entered do not have a price defined."
            end

        else
            raise "Could not read and parse prices.json!"
        end

    end # self.calculate_prices ...

    # get output from calculate_prices method and calculate any applicable discounts
    def self.calculate_discounts(products)

        discounts = JSON.parse(File.open('discounts.json').read) rescue nil

        unless discounts.nil?

            products.each do |product|

                product["savings"] = 0.00
                product_discount_index = discounts.find_index { |discount| discount["product"].downcase == product["name"].downcase }
                
                unless product_discount_index.nil?

                    discount = discounts[product_discount_index]
                    if product["quantity"].to_i >= discount["quantity"].to_i

                        discount_multiplier = product["quantity"].to_i / discount["quantity"].to_i
                        discount_quantity_remainder = product["quantity"].to_i % discount["quantity"].to_i
                        total_no_discount = product["total"].to_f
                        total_with_discount = (discount_multiplier * discount["price"].to_f) + (product["price"].to_f * discount_quantity_remainder)
                        product["total"] = total_with_discount
                        product["savings"] = (total_no_discount - total_with_discount).round(2)

                    end

                end

            end

            build_output(products)

        else
            raise "Could not read and parse discounts.json!"
        end

    end # self.calculate_discounts ...

    # get output from calculate_discounts method and build CLI table and other details
    def self.build_output(products)
        puts "\n"
        puts "Item     Quantity      Price"
        puts "--------------------------------------"
        products.each do |product|
            puts "#{product["name"].ljust(9)}#{product["quantity"].to_s.ljust(13)} $#{product["total"]}"
        end
        puts "\n"

        total_sum = products.map { |product| product["total"] }.reduce(0, :+)
        puts "Total price : $#{total_sum}"

        total_discount = products.map { |product| product["savings"] }.reduce(0, :+)
        puts "You saved $#{total_discount} today."
        puts "\n"
    end # self.build_output ...

end # module PriceCalculator ...

# start program
PriceCalculator.init
