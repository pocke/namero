module Namero
  class Board
    attr_reader :n

    # n: Integer
    # values: Array<Integer>
    def initialize(n:, values: Array.new(n**2))
      raise ArgumentError if values.size != n**2
      @n = n
      @values = values
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
        @values.each_slice(n).map{|row| row[x]}
      when :block
        x = idx % n
        y = idx / n
        start_x = x / root_n * root_n
        start_y = y / root_n * root_n

        [].tap do |res|
          root_n.times do |y_offset|
            root_n.times do |x_offset|
              
              res << self[start_x + x_offset + (start_y + y_offset) * n]
            end
          end
        end
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

    def complete?
      @values.all? do |v|
        v.value
      end
    end

    private

    def root_n
      Integer.sqrt(n)
    end
  end
end
