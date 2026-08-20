# nix `dev-init` profile/package support.
#
# Everything here is detected at runtime: if the profile isn't installed on this
# machine, or the binaries it should provide are missing, every block below is
# skipped. That keeps this same config usable on boxes without nix.

# Candidate profile locations, first match wins. $DEV_INIT_PROFILE is checked
# first so the location can be forced from the environment; the rest cover
# `nix profile` (XDG state dir), older nix (XDG data dir), and the `nix-env -p`
# per-user and system profile dirs.
set -l dev_init_candidates \
    $DEV_INIT_PROFILE \
    $XDG_STATE_HOME/nix/profiles/dev-init \
    $HOME/.local/state/nix/profiles/dev-init \
    $HOME/.local/share/nix/profiles/dev-init \
    /nix/var/nix/profiles/per-user/$USER/dev-init \
    /nix/var/nix/profiles/dev-init

set -l dev_init_profile
for candidate in $dev_init_candidates
    # bin/ is the "only if the necessary bins are there" check: a profile
    # symlink left pointing at nothing usable counts as absent.
    if test -d $candidate/bin
        set dev_init_profile $candidate
        break
    end
end

if set -q dev_init_profile[1]
    set -gx DEV_INIT_PROFILE $dev_init_profile

    # --path --global rather than the fish_add_path default: $fish_user_paths is
    # universal on this setup, and a path baked in there would outlive the
    # profile it came from. No --move on purpose -- prepend only when the entry
    # is missing, so a nested fish inside `nix develop` keeps that shell's tools
    # in front instead of having these yanked over them.
    fish_add_path --global --path --prepend $dev_init_profile/bin

    if test -d $dev_init_profile/share/man
        if not contains -- $dev_init_profile/share/man $MANPATH
            set -gx MANPATH $dev_init_profile/share/man $MANPATH
        end
        # A trailing empty entry keeps man's own default search path reachable.
        if not contains -- "" $MANPATH
            set -gx --append MANPATH ""
        end
    end

    # nix packages ship their fish integration under share/fish/vendor_*. NixOS
    # wires these up itself; a plain profile on another distro does not.
    set -l dev_init_completions $dev_init_profile/share/fish/vendor_completions.d
    if test -d $dev_init_completions; and not contains -- $dev_init_completions $fish_complete_path
        # Prepended so completions match the binaries put first on PATH above.
        set -g fish_complete_path $dev_init_completions $fish_complete_path
    end

    set -l dev_init_functions $dev_init_profile/share/fish/vendor_functions.d
    if test -d $dev_init_functions; and not contains -- $dev_init_functions $fish_function_path
        # Appended so the profile can't shadow ~/.config/fish/functions.
        set -g --append fish_function_path $dev_init_functions
    end

    for conf in $dev_init_profile/share/fish/vendor_conf.d/*.fish
        source $conf
    end
end

# Command-level support is checked separately: `dev-init` can be on PATH from
# the default nix profile with no dev-init profile dir of its own.
if command -q dev-init
    # `di` shorthand, skipped if something else on this box already owns the
    # name, as a command or as a function. --wraps borrows dev-init's own
    # completions.
    if not command -q di; and not functions -q di
        function di --wraps dev-init --description 'dev-init'
            dev-init $argv
        end
    end
end
