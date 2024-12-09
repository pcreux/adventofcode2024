
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

  n += 1 if [cell(x, y), cell(x+1, y), cell(x+2, y), cell(x+3, y)] == %w[X M A S] # left to right
  n += 1 if [cell(x, y), cell(x-1, y), cell(x-2, y), cell(x-3, y)] == %w[X M A S] # right to left
  n += 1 if [cell(x, y), cell(x, y-1), cell(x, y-2), cell(x, y-3)] == %w[X M A S] # up
  n += 1 if [cell(x, y), cell(x, y+1), cell(x, y+2), cell(x, y+3)] == %w[X M A S] # down
  n += 1 if [cell(x, y), cell(x+1, y+1), cell(x+2, y+2), cell(x+3, y+3)] == %w[X M A S] # diagonal left to right down
  n += 1 if [cell(x, y), cell(x+1, y-1), cell(x+2, y-2), cell(x+3, y-3)] == %w[X M A S] # diagonal left to right up
  n += 1 if [cell(x, y), cell(x-1, y+1), cell(x-2, y+2), cell(x-3, y+3)] == %w[X M A S] # diagonal right to left down
  n += 1 if [cell(x, y), cell(x-1, y-1), cell(x-2, y-2), cell(x-3, y-3)] == %w[X M A S] # diagonal right to left up

  n
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
