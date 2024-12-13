INPUT = "2333133121414131402"
# INPUT = File.read("day09_input.txt").gsub(/\n/, '')

uncompressed_input = INPUT.chars.each_slice(2).each_with_index.map do |(file_size, empty_size), file_number|
  [ file_number ] * file_size.to_i + ["."] * empty_size.to_i
end.flatten

#pp uncompressed_input

def move(input)
  first_empty_space = input.index(".")
  last_file_block = input.rindex { _1.is_a?(Integer) }

  return input if first_empty_space == last_file_block + 1

  output = input.dup
  output[first_empty_space] = input[last_file_block]
  output[last_file_block] = "."

  output
end

input = uncompressed_input
loop do
  output = move(input)
  if output == input
    input = output
    break
  else
    input = output
  end
end

# pp input

checksum = 0

input.each_with_index do |cell, index|
  break if cell == "."
  checksum += cell.to_i * index
end

pp checksum
