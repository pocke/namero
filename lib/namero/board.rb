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
    # type: :single, :row, :column, :block
    def []=(x, y, value)
      type = y.is_a?(Integer) ? :single : y[:type]
      case type
      when :single
        idx = x+y*@n
        @values[idx] = value
      when :row
        start = x*@n
        @n.times do |i|
          @values[start+i] = value[i]
        end
      when :column
        @n.times do |i|
          @values[i*@n+x] = value[i]
        end
      when :block
        # 1 2 3
        # 4 5 6
        # 7 8 9
        root_n = Integer.sqrt(n)
        start_y = (x / root_n) * root_n
        start_x = (x % root_n) * root_n
        idx = 0
        [].tap do |res|
          root_n.times do |y_offset|
            root_n.times do |x_offset|
              self[start_x + x_offset, start_y + y_offset] = value[idx]
              idx += 1
            end
          end
        end
      else
        raise "Unknown type: #{type}"
      end
    end

    def [](x, y = nil)
      type = y.is_a?(Integer) ? :single : y[:type]
      case type
      when :single
        idx = x+y*@n
        @values[idx]
      when :row
        start = x*@n
        @values[start...start+@n]
      when :column
        @values.each_slice(@n).map{|row| row[x]}
      when :block
        # 0 1 2
        # 3 4 5
        # 6 7 8
        root_n = Integer.sqrt(n)
        start_y = (x / root_n) * root_n
        start_x = (x % root_n) * root_n
        [].tap do |res|
          root_n.times do |y_offset|
            root_n.times do |x_offset|
              res << self[start_x + x_offset, start_y + y_offset]
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
      x = 0
      y = 0
      @values.each.with_index do |value, idx|
        yield value, x, y
        if x == n - 1
          x = 0
          y += 1
        else
          x += 1
        end
      end
    end
  end
end
