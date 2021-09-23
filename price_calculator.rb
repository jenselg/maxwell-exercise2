#!/usr/bin/env ruby

module PriceCalculator

    def self.init

        puts "Please enter all the items purchased separated by a comma:"

        user_input = gets.chomp # get input
        user_input = user_input.split(',') # split into array
        user_input = user_input.map { |item| item.strip } # cleanup extra whitespace

        if user_input.size > 0 # calculate price by quantity and any sale price
        else # exit early
            puts "You did not enter any valid items."
        end

    end

end

# start program
PriceCalculator.init
