INPUT = <<~INPUT
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
INPUT

INPUT = File.read('day07_input.txt')

Equation = Struct.new(:result, :numbers) do
  def has_solution?
    operator_options
      .lazy
      .map { |operators| numbers.zip(operators).flatten.compact }
      .any? { |operation| evaluate(operation) == result }
  end

  # Slow since it generates all possible evaluations
  def solutions
    @solutions ||= evaluations.select do |_, evaluation_result|
      evaluation_result == result
    end
  end

  def evaluations
    operator_options
      .map { |operators| numbers.zip(operators).flatten.compact }
      .to_h { [_1, evaluate(_1)] }
  end

  def operator_options
    [:+, :*, :|].repeated_permutation(numbers.size - 1).to_a
  end

  def evaluate(operation)
    operation[1..-1].each_slice(2).reduce(operation.first) do |acc, (operator, number)|
      case operator
      when :+
        acc + number
      when :*
        acc * number
      when :|
        "#{acc}#{number}".to_i
      end
    end
  end
end

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'parallel'
end

start_time = Time.now

results = Parallel.map(INPUT.split("\n"), in_processes: 8) do |line|
  result, *numbers = line.split(/[: ] ?/).map(&:to_i)
  equation = Equation.new(result, numbers)
  # equation.solutions.any? ? equation.result : 0 # ~90 seconds
  equation.has_solution? ? equation.result : 0 # ~10 seconds
end

sum = results.sum

end_time = Time.now

puts "Sum: #{sum}"
puts "Execution Time: #{end_time - start_time}"

