require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'progressbar'
  gem 'parallel'
end

def blink(stones)
  out = Hash.new(0)

  stones.each do |stone, count|
    if stone == 0
      out[1] += count
      next
    end

    stone_s = stone.to_s
    if stone_s.size.even?
      size = stone_s.size
      half = size / 2

      out[stone_s[0...half].to_i] += count
      out[stone_s[half...size].to_i] += count
      next
    end

    out[stone * 2024] += count
  end

  out
end

def run_fast(input, blinks: 25)
  stones_list = input.split.map(&:to_i)
  stones = Hash.new(0)
  stones_list.each do |stone|
    stones[stone] += 1
  end

  start_time = Time.now
  (0...blinks).each do |n|
    blink_start_time = Time.now
    blink_stones_size = stones.values.sum

    stones = blink(stones)
    duration = Time.now - blink_start_time

    elapsed = Time.now - start_time
    eta = duration * (blinks - n)

    puts [
      "Blink #{n + 1}: #{blink_stones_size} stones.",
      "(#{(duration * 1000 / (blink_stones_size.to_f / 1_000_000)).round(2)}ms / 1M stones).",
      "Elapsed: #{(elapsed / 60).round(2)}m.",
      "ETA: #{(eta / 60).round(2)}m."
    ].join(" ")
  end

  stones
end

puts INPUT = '0 1 10 99 999'
result = run_fast(INPUT, blinks: 1)
pp result

puts
INPUT = '125 17'
result = run_fast(INPUT, blinks: 6)

pp result
puts "Size: #{result.values.sum}"

puts
INPUT = "8435 234 928434 14 0 7 92446 8992692"
result = run_fast(INPUT, blinks: 25)

puts "Size: #{result.values.sum}"

puts
puts "Day 2"
INPUT = "8435 234 928434 14 0 7 92446 8992692"
result = run_fast(INPUT, blinks: 75)

puts "Size: #{result.values.sum}"

# Blink 63: 944503324028 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 64: 1433823048177 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 65: 2178897079502 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 66: 3308977441633 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 67: 5025455705810 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 68: 7635806901291 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 69: 11594015940597 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 70: 17614519929988 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 71: 26754975842067 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 72: 40631094579790 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 73: 61732026132808 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 74: 93747198439487 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Blink 75: 142403871951216 stones. (0.0ms / 1M stones). Elapsed: 0.0m. ETA: 0.0m.
# Size: 216318908621637
