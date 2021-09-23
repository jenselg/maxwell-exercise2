#!/usr/bin/env ruby
require 'json'

module PriceCalculator

    # start program and get user input
    def self.init

        puts "Please enter all the items purchased separated by a comma:"

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
    def self.calculate_prices(output_init)

        user_products = output_init
        product_price_array = []
        prices = JSON.parse(File.open('prices.json').read) rescue nil
        
        unless prices.nil?

            user_products.each do |product|

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

            calculate_discounts(product_price_array)

        else
            puts "Could not read and parse prices.json!"
        end

    end # self.calculate_prices ...

    # get output from calculate_prices method and calculate any applicable discounts
    def self.calculate_discounts(output_calculate_prices)
        puts output_calculate_prices
    end # self.calculate_discounts ...

    # get output from calculate_discounts method and build CLI table and other details
    def self.build_output(output_calculate_discounts)
    end # self.build_output ...

end # module PriceCalculator ...

# start program
PriceCalculator.init
