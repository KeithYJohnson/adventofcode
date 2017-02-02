require 'matrix'

FILEPATH = 'input.txt'

class Keypad
  attr_accessor :input, :current_x, :current_y, :keypad_code

  PAD = Matrix[
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]
  
  STARTING_X = 1
  STARTING_Y = 1

  MAP = {
    U: [-1,  0],
    D: [ 1,  0],
    L: [ 0, -1],
    R: [ 0,  1]
  }

  def initialize(filepath)
    self.input     = File.readlines(filepath)
    self.current_x = STARTING_X
    self.current_y = STARTING_Y
    self.keypad_code = []
  end

  def perform
    input.each do |line|
      stripped = line.strip
      find_previous_position(stripped)
    end
  end

  def find_previous_position(line)
    line.each_char do |letter|
      update_position(letter)
    end
    keypad_code << current_keypad_number
  end

  def update_position(letter)
    change_in_x, change_in_y = MAP[letter.to_sym]
    current_x,   current_y   = current_position

    possible_x = change_in_x + current_x
    possible_y = change_in_y + current_y

    if possible_x >= 0 && possible_x <= 2
      self.current_x = possible_x
    end

    if possible_y >= 0 && possible_y <= 2
      self.current_y = possible_y
    end
  end

  def current_keypad_number
    PAD[current_x, current_y]
  end

  def current_position
    [current_x, current_y]
  end
end


keypad = Keypad.new(FILEPATH)
keypad.perform
print "The keypad code is: #{keypad.keypad_code.join("")}"
