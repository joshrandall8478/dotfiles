# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# disable banner
$env.config = {
        show_banner: false
        table: {
		mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
		index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
		show_empty: true # show 'empty list' and 'empty record' placeholders for command output
		padding: { left: 1, right: 1 } # a left right padding of each column in a table
		trim: {
			methodology: wrapping # wrapping or truncating
			wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
			truncating_suffix: "..." # A suffix used by the 'truncating' methodology
		}
		header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
	}
	error_style: "fancy"
}

# show fastfetch
fastfetch -c ~/smallfetch.jsonc

# some aliases
alias eza = eza --icons
alias "ls e" = eza --icons

# Use starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
