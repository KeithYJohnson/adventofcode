class Move
  attr_accessor :instructions,
                :current_direction,
                :x,
                :y

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
  end

  def perform
    instructions.each { |instruction|  move(instruction.strip) }
    puts "\nchange in x: #{x}"
    puts "change in y: #{y}"
    puts "total_blocks: #{x + y}"
  end

  def move(instruction)
    rotation = instruction[0] #Can only be "L" or "R"
    magnitude = instruction[1..-1] # ie 1, 23, 103 etc

    rotate(rotation)
    advance(magnitude)
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
end

s = "L4, L3, R1, L4, R2, R2, L1, L2, R1, R1, L3, R5, L2, R5, L4, L3, R2, R2, L5, L1, R4, L1, R3, L3, R5, R2, L5, R2, R1, R1, L5, R1, L3, L2, L5, R4, R4, L2, L1, L1, R1, R1, L185, R4, L1, L1, R5, R1, L1, L3, L2, L1, R2, R2, R2, L1, L1, R4, R5, R53, L1, R1, R78, R3, R4, L1, R5, L1, L4, R3, R3, L3, L3, R191, R4, R1, L4, L1, R3, L1, L2, R3, R2, R4, R5, R5, L3, L5, R2, R3, L1, L1, L3, R1, R4, R1, R3, R4, R4, R4, R5, R2, L5, R1, R2, R5, L3, L4, R1, L5, R1, L4, L3, R5, R5, L3, L4, L4, R2, R2, L5, R3, R1, R2, R5, L5, L3, R4, L5, R5, L3, R1, L1, R4, R4, L3, R2, R5, R1, R2, L1, R4, R1, L3, L3, L5, R2, R5, L1, L4, R3, R3, L3, R2, L5, R1, R3, L3, R2, L1, R4, R3, L4, R5, L2, L2, R5, R1, R2, L4, L4, L5, R3, L4"
m4 = Move.new(s)
m4.perform
