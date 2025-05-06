function cdf() {
  local exclude_names=(
    ".cache" 
    ".cargo" 
    ".git" 
    ".npm" 
    ".rustup" 
    ".venv" 
    "Library" 
    "__pycache__" 
    "build" 
    "cache" 
    "dist" 
    "neorv32"
    "nixpkgs"
    "node_modules" 
    "octave"
    "snap" 
    "target" 
    "venv" 
  )
  
  local find_args=("$HOME")
  find_args+=(-path "$HOME/.*" -prune -o)
  
  local prune_exprs=()
  local has_prunes=false
  for name in "${exclude_names[@]}"; do
    if $has_prunes; then
      prune_exprs+=(-o)
    fi
    prune_exprs+=(-name "$name")
    has_prunes=true
  done
  
  if $has_prunes; then
    find_args+=(\( "${prune_exprs[@]}" \) -prune -o)
  fi
  
  find_args+=(-type d -print)
  
  local fzf_args=(
    "-i"
    "--height=40%"
    "--reverse"
    "--prompt=Select directory: "
    "--preview=tree -C {} | head -50"
    "--preview-window=right:50%:wrap"
  )
  local selected_dir=$(find "${find_args[@]}" 2>/dev/null | fzf "${fzf_args[@]}")
  
  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir" || echo "Failed to cd into '$selected_dir'"
    pwd
    ls -lAh
  fi
}
