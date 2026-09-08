# nix-daemon's own fish setup (puts the default nix profile's bin/ on PATH,
# e.g. ~/.nix-profile/bin and /nix/var/nix/profiles/default/bin).
#
# zsh and bash pick this up via /etc/profile.d themselves (something sources
# nix-daemon.sh for them), but nothing sources nix-daemon.fish for fish on
# this box -- /etc/fish/config.fish is just the stock template, with no
# /etc/fish/conf.d wrapper for it. So source it explicitly here.
#
# Numbered so it sorts and runs before dev-init.fish: that script's
# `command -q dev-init` check needs the default profile's bin/ already on
# PATH to find a dev-init installed there instead of in its own named
# profile.
if test -f /etc/profile.d/nix-daemon.fish
    source /etc/profile.d/nix-daemon.fish
end
