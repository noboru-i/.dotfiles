# rm 互換のラッパー: ファイルを macOS の Finder のゴミ箱へ移動する。
# macOS 標準の /usr/bin/trash は rm のオプション（-rf など）を受け付けないため、
# rm のオプションを解釈して対象ファイルだけを渡す。
# -i / -I / -x などの確認系・その他のオプションは無視する。
rm() {
  local force=0 recursive=0 dir=0 verbose=0 rc=0 f i
  local -a files children

  while (( $# )); do
    case $1 in
      --)          shift; files+=("$@"); break ;;
      --force)     force=1 ;;
      --recursive) recursive=1 ;;
      --dir)       dir=1 ;;
      --verbose)   verbose=1 ;;
      --*)         ;;
      -?*)
        for (( i = 2; i <= ${#1}; i++ )); do
          case ${1[i]} in
            f)   force=1 ;;
            r|R) recursive=1 ;;
            d)   dir=1 ;;
            v)   verbose=1 ;;
          esac
        done ;;
      *)           files+=("$1") ;;
    esac
    shift
  done

  if (( ${#files} == 0 )); then
    (( force )) && return 0
    print -u2 "rm: missing operand"
    return 1
  fi

  for f in "${files[@]}"; do
    if [[ ! -e $f && ! -L $f ]]; then
      (( force )) || { print -u2 "rm: $f: No such file or directory"; rc=1; }
      continue
    fi
    if [[ -d $f && ! -L $f ]] && (( ! recursive )); then
      children=("$f"/*(DN))
      if (( ! dir )); then
        print -u2 "rm: $f: is a directory"; rc=1; continue
      elif (( ${#children} )); then
        print -u2 "rm: $f: Directory not empty"; rc=1; continue
      fi
    fi
    # /usr/bin/trash は -- を解釈しないので、-始まりの名前は ./ を付けて渡す
    [[ $f == -* ]] && f=./$f
    if /usr/bin/trash "$f"; then
      (( verbose )) && print -r -- "$f"
    else
      rc=1
    fi
  done
  return $rc
}
