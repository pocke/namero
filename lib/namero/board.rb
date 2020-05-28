module Namero
  class Board
    attr_reader :n

    # ..4.
    # ...1
    # 4...
    # 21..
    def self.load_from_string(str, n)
      values = str.split("\n").map(&:chars).flatten.map.with_index do |v, idx|
        if v == '.'
          Namero::Value.new(value: nil, candidates: (1..n).to_a, index: idx)
        else
          Namero::Value.new(value: Integer(v), candidates: [Integer(v)], index: idx)
        end
      end
      Namero::Board.new(n: n, values: values)
    end

    # n: Integer
    # values: Array<Integer>
    def initialize(n:, values: Array.new(n**2))
      raise ArgumentError if values.size != n**2
      @n = n
      @values = values
      @columns = Array.new(n) do |x|
        Array.new(n) { |i| values[i * n + x] }
      end
      @blocks = Array.new(n) do |i|
        idx = i % root_n * root_n + (i / root_n) * n * root_n
        block = []
        root_n.times do |y_offset|
          root_n.times do |x_offset|
            block << values[idx + x_offset + y_offset * n]
          end
        end
        block
      end
    end

    # x, y: 0 based index
    # type: :single, :row, :column, :block, :index
    def []=(idx, type = :index, value)
      case type
      when :index
        @values[idx] = value
      when :row
        start = (idx / n) * n
        n.times do |i|
          @values[start+i] = value[i]
        end
      when :column
        x = idx % n
        n.times do |i|
          @values[i * n + x] = value[i]
        end
      when :block
        x = idx % n
        y = idx / n
        start_x = x / root_n * root_n
        start_y = y / root_n * root_n

        value_idx = 0
        root_n.times do |y_offset|
          root_n.times do |x_offset|

            self[start_x + x_offset + (start_y + y_offset) * n] = value[value_idx]
            value_idx += 1
          end
        end
      else
        raise "Unknown type: #{type}"
      end
    end

    def [](idx, type = :index)
      case type
      when :index
        @values[idx]
      when :row
        start = (idx / n ) * n
        @values[start...start+@n]
      when :column
        x = idx % n
        @columns[x]
      when :block
        return @blocks[idx / n / root_n * root_n + idx % n / root_n]
      else
        raise "Unknown type: #{type}"
      end
    end

    def dup
      values = @values.map(&:dup)
      Board.new(n: @n, values: values)
    end

    def each_values
      return enum_for(__method__) unless block_given?
      @values.each do |value|
        yield value
      end
    end

    def each_affected_group
      return enum_for(__method__) unless block_given?

      n.times do |i|
        yield self[i, :column]
        yield self[i * n, :row]
        yield self[(i % root_n) * root_n + (i / root_n) * n * root_n, :block]
      end
    end

    def complete?
      all_filled = @values.all? do |v|
        v.value
      end
      return false unless all_filled

      return each_affected_group.all? do |group|
        group.map(&:value).uniq.size == n
      end
    end

    def to_s(mode: :simple)
      out = +""
      case mode
      when :simple
        @values.each.with_index do |v, idx|
          if v.value
            out << (v.value).to_s
          else
            out << '.'
          end
          out << "\n" if idx % n == n - 1
        end
      when :with_candidates
        @values.each.each_slice(n).with_index do |values, index|
          values.each_slice(root_n) do |values2|
            values2.each do |v|
              if v.value
                out << '***'
              else
                out << (v.candidates.include?(1) ? '1' : '.')
                out << (v.candidates.include?(2) ? '2' : '.')
                out << (v.candidates.include?(3) ? '3' : '.')
              end
              out << ' '
            end
            out << ' | '
          end
          out << "\n"
          values.each_slice(root_n) do |values2|
            values2.each do |v|
              if v.value
                out << "*#{v.value}*"
              else
                out << (v.candidates.include?(4) ? '4' : '.')
                out << (v.candidates.include?(5) ? '5' : '.')
                out << (v.candidates.include?(6) ? '6' : '.')
              end
              out << ' '
            end
            out << ' | '
          end
          out << "\n"
          values.each_slice(root_n) do |values2|
            values2.each do |v|
              if v.value
                out << '***'
              else
                out << (v.candidates.include?(7) ? '7' : '.')
                out << (v.candidates.include?(8) ? '8' : '.')
                out << (v.candidates.include?(9) ? '9' : '.')
              end
              out << ' '
            end
            out << ' | '
          end
          out << "\n#{'-' * ((root_n + 1) * n + (root_n) * 3) if index % root_n == root_n - 1}\n"
        end
      else
        raise "unknown mode: #{mode}"
      end
      out
    end

    private def root_n
      Integer.sqrt(n)
    end
  end
end
