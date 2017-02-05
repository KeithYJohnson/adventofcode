require 'openssl'
test_door_id = 'abc'
puzzle_input = 'ojvtpuvg'

class GetDoorID
  attr_accessor :door_id, :password, :integer_index, :complexhash

  def initialize(input, complexhash=true)
    self.door_id = input
    self.password = "*" * 8
    self.integer_index = 0
    self.complexhash = complexhash
  end

  def perform
    while password.include?("*")
      hexhash = OpenSSL::Digest::MD5.hexdigest(hash_input)
      if first_five_zero_hash?(hexhash)
        if complexhash
          begin
            index = Integer(hexhash[5])
            digit = hexhash[6]
            self.password[index] = digit if password[index] == "*"
          rescue ArgumentError
            puts "hexhash[5]: #{hexhash[5]} not an integer.  Skipping..."
          end
        else
          # This returns the index of the first "*"; the password is built left-to-right.
          index = self.password.index("*")
          self.password[index] = hexhash[5]
        end
        puts self.password
      end
      self.integer_index += 1
    end
  end

  def hash_input
    "#{door_id}#{integer_index}"
  end

  def first_five_zero_hash?(hexhash)
    hexhash.start_with?("00000")
  end
end

thing = GetDoorID.new(puzzle_input)
thing.perform
puts "password is #{thing.password}"
