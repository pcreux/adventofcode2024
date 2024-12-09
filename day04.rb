
TEST_INPUT = <<STR
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
STR

GRID = TEST_INPUT.split("\n").map { _1.split('') }
#GRID = File.read('day04_input.txt').split("\n").map { _1.split('') }

max_x = GRID.size
max_y = GRID.first.size

def cell(x, y, grid=GRID)
  return if x < 0 || y < 0

  row = GRID[y]
  cell = row[x] if row

  cell
end



def check(x, y)
  n = 0

  [ -1, 0, 1 ].each do |dx|
    [ -1, 0, 1 ].each do |dy|
      next if dx == 0 && dy == 0

      n += 1 if check_line(x, y, dx, dy)
    end
  end

  n
end

def check_line(x, y, direction_x=0, direction_y=0)
  get_line(x, y, direction_x, direction_y) == %w[X M A S]
end

def get_line(x, y, direction_x=0, direction_y=0)
  [
    cell(x, y),
    cell((x + direction_x), (y + direction_y)),
    cell((x + 2 * direction_x), (y + 2 * direction_y)),
    cell((x + 3 * direction_x), (y + 3 * direction_y))
  ]
end

total = 0

checks = (0...max_y).map do |y|
  (0...max_x).map do |x|
    check(x, y)
  end
end

GRID.each do |row|
  puts row.join
end

puts

checks.each do |row|
  puts row.join
end

pp checks.flatten.sum
