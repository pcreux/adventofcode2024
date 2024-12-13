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

  def valid?
    x.between?(0, GRID.first.size - 1) && y.between?(0, GRID.size - 1)
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

def antinodes(a, b)
  diff = b - a
  antinode = b + diff

  if antinode.valid?
    pp antinode
    [ antinode, antinodes(b, antinode) ].flatten
  else
    []
  end
end

ANTINODES = GROUPED_COMBINATIONS.map do |_antenna, combinations|
  combinations.map do |a, b|
    puts "Computing antinodes for #{[a, b]}"
    antinodes(a, b) + antinodes(b, a)
  end
end.flatten

puts "Antinodes:"
pp ANTINODES

puts "Valid antinodes:"
VALID_ANTINODES = ANTINODES.select(&:valid?).to_a

puts "Unique valid antinodes:"
pp ANTINODES_POSITIONS = (
  VALID_ANTINODES.map { |antinode| [antinode.x, antinode.y] } + ANTENNAS.map { |antenna| [antenna.x, antenna.y] }
).to_set

GRID.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    print cell == '.' && ANTINODES_POSITIONS.include?([x, y]) ? '#' : cell
  end
  puts
end


pp ANTINODES_POSITIONS.size
