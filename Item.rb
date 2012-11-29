class Item

  # This class has id, price and names as attributes. Every item has unique id, the names of the item could be individual name or the combo of names
  attr_accessor :id, :price, :names

  #constructor
  def initialize(id, price, names)
    @id, @price, @names = id, price, names
  end

end