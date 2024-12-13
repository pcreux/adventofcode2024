INPUT = <<~INPUT
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
INPUT

INPUT = File.read("day08_input.txt")

GRID = INPUT.split("\n").map(&:chars)

Cell = Struct.new(:x, :y, :value) do
  def +(other)
    Cell.new(x + other.x, y + other.y, value)
  end

  def -(other)
    Cell.new(x - other.x, y - other.y, value)
  end
end

def get_cell(x, y)
  return nil if x < 0 || y < 0

  GRID.dig(y, x)
end

ANTENNAS = []

GRID.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if cell == '.'

    ANTENNAS << Cell.new(x, y, cell)
  end
end

INDEX = ANTENNAS.group_by(&:value)

puts "Antennas:"
pp INDEX.values

puts "Combinations:"
pp GROUPED_COMBINATIONS = INDEX.transform_values { _1.combination(2).to_a }

ANTINODES = GROUPED_COMBINATIONS.map do |_antenna, combinations|
  combinations.map do |a, b|
    [
      b + b - a,
      a + a - b
    ]
  end
end.flatten

puts "Antinodes:"
pp ANTINODES

puts "Valid antinodes:"
VALID_ANTINODES = ANTINODES.select do |antinode|
  antinode.x.between?(0, GRID.first.size - 1) && antinode.y.between?(0, GRID.size - 1)
end.to_a

puts "Unique valid antinodes:"
pp ANTINODES_POSITIONS = VALID_ANTINODES.map { |antinode| [antinode.x, antinode.y] }.to_set

pp ANTINODES_POSITIONS.size
