class Restaurant

  # This class has id and items as attributes. Every restaurant has unique id and items are the menu items of type Item class

  attr_accessor :id

  attr_accessor :items

  #constructor
  def initialize(id, items)
    @id, @items = id, items
  end


end