require 'rubygems'
require 'ap'

class Sloth

  attr_accessor :location, :energy, :starting_energy, :has_moved, :has_mated


  def initialize(loc, grid)
    @starting_energy = rand(20) + 10
    @energy = @starting_energy
    @speed = 1
    @metabolism = 5
    @sleepiness = 3
    @location = loc  # [x, y]; where x is index of char, and y is index of string in sanc
    #@grid = grid   # for more advanced decisions
    @has_moved = 0
    @has_mated = 0
    @childhood = 5
  end
  
  def act(surroundings, grid)
  	@energy -= 1
    @childhood -= 1 unless @childhood == 0
    options = {}
    key = []
    i = 0
    surroundings[:c] = @location

    if @energy <= 0
      i +=1
      return "die"
    end

    until i == 1
      c = choose_direction(surroundings, grid)
      n = surroundings[c]  # this makes me think that maybe I don't need the hash
      if grid[n] == "*"
        i = 1
        return "eat", c
      elsif grid[n] == " "
        i = 1
        return "move", c
      elsif grid[n] == "@"
        u = 0
        r = 0
        while u != 1 || r != surroundings.length-1
          rep = choose_direction(surroundings, grid, c)
          n = surroundings[rep]
          if grid[n] == " "
            i = 1
            u = 1
            return "mate", rep
          elsif r == surroundings.length-1
            i = 1
            u = 1
            return "stand", @location
          else
            r += 1
          end
        end
      else
        return "stand", :c
      end
    end
  end

  def choose_direction(surroundings, grid, exclude = nil)
    choice = nil
    best = []
    middle = []
    worst = []

    surroundings.each_pair do |dir, val|    # will want to rearrange the order of these depending
                                            # on the maturity of the sloth, and how much energy it has.
      case grid[val]       # Can abstract all of this, to accept the characters in different
                           # orders based on the sloth's survival-based needs at a given moment.
        when "*"
          best.push(dir) unless dir == exclude
        when "@"
          if dir != :c && @has_mated == 0 && @energy > 10 && @childhood == 0
            middle.push(dir) unless dir == exclude
          end
        when " "
          worst.push(dir) unless dir == exclude
      end
    end
    
    if !best.empty?
      options = best.shuffle!
      choice = options[0]
    elsif best.empty? && !middle.empty?
      options = middle.shuffle!
      choice = options[0]
    elsif best.empty? && middle.empty? && !worst.empty?
      options = worst.shuffle!
      choice = options[0]
    else
      choice = :c
    end
    return choice
  end

  def move(dest)
    @location = dest
    @has_moved = 1
  end

  def eat(dest, plant)
    @energy += (plant.energy/3).to_i
    move(dest)
    @has_moved = 1
  end

  def stand
    @energy -= 0.5
  end

  def mate    # Stiiiiiiiilllll doesn't take into account the other sloth
    @energy -= 4
    @has_moved = 1
    @has_mated = rand(9)+3
  end
end

