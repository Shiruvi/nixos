if status is-interactive
  set -g fish_greeting
  fish_vi_key_bindings
end
  # Apply the current Caelestia terminal colours (written on every wallpaper change)
  cat ~/.local/state/caelestia/sequences.txt 2>/dev/null
