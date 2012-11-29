require 'test/unit'
require_relative 'RestaurantInfo'
class TestPuzzle < Test::Unit::TestCase
    def test_load
      rest_info = load_data("sample_data.csv")
      assert rest_info.get_restaurants.size == 6
      assert rest_info.get_restaurants["1"].items.size == 2
    end

    def test_build_and_search
      rest_info = load_data("sample_data.csv")
      assert rest_info.build_and_search_item(["burger"]).eql?("1 4.0")
      assert rest_info.build_and_search_item(["fancy_european_water"]).eql?("6 5.0")
    end

    def test_inverted_index
      rest_info = load_data("sample_data.csv")
      rest_info.build_inverted_index("1", rest_info.get_restaurants["1"])
      assert rest_info.get_items.size == 2
      rest_info.build_inverted_index("2", rest_info.get_restaurants["1"])
      assert rest_info.get_items.size == 2
    end

    def load_data(path)
      rest_info = RestaurantInfo.new()
      rest_info.stage_data(path)
      rest_info
    end
end
