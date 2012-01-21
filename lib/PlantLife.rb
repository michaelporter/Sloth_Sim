class Plantlife

  attr_accessor :grid, :location, :energy, :starting_energy

  def initialize(loc, grid)
    @starting_energy = rand(6) + 2
    @energy = @starting_energy
    @location = loc
    @reprate = rand(15) + 3
    @grid = grid
  end

  def act(surroundings, grid)
    surroundings.each_pair do |w, q|
      if grid[q] == " " && @energy >= @reprate
        return "reproduce", w
      elsif @energy < @reprate
        return "photo", w
      end
    end
  end

  def reproduce(dest)
    @energy -= 5
    Plantlife.new(dest, @grid)
  end

  def photo
  	@energy += 1
  end

end

