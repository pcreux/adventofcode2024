
TEST_INPUT = <<~TEST
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
TEST

#INPUT = TEST_INPUT
INPUT = File.read("day05_input.txt")

RULES = INPUT.split("\n").filter_map do |line|
  line.split('|').map(&:to_i) if line.include?('|')
end

UPDATES = INPUT.split("\n").filter_map do |line|
  line.split(',').map(&:to_i) if line.include?(',')
end

valid_updates = UPDATES.select do |update|
  RULES.all? do |rule|
    intersection = update & rule

    if intersection.size != 2 # rule doesn't apply
      true
    else
      intersection == rule
    end
  end
end

puts "Valid updates middle values sum:"
pp valid_updates.sum { _1[_1.size / 2] }

invalid_updates = UPDATES - valid_updates

fixed_updates = invalid_updates.map do |update|
  update.sort do |left, right|
    rule = RULES.find do |r_left, r_right|
      [left, right].sort == [r_left, r_right].sort
    end

    break 0 if rule.nil? # no sorting

    if left == rule.first
      -1
    else
      1
    end
  end
end

puts "Fixed updates middle values sum:"
pp fixed_updates.sum { _1[_1.size / 2] }
