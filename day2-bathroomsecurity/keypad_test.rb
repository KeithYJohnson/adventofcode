require 'rspec'
require './keypad'

describe Keypad do
  let(:keypad) { described_class.new }

  subject { keypad.current_position }

  describe "#find_previous_position" do
    it 'returns the correct keypad number' do
      keypad.find_previous_position("ULL")
      keypad.find_previous_position("RRDD")
      keypad.find_previous_position("LURDL")

      expect(keypad.keypad_code.first).to eq(1)
      expect(keypad.keypad_code[1]).to eq(9)
      expect(keypad.keypad_code[2]).to eq(8)
    end
  end

  describe "moving up" do
    it 'decrements current_y by one' do
      keypad.update_position("U")
      expect(keypad.current_x).to eq(0)
      expect(keypad.current_y).to eq(1)
    end

    it 'stays put if at upper bound' do
      keypad.current_x = 0
      keypad.update_position("U")
      expect(keypad.current_x).to eq(0)
      expect(keypad.current_y).to eq(1)
    end
  end

  describe "moving down" do
    it 'increments current_y by one' do
      keypad.update_position("D")
      expect(keypad.current_x).to eq(2)
      expect(keypad.current_y).to eq(1)
    end

    it 'stays put if at lower bound' do
      keypad.current_x = 2
      keypad.update_position("D")
      expect(keypad.current_x).to eq(2)
      expect(keypad.current_y).to eq(1)
    end
  end

  describe "moving moving left" do
    it 'decrements current_x by one' do
      keypad.update_position("L")
      expect(keypad.current_x).to eq(1)
      expect(keypad.current_y).to eq(0)
    end

    it 'stays put if at left bound' do
      keypad.current_y = 0
      keypad.update_position("L")
      expect(keypad.current_x).to eq(1)
      expect(keypad.current_y).to eq(0)
    end
  end

  describe "moving right" do
    it 'increments current_x by one' do
      keypad.update_position("R")
      expect(keypad.current_x).to eq(1)
      expect(keypad.current_y).to eq(2)
    end

    it 'stays put if at right bound' do
      keypad.current_y = 2
      keypad.update_position("R")
      expect(keypad.current_x).to eq(1)
      expect(keypad.current_y).to eq(2)
    end
  end
end
