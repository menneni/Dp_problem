class InvertedIndexClass
  # This class holds the value for the every inverted index item. It has the item id, item price, restaurant id, min price and addedIds are being populated during the algoritm
  attr_accessor :id, :price, :restaurantId, :minprice , :addedIds

  #constructor
  def initialize(id ,price, restaurantId, minPrice, addedIds)
    @id, @price, @restaurantId, @minprice, @addedIds = id, price, restaurantId, minPrice, addedIds
  end

  #overload <=> operator for custom sort
  def <=>(anOther)
    minprice <=> anOther.minprice
  end


end