require 'pry-byebug'
FILEPATH = 'input.txt'

class Triangle
  attr_accessor :input, :possible_triangles

  def initialize(filepath)
    self.input  = File.readlines(filepath)
    self.possible_triangles = 0
  end

  def perform
    input.each do |line|
      self.possible_triangles += 1 if possible_triangle?(line)
    end
  end

  def possible_triangle?(line)
    a, b, c = line.split(' ').map(&:to_i)
    a + b > c && b + c > a && a + c > b
  end
end

thing = Triangle.new(FILEPATH)
thing.perform
puts thing.possible_triangles
