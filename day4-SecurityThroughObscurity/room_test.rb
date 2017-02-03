require 'pry-byebug'
require './rooms'

describe Room do
  let(:room) { Room.new('test_input.txt') }
  let(:row)  { "aaaaa-bbb-z-y-x-123[abxyz]\n" }

  describe "#extract_data" do
    it 'extracts the data' do
      room.extract_data(row)
      expect(room.encrypted_name).to eq('aaaaabbbzyx')
      expect(room.checksum).to eq('abxyz')
    end
  end

  describe "#get_letter_counts" do
    it 'builds a hash of letter frequencies' do
      room.get_letter_counts("aa-bbb-c-dddd")
      hash = room.letter_counts
      expect(hash["a"]).to eq(2)
      expect(hash["b"]).to eq(3)
      expect(hash["c"]).to eq(1)
      expect(hash["d"]).to eq(4)
    end
  end

  describe "#sort_letters_by_frequency" do
    let(:frequency_hash) { { 'd': 3, 'b': 2, 'c': 2, 'a': 1 } }

    it 'sorts a string by descending frequency, alphabetically when tied' do
      room.sort_letters_by_frequency(frequency_hash)
      expect(room.letters_by_frequency).to eq("dbca")
    end
  end
end
