
TEST_INPUT = <<~TEST
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
TEST

Report = Struct.new(:levels) do
  def safe?
    all_different? && (all_increasing? || all_decreasing?) && differences.min >= 1 && differences.max <= 3
  end

  def safe_with_problem_dampeners?
    safe? || variations.any?(&:safe?)
  end

  def variations
    (0..levels.size - 1)
      .to_a
      .map { |n| levels.dup.tap { _1.delete_at(n) } }
      .map { |levels| Report.new(levels) }
  end

  def all_different?
    levels == levels.uniq
  end

  def all_increasing?
    levels == levels.sort
  end

  def all_decreasing?
    levels == levels.sort.reverse
  end

  def differences
    levels.each_cons(2).map { |a, b| (b - a).abs }
  end
end

def parse_input(input)
  input.split("\n").map { |line| Report.new(line.split.map(&:to_i)) }
end

def count_safe_reports(input)
  parse_input(input).count(&:safe?)
end


puts "Part 1"

puts "test:"
pp count_safe_reports(TEST_INPUT)

puts "real:"
pp count_safe_reports(File.read('day02_input.txt'))

puts
puts "Part 2"

def count_safe_reports_with_problem_dampeners(input)
  parse_input(input).count(&:safe_with_problem_dampeners?)
end

puts "test:"
pp count_safe_reports_with_problem_dampeners(TEST_INPUT)

puts "real:"
pp count_safe_reports_with_problem_dampeners(File.read('day02_input.txt'))
