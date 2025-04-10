#!/usr/bin/env zsh

fe() {
  local IFS=$'\n'
  local files=()
  files=(
    "$(fzf-tmux \
          --query="$1" \
          --multi \
          --select-1 \
          --exit-0 \
          --preview="${FZF_PREVIEW_CMD}" \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)'
    )"
  ) || return
  "${EDITOR:-vim}" "${files[@]}"
}

# fkill - kill process
fkill() {
  local pid

  pid="$(
    ps -ef \
      | sed 1d \
      | fzf -m \
      | awk '{print $2}'
  )" || return

  kill -"${1:-9}" "$pid"
}
