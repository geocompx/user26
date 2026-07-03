#!/usr/bin/env bash
set -euo pipefail

PROFILE="/home/rstudio/.Rprofile"
BEGIN_MARK="# >>> vscode-session-autostart >>>"
END_MARK="# <<< vscode-session-autostart <<<"

if [[ "${1:-}" == "--install" ]]; then
  Rscript -e "repos <- 'https://cloud.r-project.org'; pkgs <- c('jsonlite', 'rlang'); missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]; if (length(missing)) install.packages(missing, repos = repos)"
fi

mkdir -p "$(dirname "$PROFILE")"
touch "$PROFILE"

# Remove previous managed block so updates are applied on each run.
tmp_profile="$(mktemp)"
awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
  $0 == begin { skip = 1; next }
  $0 == end { skip = 0; next }
  !skip { print }
' "$PROFILE" > "$tmp_profile"
mv "$tmp_profile" "$PROFILE"

cat >> "$PROFILE" <<'EOF'

# >>> vscode-session-autostart >>>
local({
  if (interactive()) {
    vsc_init <- path.expand("~/.vscode-R/init.R")
    if (file.exists(vsc_init)) {
      old_term_program <- Sys.getenv("TERM_PROGRAM", unset = "")
      old_rstudio <- Sys.getenv("RSTUDIO", unset = "")
      if (!nzchar(old_term_program)) {
        Sys.setenv(TERM_PROGRAM = "vscode")
      }
      if (nzchar(old_rstudio)) {
        Sys.unsetenv("RSTUDIO")
      }
      try(source(vsc_init, local = TRUE), silent = TRUE)
      if (!nzchar(old_term_program)) {
        Sys.unsetenv("TERM_PROGRAM")
      } else {
        Sys.setenv(TERM_PROGRAM = old_term_program)
      }
      if (nzchar(old_rstudio)) {
        Sys.setenv(RSTUDIO = old_rstudio)
      }

      # In plain interactive `R` sessions the startup hook may not run,
      # so trigger pending VS Code attach once.
      if (!("tools:vscode" %in% search()) && exists(".First.sys", envir = .GlobalEnv, inherits = FALSE)) {
        try(get(".First.sys", envir = .GlobalEnv)(), silent = TRUE)
      }
    }
  }
})
# <<< vscode-session-autostart <<<
EOF
