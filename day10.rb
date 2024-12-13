INPUT = <<~TXT
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
TXT

# INPUT = <<~TXT
# 0123
# 1234
# 8765
# 9876
# TXT
#

INPUT = File.read("day10_input.txt")

MAP = INPUT.lines.map { _1.chomp.chars.map { |c| Integer(c) rescue -1 } }

MAX_X = MAP.first.size
MAX_Y = MAP.size

def get_cell(x, y)
  return nil if x < 0 || y < 0 || x >= MAX_X || y >= MAX_Y

  MAP[y][x]
end

Trail = Struct.new(:x, :y, :height) do
  # def ==(other)
  #   x == other.x && y == other.y && height == other.height
  # end

  def score
    @score ||= summits.size
  end

  def summits
    @summits ||= paths.flatten.select { _1.height == 9 }.to_set
  end

  def paths_to_summit
    paths.flatten.select { _1.height == 9 }.size
  end

  def paths
    @paths ||= ([self] + next_steps.map(&:paths))
  end

  def next_steps
    [ [x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1] ].filter_map do |x, y|
      next unless get_cell(x, y) == height + 1

      Trail.new(x: x, y: y, height: height + 1)
    end
  end

  def print
    puts "#{" " * height}[#{x},#{y}] #{"^" if height == 9}"
    next_steps.each(&:print)
  end
end

trailheads = []

MAX_Y.times do |y|
  MAX_X.times do |x|
    trailheads << Trail.new(x: x, y: y, height: 0) if get_cell(x, y) == 0
  end
end

#trailheads.each(&:print)

hash = trailheads.to_h do |trailhead|
  # trailhead.print

  [
    trailhead,
    trailhead.summits
  ]
end

trailheads.each_with_index do |trailhead, n|
  next
  puts
  puts "Trailhead #{n}: #{trailhead.score}"

  MAX_Y.times do |y|
    MAX_X.times do |x|
      cell = get_cell(x, y)
      if trailhead == Trail.new(x: x, y: y, height: 0)
        print "\e[31m#{cell}\e[0m"
      elsif trailhead.summits.include?(Trail.new(x: x, y: y, height: 9))
        print "\e[32m#{cell}\e[0m"
      elsif trailhead.paths.flatten.map { [_1.x, _1.y] }.include?([x, y])
        print "\e[33m#{cell}\e[0m"
      elsif cell == -1
        print "."
      else
        print cell
      end
    end
    print "\n"
  end
end

pp hash.values.map(&:size).sum

puts "Summits (day 1):"
pp hash.values.map(&:size).sum

puts "Path to summit (day 2):"
pp trailheads.map(&:paths_to_summit).sum
