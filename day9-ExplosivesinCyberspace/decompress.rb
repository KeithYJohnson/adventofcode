require 'pry-byebug'
class Decompress
  attr_accessor :compressed, :decompressed, :current_index

  def initialize(input)
    self.compressed    = File.read(input)
    self.decompressed  = ""
    self.current_index = 0
  end

  def perform
    marker = find_next_chunk(current_index)
  end

  def decompress_marker(marker, text_before_next_marker)
    num_chars_to_repeat, times_to_repeat = marker.split("x").map(&:to_i)

    chars_to_repeat, rest = [
      text_before_next_marker[0..(num_chars_to_repeat - 1)],
      text_before_next_marker[(num_chars_to_repeat)..-1]
    ]

    chars_to_repeat * times_to_repeat + rest
  end


  def find_next_chunk(starting_index=0)
    marker = find_next_marker
    num_chars_to_repeat, times_to_repeat = marker.split("x").map(&:to_i)

  end

  def find_next_marker(starting_index=0)
    self.compressed[starting_index..-1][/\(.*?\)/][1...-1]
  end
end

action = Decompress.new('test_input.txt')
action.perform
