require 'rline/utils'

module RLine
  class Line
    class Insert
      include RLine::Utils

      def initialize(text, inserted_text, position, width)
        @text = text
        @inserted_text = inserted_text
        @position = position
        @width = width
      end

      def cursor_movement
        @inserted_text.length
      end

      def output_token
        @output_token ||= build_output_token
      end

      def resulting_text
        @resulting_text ||= [
          left_part,
          @inserted_text,
          right_part
        ].join
      end

      private

      def left_part
        @left_part ||= @text[0...@position]
      end

      def right_part
        @right_part ||= @text[@position..-1]
      end

      def build_output_token
        OutputSequence.new(print + redraw)
      end

      private

      def print
        printed_parts = break_text(
          [left_part, @inserted_text].join,
          @position,
          @width
        )

        tokens = []

        printed_parts.each_with_index do |part, index|
          tokens.push(Print.new(part))

          tokens.push(
            CursorDown.new(1),
            CarriageReturn.new
          ) if index < printed_parts.length - 1
        end

        tokens
      end

      def redraw
        redraw_parts = break_text(
          resulting_text,
          @position + @inserted_text.length,
          @width
        )

        tokens = []

        redraw_parts.each_with_index do |part, index|
          tokens.push(Print.new(part))

          tokens.push(
            CursorDown.new(1),
            CarriageReturn.new
          ) if index < redraw_parts.length - 1
        end

        if redraw_parts.count > 1
          tokens.push(CursorUp.new(redraw_parts.count - 1))
        else
          tokens.push(
            CarriageReturn.new
          )
        end

        tokens
      end
    end
  end
end
