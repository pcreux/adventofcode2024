INPUT = "2333133121414131402"
INPUT = File.read("day09_input.txt").gsub(/\n/, '')

uncompressed_input = INPUT.chars.each_slice(2).each_with_index.map do |(file_size, empty_size), file_number|
  [ file_number ] * file_size.to_i + ["."] * empty_size.to_i
end.flatten

#pp uncompressed_input

def move(array, id:)
  file_start = array.index(id)
  file_end = array.rindex(id)

  size = file_end - file_start + 1

  empty_start = array.each_cons(size).with_index do |subarray, i|
    if subarray.all?('.')
      break i
    end
  end

  return array unless empty_start.is_a?(Integer)

  empty_end = empty_start + size
  return array if empty_end > file_start

  # puts "Number #{id}"
  # puts "Empty: #{array[empty_start..empty_end].size} elements from #{empty_start} to #{empty_end}"
  # puts "Position: #{array[file_start..file_end].size} elements from #{file_start} to #{file_end}"
  # puts

  array[empty_start..(empty_start + size - 1)] = array[file_start..file_end]
  array[file_start..file_end] = ["."] * size

  array
end

input = uncompressed_input

ids = input.reverse.select { _1.is_a?(Integer) }.uniq
ids.each do |id|
#  puts input.join
  move(input, id: id)
end

checksum = 0

input.each_with_index do |cell, index|
  checksum += cell.to_i * index
end

pp checksum
