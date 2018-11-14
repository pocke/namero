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
        raise NotImplementedError
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
        raise NotImplementedError
      else
        raise "Unknown type: #{type}"
      end
    end

    def dup
      Board.new(n: @n, values: @values.dup)
    end
  end
end
