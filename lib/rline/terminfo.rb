class RLine
  class Terminfo
    class << self
      def cap(name, default)
        define_method(name) { @capabilities.fetch(name, default) }
      end
    end

    def initialize
      @capabilities = {}
      %i(
        sgr0
        el
        clear
        smir
        rmir
        ke
        ks
        ich1

        kich1
        kdch1
        khome
        kend
        kcud1
        kcub1
        kcuf1
        kcuu1

        cr
      ).each do |capability|
        code = `tput #{capability}`
        @capabilities = code unless code.empty?
      end
    rescue Errno::ENOENT
      warn "tput is not available!"
    end

    # VT-100 as default
    cap :sgr0,  "\e[0m"         # Turn of all attributes
    cap :el,    "\e[0K"         # Clear to end of line
    cap :clear, "\e[H\e[2J"     # Clear screen
    cap :smir,  "\e[4h"         # Enter insert mode
    cap :rmir,  "\e[4l"         # Exit insert mode
    cap :ke,    "\e>"           # Exit keypad-transmit-mode
    cap :ks,    "\e="           # Enter keypad-transmit-mode
    cap :ich1,  "\e[@"          # Insert character
    cap :cub1,  "\b"            # Move left one space
    cap :cuf1,  "\e[C"          # Move right one space
    cap :flash, "\e[?5h\e[?5l"  # Move right one space
    cap :cvvis, "\e[?12;25h"    # Make cursor very visible
    cap :cnorm, "\e[?12l\e[?25h"  # Normal cursor

    cap :kich1, "\e[2~"     # Insert key
    cap :kdch1, "\e[3~"     # Del key
    cap :khome, "\e[7~"     # Home key
    cap :kend,  "\e[8~"     # End key
    cap :kcud1, "\e[B"      # Down arrow key
    cap :kcub1, "\e[D"      # Left arrow key
    cap :kcuf1, "\e[C"      # Right arrow key
    cap :kcuu1, "\e[A"      # Up arrow key

    cap :cr, "\r"
    cap :lf, "\n"
    cap :eof, "\cd"
  end
end
