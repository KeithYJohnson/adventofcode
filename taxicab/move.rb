class Move
  attr_accessor :instructions,
                :current_direction,
                :x,
                :y,
                :positions

  ROTATION_TO_INT_MAP = {
    L: -1,
    R:  1
  }

  def initialize(instructions)
    self.instructions = instructions.split(",")
    self.current_direction = 0
    #Starting point, all moves are relative to this starting position
    self.x = 0
    self.y = 0
    self.positions = []
  end

  def perform
    instructions.each { |instruction|  move(instruction.strip) }
    puts "\nchange in x: #{x}"
    puts "change in y: #{y}"
    puts "blocks_away: #{blocks_away}"
  end

  def move(instruction)
    rotation = instruction[0] #Can only be "L" or "R"
    magnitude = instruction[1..-1] # ie 1, 23, 103 etc

    rotate(rotation)
    advance(magnitude)
    track_position
    if was_i_here_before?
      puts "Looks like we've been here before: #{current_position}, its #{blocks_away} blocks away"
    end
  end

  def rotate(direction)
    rotation_int = ROTATION_TO_INT_MAP[direction.to_sym]
    self.current_direction = (current_direction + rotation_int) % 4
  end

  def advance(magnitude)
    magnitude = magnitude.to_i
    case current_direction
    when 0                #  Pointing north
      self.y += magnitude
    when 1                #  Pointing east
      self.x += magnitude
    when 2                #  Pointing south
      self.y -= magnitude
    when 3                #  Pointing west
      self.x -= magnitude
    else
      raise "How many dimensions we got here?!"
    end
  end

  def track_position
    last_x = positions.last[0]
    last_y = positions.last[1]

    x_diff = last_x - x
    y_diff = last_y - y

    #Should really extend ruby's range object here
    #be decrementable as well.  Also DRY this up
    if x_diff.abs > 0
      if last_x > x
        (last_x - 1).downto(x) do |i|
          positions << [i, y]
          was_i_here_before?
        end
      else
        (last_x...x).each do |i|
          positions << [i + 1, y]
          was_i_here_before?
        end
      end
    end

    if y_diff.abs > 0
      if last_y > y
        (last_y - 1).downto(y) do |i|
          positions << [x, i]
          was_i_here_before?
        end
      else
        (last_y...y).each do |i|
          positions << [x, i + 1]
          was_i_here_before?
        end
      end
    end
  end

  def was_i_here_before?
    previous_positions.detect { |position| position == current_position }
  end

  def previous_positions
    positions[0..-2] #Excludes the last and current position
  end

  def current_position
    positions.last
  end

  def blocks_away
    current_position.map(&:abs).inject(:+)
  end
end

s = "L4, L3, R1, L4, R2, R2, L1, L2, R1, R1, L3, R5, L2, R5, L4, L3, R2, R2, L5, L1, R4, L1, R3, L3, R5, R2, L5, R2, R1, R1, L5, R1, L3, L2, L5, R4, R4, L2, L1, L1, R1, R1, L185, R4, L1, L1, R5, R1, L1, L3, L2, L1, R2, R2, R2, L1, L1, R4, R5, R53, L1, R1, R78, R3, R4, L1, R5, L1, L4, R3, R3, L3, L3, R191, R4, R1, L4, L1, R3, L1, L2, R3, R2, R4, R5, R5, L3, L5, R2, R3, L1, L1, L3, R1, R4, R1, R3, R4, R4, R4, R5, R2, L5, R1, R2, R5, L3, L4, R1, L5, R1, L4, L3, R5, R5, L3, L4, L4, R2, R2, L5, R3, R1, R2, R5, L5, L3, R4, L5, R5, L3, R1, L1, R4, R4, L3, R2, R5, R1, R2, L1, R4, R1, L3, L3, L5, R2, R5, L1, L4, R3, R3, L3, R2, L5, R1, R3, L3, R2, L1, R4, R3, L4, R5, L2, L2, R5, R1, R2, L4, L4, L5, R3, L4"
m4 = Move.new(s)
m4.perform
