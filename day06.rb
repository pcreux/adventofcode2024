
INPUT = <<~INPUT
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
INPUT

def parse(input)
  input.split("\n").map { |line| line.split('') }
end

GARDS = %w[^ > v <]

MAP = parse(INPUT)
MAX_X = MAP.first.size
MAX_Y = MAP.size

Turn = Struct.new(:map) do
  # Returns the next map
  def play
    puts "Guard #{direction} is at #{position}"

    @next_map ||= case peak
    when '#'
      turn_90_degrees_right
    when '.'
      step_forward
    when nil
      @done = true
      map
    else
      raise "Invalid peak: #{peak}"
    end
  end

  def done?
    !!@done
  end

  def position
    @position ||= find_position
  end

  def direction
    @direction ||= get_cell(position)
  end

  def find_position
    (0...MAX_Y).each do |y|
      (0...MAX_X).each do |x|
        cell = get_cell([x, y])
        return [x, y] if GARDS.include? cell
      end
    end
  end

  def get_cell(position)
    y, x = position

    map[x][y] if (0...MAX_Y).include?(y) && (0...MAX_X).include?(x)
  end

  def next_position
    raise ArgumentError, "Invalid direction: #{direction}" unless GARDS.include?(direction)
    raise ArgumentError, "Invalid position: #{position}" unless position.is_a?(Array) && position.size == 2

    @next_position ||= case direction
    when '^'
      [position[0], position[1] - 1]
    when '>'
      [position[0] + 1, position[1]]
    when 'v'
      [position[0], position[1] + 1]
    when '<'
      [position[0] - 1, position[1]]
    else
      raise "Invalid direction: #{direction}"
    end
  end

  def step_forward
    map.each_with_index.map do |row, y|
      row.each_with_index.map do |cell, x|
        if [x, y] == position
          '.' # Clear the current cell
        elsif [x, y] == next_position
          direction
        else
          cell
        end
      end
    end
  end

  def turn_90_degrees_right
    map.each_with_index.map do |row, y|
      row.each_with_index.map do |cell, x|
        if [x, y] == position
          GARDS[(GARDS.index(direction) + 1) % GARDS.size]
        else
          cell
        end
      end
    end
  end

  def peak
    get_cell(next_position)
  end
end


def print(map)
  map.each { |line| puts line.join('') }
end

print MAP

turns = []
loop do
  map = turns.last&.play || MAP
  turn = Turn.new(map)
  turns << turn

  # clear screen
  puts "\e[H\e[2J"
  print turn.play
  sleep 0.1

  if turn.done?
    puts "Done!"
    break
  end
end

puts "Positions: #{turns.map(&:position).uniq.size}"
