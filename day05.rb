# Opcode 3 takes a single integer as input and saves it to the position given by its only parameter. For example, the instruction 3,50 would take an input value and store it at address 50.
# Opcode 4 outputs the value of its only parameter. For example, the instruction 4,50 would output the value at address 50.

def run_program(tape, input, output)
  tape = tape.dup
  i = 0

  until i >= tape.length
    operand1 = tape[i + 1]
    operand2 = tape[i + 2]
    operand3 = tape[i + 3]

    digits = tape[i].digits.reverse.tap do |digits|
      digits.unshift(0) until digits.length == 5
    end
    opcode = digits[3] * 10 + digits[4]
    param1_immediate = !digits[2].zero?
    param2_immediate = !digits[1].zero?
    param3_immediate = !digits[0].zero?

    op1 = operand1 && (param1_immediate ? operand1 : tape[operand1])
    op2 = operand2 && (param2_immediate ? operand2 : tape[operand2])

    case opcode
    when 1 # add
      tape[operand3] = op1 + op2
      i += 4
    when 2 # multiply
      tape[operand3] = op1 * op2
      i += 4
    when 3 # gets
      tape[operand1] = input.read
      i += 2
    when 4 # puts
      output.write(op1)
      i += 2
    when 5 # jump if true
      if !op1.zero?
        i = op2
      else
        i += 3
      end
    when 6 # jump if false
      if op1.zero?
        i = op2
      else
        i += 3
      end
    when 7 # less than?
      tape[operand3] = op1 < op2 ? 1 : 0
      i += 4
    when 8 # equals?
      tape[operand3] = op1 == op2 ? 1 : 0
      i += 4
    when 99
      break
    else
      p digits
      raise "Unexpected opcode at index #{i}: #{opcode}, #{tape[i]}"
    end
  end
  tape
end

class Reader < Struct.new(:hardcoded_input)
  def read
    hardcoded_input || gets.chomp.to_i
  end
end

class Writer < Struct.new(:ignore_input)
  def write(x)
    puts x unless x == ignore_input
  end
end

puts "Part 1"
input = File.read('input05.txt').chomp.split(',').map(&:to_i).freeze
run_program(input, Reader.new(1), Writer.new(0))

puts "Part 2"
file = File.read('input05.txt')
input = file.chomp.split(',').map(&:to_i).freeze
run_program(input, Reader.new(5), Writer.new(0))