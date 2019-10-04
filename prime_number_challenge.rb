#!/usr/bin/env ruby
#
# Construct a program that prints out a multiplication table of the first
# 10 primary numbers to STDOUT.

require 'minitest'

class PrimeGenerator
  def self.primes(count)
    raise StandardError unless count.is_a?(Integer) && count >= 1

    primes = [2]
    num = 3

    while primes.count != count
      prime = true

      primes.each do |i|
        break if i > Math.sqrt(num)
        prime = false && break if (num % i).zero?
      end

      primes << num if prime
      num += 2
    end

    primes
  end
end

# Setup PrimeGenerator tests
class PrimeGeneratorTest < MiniTest::Test
  def test_primes_results
    assert_raises(StandardError) { PrimeGenerator.primes('test') }
    assert_raises(StandardError) { PrimeGenerator.primes(-1) }
    assert_equal(
      [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47],
      PrimeGenerator.primes(15)
    )
  end
end

class Matrix
  attr_reader :matrix
  
  def initialize(primes)
    @primes = primes
    @matrix = generate_matrix
  end

  def print_matrix
    raise StandardError if @matrix.nil?

    matrix.each do |row|
      print row.join("\t")
      puts ''
    end
  end

  private

  def generate_matrix
    return nil unless @primes.any? && @primes.count.positive?

    (0..@primes.count).map do |row|
      if row.eql?(0)
        ['', @primes].flatten
      else
        tmp = @primes.map do |prime|
          @primes[row - 1] * prime
        end
        tmp.unshift(@primes[row - 1])
      end
    end
  end
end

# Setup Matrix tests
class MatrixTest < MiniTest::Test
  def test_get_row
    matrix = Matrix.new([2, 3]).matrix

    assert_equal(['', 2, 3], matrix[0])
    assert_equal([2, 4, 6], matrix[1])
    assert_equal([3, 6, 9], matrix[2])

    matrix = Matrix.new([]).matrix
    assert_nil(matrix)
  end

  def test_print_matrix
    matrix = Matrix.new([2, 3])

    out, err = capture_io do
      matrix.print_matrix
    end

    assert_equal("\t2\t3\n2\t4\t6\n3\t6\t9\n", out)
    assert(err.empty?)
  end
end

# Trigger test suite and run program if successful
if MiniTest.run
  count = ARGV.first.to_i
  count = 10 if count.zero?

  primes = PrimeGenerator.primes(count)
  matrix = Matrix.new(primes)

  puts "Multiplication table for the first #{primes.count} primary numbers:"
  matrix.print_matrix
else
  puts 'Tests failed! :('
end
