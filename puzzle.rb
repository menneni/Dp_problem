require 'csv'
require_relative 'InvertedIndexClass'
require_relative 'Item'
require_relative 'Restaurant'
require_relative 'RestaurantInfo'

rest_info = RestaurantInfo.new()
if ARGV.size < 2
  puts "Less number of arguments"
  exit
end
if(!File.exists?(ARGV[0]))
  puts "File not found"
  exit
end
rest_info.stage_data(ARGV[0])
puts rest_info.build_and_search_item(ARGV[1..ARGV.length-1])
