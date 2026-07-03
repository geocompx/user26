# Dev Container Notes

## Plot pane troubleshooting (known-good setup)

If `plot(1, 1)` writes `Rplots.pdf` instead of opening the VS Code plot pane,
the session watcher is not attached. In this repository, the working setup is:

- `r.sessionWatcher: true`
- `r.plot.useHttpgd: false`
- `r.session.viewers.viewColumn.plot: "Beside"`
- startup hook in `.devcontainer/init-httpgd.sh` that writes a managed block to
  `/home/rstudio/.Rprofile` and sources `~/.vscode-R/init.R` for interactive R
  sessions
- R packages `jsonlite` and `rlang` installed in the container (required by the
  VS Code R session watcher)

Notes:

- The plot pane uses the VS Code-R built-in plot replay backend, which renders
  temporary images under `/tmp/Rtmp*/vscode-R/plot.png`. This is expected.
- `ROOT=true` and `DISABLE_AUTH=true` are for RStudio Server auth behavior and do
  not grant root privileges to `postCreateCommand` in a devcontainer.
