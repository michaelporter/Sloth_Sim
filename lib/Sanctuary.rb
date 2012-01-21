require 'lib/Sloth.rb'
require 'lib/PlantLife.rb'
require 'lib/Grid.rb'
require 'rubygems'
require 'ap'

class Sanctuary

  def initialize(sanc)
    @sanc = sanc  # an array of strings that demonstrate the boundaries and features
    @gridmaker = GridMaker.new(sanc)
    @grid = @gridmaker.gridit
    @sloths = []
    @plants = []
    @sloth_pop = 0
    @plant_pop = 0
  end

  def first_pass
    parse do |k, v, loc, surroundings|
  	  if v == "@"
  	    @sloths.push(Sloth.new(loc, @grid))
        #puts "found a sloth at #{loc.inspect}!"
  	  elsif v == "*"
  	    @plants.push(Plantlife.new(loc, @grid))
        #puts "found a plant at #{loc.inspect}!"
  	  end
  	end
  end

  def parse
    y = -1
    loc = Array.new
    surroundings = Hash.new
    @sanc.each do |k|
      y += 1
      x = -1
      k.each_char do |v|
        loc = []
      	loc=[x+=1, y]
      	surroundings = get_surroundings(loc)
        yield k, v, loc, surroundings if block_given?
      end
    end 
  end

  def step
    moved = 0
    standing = 0 
    eaten = 0
    mated = 0
    died = 0
    photo = 0
    reproduced = 0

    check_pop
    if @sloth_pop == 0 || @plant_pop == 0
      puts "Simulation ended"
      Process.exit
    end

    @sloths.each do |z|
      z.has_moved -= 1
      #puts z.energy
    end

    parse do |a, b, c, d|
      if b == "@"
        @sloths.each do |s|
          if s.has_moved > 0
            next
          end

          if s.location == c
          	action, dest = s.act(d, @grid)
            dest = d[dest]
            case action
	            when "eat"
	              p = ""
                @plants.each do |pp|
                  if pp.location == dest
                    p = pp
                  end
                end
                s.eat(dest, p)
                @grid[dest] = "@"
                @grid[c] = " "
                @sanc[c[1]][c[0]] = " "
                @sanc[dest[1]][dest[0]] = "@"
                @plants.each do |p|
                  if p.location == dest
                    @plants.delete(p)
                  end
                end
                eaten += 1
	            when "move"
	            	s.move(dest)
	            	@grid[dest] = "@"
                @grid[c] = " "
	            	@sanc[c[1]][c[0]] = " "
                @sanc[dest[1]][dest[0]] = "@"
                moved += 1
              when "mate"
                  new_sloth = s.mate#(dest, @grid)
                  @grid[dest] = "@"
                  @sanc[dest[1]][dest[0]] = "@"
                  @sloths.push(Sloth.new(dest, @grid))
                  ap @sloths
                  mated += 1
	            when "stand"
	            	s.stand
                standing += 1
              when "die"
                @grid[c] = " "
                @sanc[c[1]][c[0]] = " "
                @sloths.delete(s)
                died += 1
              else
                puts "sloth confused!"
	          end
          end
        end
      elsif b == "*"
      	@plants.each do |p|
      	  if p.location == c
      	  	action, dest = p.act(d, @grid)
            dest = d[dest]
      	  	case action
      	  	  when "reproduce"
                new_plant = p.reproduce(dest)
                @grid[dest] = "*"
                @sanc[dest[1]][dest[0]] = "*"
                @plants.push(new_plant)
                reproduced += 1
      	  	  when "photo"
      	  	  	p.photo
                photo += 1
            end
      	  end
      	end
      end
      update_creatures
    end
    puts "There are #{@sloths.length} sloths, and #{@plants.length} plants."
    puts "#{moved} sloths have moved."
    puts "#{standing} sloths are standing"
    puts "#{eaten} sloths have eaten."
    puts "#{mated} sloths have mated."
    puts "#{died} sloths have died."
    puts "#{reproduced} plants have reproduced."
    puts "#{photo} plants have photosynthesized."
  end

  def update_creatures
    #@sloths.each do |s|
    #  s.grid = @grid
    #end

    @plants.each do |p|
      p.grid = @grid
    end
  end

  def get_surroundings(point)  # allows you to get surroundings for any point at any time
    x = point[0]
    y = point[1]
    current ={:n => [x, y-1], :s => [x, y+1], :e => [x+1, y], :w => [x-1, y], :ne => [x+1, y-1], :nw => [x-1, y-1], :se => [x+1, y+1], :sw => [x-1, y+1]}

    current.each_pair do |j, h|
      h.each do |i|
        if i < 0 then current.delete(j)
        end
      end
    end
    current.each_pair do |j, h|
      if @grid[h] == "#" then current.delete(j)
      end
    end
    current
  end

  def check_pop
    @sloth_pop = 0
    @plant_pop = 0
    parse do |a, b, c, d|
      if b == "@"
        @sloth_pop += 1
      elsif b == "*"
        @plant_pop += 1
      end
    end
  end

  def print_sanc
    puts @sanc
  end
end