require 'rubygems'
require 'ap'

class GridMaker < Hash
  
  def initialize(sanc)
    @sanc = sanc
  end

  def gridit # creates a hash-based grid interface for the given sanctuary field.  
  	grid = self
    y = -1
  	@sanc.each do |k|
     y += 1
     x = -1
  	  k.each_char do |v|
        point = [x+=1, y]
  	    grid[point] = v
  	  end
    end  
    return self
  end

  def change_val(loc, to)
    self[loc] = to
    @sanc
  end
end

