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

equations = INPUT.split("\n").map { |line|
  line.split(/[: ] ?/).map(&:to_i)
}.map { |result, *numbers|
  Equation.new(result, numbers)
}

#equations.each do |equation|
#  pp equation.evaluations
#end
#
#equations.each do |equation|
#  puts "#{equation.result}: #{equation.solutions.any?} - Solutions: #{equation.solutions.map { |solution, _| solution.join(' ') }.join(', ')}"
#end

pp equations.select { _1.solutions.any? }.sum(&:result)
