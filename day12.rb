Map = Struct.new(:input) do
  def initialize(input)
    super(input)

    grid.each do |row|
      previous_cell = nil
      row.each do |cell|
        cell.mark_neighbors
        previous_cell = cell
      end
    end
  end

  def map
    @map ||= input.lines.map { _1.chomp.chars }
  end

  def grid
    @grid ||= map.each_with_index.map do |row, y|
      row.each_with_index.map do |cell, x|
        Cell.new(x, y, cell, self)
      end
    end
  end

  def display
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.display
      end
      puts
    end
  end

  Metric = Struct.new(:group, :area, :fences, :price)

  def metrics
    grid.flatten.group_by(&:group).map do |group, cells|
      Metric.new(group, cells.size, cells.sum(&:fences), cells.size * cells.sum(&:fences))
    end
  end

  def total_price
    metrics.sum(&:price)
  end

  Cell = Struct.new(:x, :y, :value, :data) do
    attr_accessor :group

    def display
      # From 1:blue, 2:green, 3:yellow, 4:red
      case fences
      when 0
        print value
      when 1
        print "\e[34m#{value}\e[0m"
      when 2
        print "\e[32m#{value}\e[0m"
      when 3
        print "\e[33m#{value}\e[0m"
      when 4
        print "\e[31m#{value}\e[0m"
      else
        raise "Unexpected number of fences: #{fences}"
      end
    end

    def display
      code = if group
              value.ord * 2 % 256 + group.scan(/\d/).map(&:to_i).sum
             else
               255
             end

      print "\e[38;5;#{code}m#{value}\e[0m"
    end

    def grid
      data.grid
    end

    def map
      data.map
    end

    def fences
      neighbors.count { _1&.group != group }
    end

    def to_s
      "(#{x},#{y})"
    end

    def inspect
      "#{to_s} (#{x},#{y}) '#{group}'"
    end

    def mark_neighbors(group: "#{value}(#{x},#{y})")
      self.group = group

      friends.each { _1.mark_neighbors(group: self.group) }
    end

    private

    def friends
      friends = neighbors.select { _1&.value == value }

      friends
    end

    # Returns an array of neighbors for a given cell. Can return nil values.
    def neighbors
      @neighbors ||= [
        [x + 1, y],
        [x, y + 1],
        [x - 1, y],
        [x, y - 1]
      ].map do |x, y|
        cell = get_cell(x, y)

        cell
      end
    end

    # Returns a Cell
    def get_cell(x, y)
      return nil if x < 0 || y < 0 || y >= grid.size || x >= grid[y].size

      grid[y][x]
    end
  end
end

INPUT_1 = <<~STR
AAAA
BBCD
BBCC
EEEC
STR

INPUT_2 = <<~STR
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
STR

INPUT_3 = <<~STR
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
STR

INPUT_4 = File.read("day12_input.txt")

[INPUT_1, INPUT_2, INPUT_3, INPUT_4].each_with_index do |input, index|
  map = Map.new(input)
  puts "Input #{index + 1}:"
  map.display
  puts
  #puts "Metrics:"
  #pp map.metrics
  puts
  puts "Total price: #{map.total_price}"
  puts
  puts
end
