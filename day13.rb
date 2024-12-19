
INPUT = <<~STR
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
STR

Position = Struct.new(:x, :y) do
  def +(other)
    case other
    when Position
      Position.new(x + other.x, y + other.y)
    else
      raise ArgumentError, "Cannot add #{self} to #{other.inspect}"
    end
  end

  def *(other)
    case other
    when Integer
      Position.new(x * other, y * other)
    else
      raise ArgumentError, "Cannot multiply #{self} by #{other.inspect}"
    end
  end
end

Machine = Struct.new(:button_a, :button_b, :prize) do
  def self.run(input)
    machine = parse(input)

    puts "Button A: #{machine.button_a}"
    puts "Button B: #{machine.button_b}"
    puts "Prize: #{machine.prize}"

    solutions = machine.solutions

    puts "Solutions:"
    pp solutions

    puts "Tokens: #{machine.tokens}"

    solutions
  end

  def self.parse(input)
    button_a = input.match(/Button A: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
    button_b = input.match(/Button B: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
    prize = input.match(/Prize: X=(\d+), Y=(\d+)/).captures.map(&:to_i)

    new(Position.new(*button_a), Position.new(*button_b), Position.new(*prize) * MULTIPLIER)
  end

  MAX = 100

  def tokens
    solutions.sort_by(&:tokens).first&.tokens
  end

  Solution = Struct.new(:a_press, :b_press, :tokens)

  def solutions
    solutions = []

    button_a_press = 0
    loop do
      position = button_a * button_a_press
      break if position.x > prize.x || position.y > prize.y

      button_b_press = 0
      loop do
        position = (button_a * button_a_press) + (button_b * button_b_press)
        # puts "#{button_a_press},#{button_b_press} = #{position.x},#{position.y} (#{prize.x},#{prize.y})"

        solutions << [ button_a_press, button_b_press ] if position == prize

        break if position.x > prize.x || position.y > prize.y
        button_b_press += 1
      end
      button_a_press += 1
    end

    solutions.map do |a_press, b_press|
      Solution.new(a_press, b_press, a_press * 3 + b_press * 1)
    end
  end
end

Arcade = Struct.new(:input) do
  def machines
    @machines ||= input.lines.each_slice(4).map do |lines|
      Machine.parse(lines.join)
    end
  end

  def tokens
    machines.each_with_index.map do |machine, index|
      puts "Machine #{index} / #{machines.size}..."
      machine.tokens
    end.flatten.compact.sum
  end
end

MULTIPLIER = 1
arcade = Arcade.new(INPUT)
pp arcade.tokens

arcade = Arcade.new(File.read("day13_input.txt"))
pp arcade.tokens

puts "Day 2"

MULTIPLIER = 10000000000000

arcade = Arcade.new(File.read("day13_input.txt"))
# pp arcade.tokens # this will run forever

# Ok, we need math.
#
# prize_x = 8400 * 10000000000000
# prize_y = 5400 * 10000000000000
# a_x = 94
# a_y = 34
# b_x = 22
# b_y = 67
#
# a * a_x + b * b_x = prize_x
# a * a_y + b * b_y = prize_y
#
# a * 94 + b * 22 = 8400 * 10000000000000
# a * 34 + b * 67 = 5400 * 10000000000000
# tokens = 3a + b
# min(tokens)
