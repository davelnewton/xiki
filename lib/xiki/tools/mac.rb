module Xiki
  # Starting and stopping mac
  class Mac

    def self.menu
      %`
      - Enable mac keyboard shortcuts/
        | Enable macintosh-like keyboard shortcuts, like command-c
        @ Mac.define_keys
      - Important dirs/
        @/Users/
        @/Applications/
        @/Applications/Utilities/
        @~/Library/Fonts/
        @/System/Library/CoreServices/
      - api/
        | Define standard mac shortcuts
        @ Mac.define_keys
      `
    end

    def self.define_keys

      self.keys
      View.flash "- defined Command-C, Command-V, Command-Q, etc."
    end

    # Use this if you're using aquamacs
    #
    # Put this line in your init.rb file to use the below key mappings.
    #
    #   Mac.keys_for_aquamacs
    def self.keys_for_aquamacs # options={}

      return if ! $el.boundp(:osx_key_mode_map)

      $el.define_key(:osx_key_mode_map, $el.kbd("A-r")){ Browser.reload }

      # Don't do the rest by default, since it presumes that "Options > Appearance > Auto Faces" is off ...

      $el.define_key(:osx_key_mode_map, $el.kbd("A-0")) { Styles.font_size 110 }
      $el.define_key(:osx_key_mode_map, $el.kbd("A-=")) { Styles.zoom }
      $el.define_key(:osx_key_mode_map, $el.kbd("A--")) { Styles.zoom :out=>1}
      $el.define_key(:osx_key_mode_map, $el.kbd("A-+")) { Styles.zoom :up=>1 }
      $el.define_key(:osx_key_mode_map, $el.kbd("A-_")) { Styles.zoom :out=>1, :up=>1 }

      # Changes aquamacs behavior so it opens in same frame.  Is there
      # an aquamacs setting for this that could be used instead of redefining
      # key?
      $el.define_key :osx_key_mode_map, $el.kbd("A-n") do
        View.new_file
      end

      $el.define_key(:osx_key_mode_map, $el.kbd("<A-right>")) { Code.indent_to }   # Command+right
      $el.define_key(:osx_key_mode_map, $el.kbd("<A-left>")) { Code.indent_to :left=>1 }   # Command+left

    end

    # Use this if you're not using aquamacs
    #
    # Put this line in your init.rb file to use the below key mappings.
    #
    # Mac.keys
    def self.keys

      #   def self.keys
      Keys._Q { $el.save_buffers_kill_emacs }   # Command-Q to quit
      Keys._C {
        left, right = View.range
        Effects.blink :left=>left, :right=>right
        $el.kill_ring_save left, right
      }   # Command-C
      Keys._V { $el.yank }   # Command-V
      Keys._A { View.to_highest; Clipboard.copy_everything }   # Command-V

      Keys._X {
        left, right = View.range
        Effects.blink :left=>left, :right=>right
        $el.kill_region left, right
      }

      Keys._S { DiffLog.save }   # save (or, with prefix, save as) **

      $el.define_key :global_map, $el.kbd("M-X"), :execute_extended_command
    end
  end
end
