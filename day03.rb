
INPUT = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
REGEX = /mul\((\d+),(\d+)\)/

def run(input)
  input.scan(REGEX).map do |match|
    match[0].to_i * match[1].to_i
  end.sum
end

puts run(INPUT)

puts run(File.read('day03_input.txt'))
