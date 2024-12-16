
def blink(original)
  stones = original.dup

  original.each_with_index do |stone, index|
    if stone == 0
      stones[index] = 1

      next
    end

    if stone.to_s.size.even?
      size = stone.to_s.size
      half = size / 2
      stones[index] = [stone.to_s[0...half], stone.to_s[half...size]].map { _1.to_i }

      next
    end

    stones[index] = stone * 2024
  end

  stones.flatten
end

def run(input, blinks: 25)
  stones = input.split.map(&:to_i)

  (0...blinks).map do
    stones = blink(stones).dup
  end
end

puts INPUT = '0 1 10 99 999'
results = run(INPUT, blinks: 1)
pp results.last

puts
INPUT = '125 17'
results = run(INPUT, blinks: 6)

results.each do |result|
  pp result
end

puts "Size: #{results.last.size}"

puts
INPUT = "8435 234 928434 14 0 7 92446 8992692"
results = run(INPUT, blinks: 25)

puts "Size: #{results.last.size}"

puts
puts "Day 2"
INPUT = "8435 234 928434 14 0 7 92446 8992692"
results = run(INPUT, blinks: 75)

puts "Size: #{results.last.size}"
