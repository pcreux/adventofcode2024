
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

#GRID = TEST_INPUT.split("\n").map { _1.split('') }
GRID = File.read('day04_input.txt').split("\n").map { _1.split('') }

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

  [ -1, 1 ].each do |dx|
    [ -1,  1 ].each do |dy|
      n += 1 if check_line(x, y, dx, dy)
    end
  end

  n
end

def check_line(x, y, dx=0, dy=0)
  get_line(x, y, dx, dy) == %w[M A S]
end

def get_line(x, y, dx=0, dy=0)
  [
    cell((x - dx), (y - dy)),
    cell(x, y),
    cell((x + dx), (y + dy))
  ]
end

total = 0

checks = (0...max_y).map do |y|
  (0...max_x).map do |x|
    check(x, y)
  end
end

GRID.each do |row|
  puts row.join(' ')
end

puts

checks.each do |row|
  puts row.join(' ')
end

pp checks.flatten.select { _1 == 2 }.size
