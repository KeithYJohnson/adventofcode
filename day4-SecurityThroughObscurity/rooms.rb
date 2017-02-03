FILENAME = 'input.txt'

class Rooms
  attr_accessor :input, :sector_id_sum

  def initialize(filename)
    self.input      = File.readlines(filename)
    self.sector_id_sum = 0
  end

  def perform
    input.each do |line|
      room = Room.new(line)
      room.sort_letters_by_frequency(room.letter_counts)
      self.sector_id_sum += room.sector_id if room.real?
    end
  end
end

class Room
  attr_accessor :encrypted_name, :sector_id, :checksum, :letter_counts, :letters_by_frequency

  def initialize(data)
    extract_data(data)
    get_letter_counts(self.encrypted_name)
  end

  def extract_data(data)
    regexed = data.partition(/\d+/)
    self.encrypted_name       = regexed[0].tr("-","")
    self.sector_id            = regexed[1].to_i
    self.checksum             = regexed[2].tr("[]", "").strip
    self.letters_by_frequency = ""
  end

  def get_letter_counts(encrypted_name)
    self.letter_counts = encrypted_name.scan(/\w/).inject(Hash.new(0)) {|h, c| h[c] += 1; h}
  end

  def sort_letters_by_frequency(letter_counts)
    counts = letter_counts.values.uniq.sort.reverse # descending
    counts.each do |count|
      keys = letter_counts.map { |k,v| v == count ? k : nil }.compact
      if keys.count > 1
        alphabetized = keys.map(&:to_s).sort.join
        alphabetized.each_char { |letter| p letter; self.letters_by_frequency << letter }
      else
        self.letters_by_frequency << keys.first.to_s
      end
    end
  end

  def real?
    # checksum is the five most common letters
    checksum == letters_by_frequency[0..4]
  end
end

rooms = Rooms.new(FILENAME)
rooms.perform
puts "sector_id_sum: #{rooms.sector_id_sum}"
