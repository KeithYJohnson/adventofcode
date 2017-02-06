file = File.readlines('test_input.txt')

commas = File.open('test_comma_separated.csv', 'w')
file.each do |line|
  new_line = line.split('').join(',')
  new_line = new_line[0...-2] + "\n"
  commas << new_line
end
