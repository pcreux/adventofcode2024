require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'progressbar'
  gem 'parallel'
end

def blink(stones)
  slices = stones.each_slice([stones.size / 8, 10].max).to_a

  #slices.flat_map do |slice|
  Parallel.flat_map(slices, in_processes: 8) do |slice|
    #puts "Worker #{Parallel.worker_number}: #{slice.size} stones out of #{stones.size} stones."

    slice.flat_map do |stone|
      stone_s = stone.to_s

      if stone == 0
        1
      elsif stone_s.size.even?
        size = stone_s.size
        half = size / 2

        [stone_s[0...half], stone_s[half...size]].map { _1.to_i }
      else
        stone * 2024
      end
    end
  end
end

def run_fast(input, blinks: 25)
  stones = input.split.map(&:to_i)

  start_time = Time.now
  (0...blinks).each do |n|
    blink_start_time = Time.now
    blink_stones_size = stones.size

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
puts "Size: #{result.size}"

puts
INPUT = "8435 234 928434 14 0 7 92446 8992692"
result = run_fast(INPUT, blinks: 25)

puts "Size: #{result.size}"

puts
puts "Day 2"
INPUT = "8435 234 928434 14 0 7 92446 8992692"
result = run_fast(INPUT, blinks: 75)

puts "Size: #{result.size}"

# Blink 30: 964027 stones. (127.73ms / 1M stones). Elapsed: 0.01m. ETA: 0.09m.
# Blink 31: 1466235 stones. (130.09ms / 1M stones). Elapsed: 0.01m. ETA: 0.14m.
# Blink 32: 2229727 stones. (129.77ms / 1M stones). Elapsed: 0.02m. ETA: 0.21m.
# Blink 33: 3366152 stones. (130.69ms / 1M stones). Elapsed: 0.03m. ETA: 0.32m.
# Blink 34: 5154934 stones. (124.67ms / 1M stones). Elapsed: 0.04m. ETA: 0.45m.
# Blink 35: 7793740 stones. (128.12ms / 1M stones). Elapsed: 0.05m. ETA: 0.68m.
# Blink 36: 11819352 stones. (125.26ms / 1M stones). Elapsed: 0.08m. ETA: 0.99m.
# Blink 37: 18052606 stones. (120.75ms / 1M stones). Elapsed: 0.11m. ETA: 1.42m.
# Blink 38: 27278105 stones. (123.58ms / 1M stones). Elapsed: 0.17m. ETA: 2.13m.
# Blink 39: 41535881 stones. (139.45ms / 1M stones). Elapsed: 0.27m. ETA: 3.57m.
# Blink 40: 63083615 stones. (131.34ms / 1M stones). Elapsed: 0.4m. ETA: 4.97m.
# Blink 41: 95665503 stones. (151.54ms / 1M stones). Elapsed: 0.65m. ETA: 8.46m.
# Blink 42: 145765473 stones. (196.87ms / 1M stones). Elapsed: 1.12m. ETA: 16.26m.
# Blink 43: 220651024 stones. (223.89ms / 1M stones). Elapsed: 1.95m. ETA: 27.17m.
# Blink 44: 335672938 stones. (304.48ms / 1M stones). Elapsed: 3.65m. ETA: 54.51m.
# Blink 45: 510419017 stones. (297.59ms / 1M stones). Elapsed: 6.18m. ETA: 78.48m.
# Blink 46: 773324028 stones. (385.09ms / 1M stones). Elapsed: 11.15m. ETA: 148.9m.
