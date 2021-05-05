c() {
  cd ~/code/$1
}
_c_complete() {
  local file
  for file in ~/code/"$2"*; do
    [[ -d $file ]] || continue
    COMPREPLY+=( $(basename "$file") )
  done
}

complete -F _c_complete c

