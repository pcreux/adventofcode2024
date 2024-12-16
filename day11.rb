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
