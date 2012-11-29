require 'csv'
require_relative 'InvertedIndexClass'
require_relative 'Item'
require_relative 'Restaurant'
class RestaurantInfo
  #The entry point for the algo to start. This method stages the data, runs the alogrithm and gives the desired output

  #This method stages the data of the given input CSV file. A hash is created using key as restaurant id and values as Item classes
  def stage_data(file)
    @restaurants  = {}
    i=1
    CSV.foreach(file) do |elements|
      next if elements.size == 0
      if elements.size < 3
        puts "Invalid file row"
        exit
      end
      begin
        Integer(elements[0])
        Float(elements[1])
      rescue
        puts "Restaurant Id and price needs to be in  number format"
        exit
      end
      if(@restaurants[elements[0]])
        @restaurants[elements[0].strip].items.push( Item.new(i, elements[1].strip.to_f, elements[2..elements.size-1].collect{|x| x.strip}))
      else
        @restaurants[elements[0].strip] = Restaurant.new(elements[0], Array.new([Item.new(i, elements[1].strip.to_f, elements[2..elements.size-1].collect{|x| x.strip})]))
      end      
      i = i +1
    end
  end

   #getter for restaurants
   def get_restaurants
     @restaurants
   end
   
   #getter for invertedIndex
   def get_items
     @items
   end
  #this method builds the inverted index for the items in a restaurant. In the inverted index, key is the item name and values are InvertedIndexclass items which hold the info abt the item and restaurant
  def build_inverted_index(key, restaurant)
    @items  = {}
    restaurant.items.each do |item|
      item.names.each do |name|
        if(@items[name])
          @items[name].push(InvertedIndexClass.new(item.id, item.price, key, item.price, Array.new([item.id])))
        else
          @items[name] = Array.new([InvertedIndexClass.new(item.id, item.price, key, item.price , Array.new([item.id]))])
        end
      end
    end
  end

  #this finds the min cost of the given input for individual restaurant and outputs the final result.
  def build_and_search_item(list)
    mincost = 9999999
    restId = nil
    @restaurants.each_pair  do |key, restaurant|
      build_inverted_index(key, restaurant)
      iIndex = find_min_priced_restauarnt(list)
      if iIndex and mincost > iIndex.minprice
        mincost = iIndex.minprice
        restId = iIndex.restaurantId
      end
    end
    restId.nil? ?   "nil" : "#{restId} #{mincost}"

  end

  #the actual algorithm to find the minimum cost using the inverted index that is build
  def find_min_priced_restauarnt(list)
    @searchItems = []
    list.each do |name|
      @searchItems.push(@items[name])
    end
    #return the nil values
    @searchItems.compact!

    #check for empty array
    return nil if @searchItems.size == 0 || @searchItems.size < list.size


    #using dynamic programming to solve this problem
    #Using the multi stage graph approach. Consider each searchItem which is list of invertedIndex as a level with nodes.
    #If the last level(n) is destination, then find the mincost from every node in level(n-1) to level(n) , find the min price and store it in the attribute called  minprice of invertedIndex class.
    # so now the we have minimimum cost from n-1 to n. Now similary construct it from n-2 level to n-1(which inturn is till nth level).
    # finally at level 1 we have all the elements with the all the cost. Sort them and return the min priced.

    if @searchItems.size  > 1
      count = @searchItems.size

      @searchItems.reverse.each do |item|
        if count == @searchItems.size
          count = count - 1
          next
        end
        successorItem = @searchItems[count]
        item.each do |iIndex|
          cost = 9999999
          id = iIndex.id
          successorItem.each  do |sItem|

            if sItem.addedIds.include?(iIndex.id)
              iIndex.minPrice = sItem.minPrice
              id = iIndex.id

            elsif cost > (sItem.price + iIndex.price)
              cost = sItem.price + iIndex.price
              iIndex.minprice = cost
              id = sItem.id
            end
          end
          iIndex.addedIds = iIndex.addedIds.concat([id])
        end
      end

    end
    #should find the min of this array
    temp = @searchItems[0].sort
    temp[0]
  end


end
