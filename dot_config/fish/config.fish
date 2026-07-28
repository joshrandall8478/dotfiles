source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
	fastfetch -c ~/.smallfetch.jsonc
end

# eza functions
function ls --description 'eza as ls'
    eza --group-directories-first --icons=auto $argv
end

function ll --description 'long list'
    eza -l --group-directories-first --icons=auto --git $argv
end

function la --description 'long list, all files'
    eza -la --group-directories-first --icons=auto --git $argv
end

function lt --description 'tree view'
    eza --tree --level=2 --icons=auto --group-directories-first $argv
end

function lg --description 'long list with git status'
    eza -l --git --git-repos --icons=auto --group-directories-first $argv
end

starship init fish | source
