class DetectAbbas
  attr_accessor :ip_addresses, :num_supporting_tls

  def initialize(filepath)
    self.ip_addresses = File.readlines(filepath)
    self.num_supporting_tls   = 0
  end

  def perform
    ip_addresses.each do |ip_address|
      self.num_supporting_tls += 1 if supports_tls?(ip_address)
    end
  end

  def supports_tls?(ip_address)
    return false if a_bracket_has_abba?(ip_address)
    has_abba?(ip_address)
  end

  def a_bracket_has_abba?(string)
    string.scan(/\[.*?\]/).any? { |bracket| has_abba?(bracket) }
  end

  def has_abba?(string)
    # You can dance
    # You can jive
    # Having the time of your life
    # Ooh, see that girl
    # Watch that scene
    # Dig in the dancing queen
    string.each_char.with_index do |char, index|
      # pass on the substring window if there are four of the same character in a row
      four_char_window = string[(index - 2)..(index + 1)]
      if four_char_window.chars.uniq.length == 1
        next
      end

      return true if char == string[index - 1] && string[index - 2] == string[index + 1]
    end
    false
  end
end

action = DetectAbbas.new('input.txt')
action.perform
puts "Number supporting TLS: #{action.num_supporting_tls}"
