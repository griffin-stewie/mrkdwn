# mrkdwn

This command line tool helps me to write Markdown documents in my workflow.

## Features

- `tof` subcommand
    - Prints Table Of Files from specified directory recursively.

### `tof` subcommand

It handles first heading level 1 text as document title, then prints like `- [TITLE](PATH_TO_FILE)`. You have some options, see details of options from `mrkdwn tof --help`

```
% mrkdwn tof --help
OVERVIEW: Print Table Of Files list to STDIN

USAGE: mrkdwn tof [--sort <ascending, descending>] [--sort-by <title, filepath>] [--list-style <none, ordered, unordered>] --target-dir <Directory Path>

OPTIONS:
  --sort <ascending, descending>
                          Sort order (default: ascending)
  --sort-by <title, filepath>
                          Sort by (default: filepath)
  --list-style <none, ordered, unordered>
                          Sort by (default: unordered)
  --target-dir <Directory Path>
                          The directory containing markdown files. Only markdown files with the `md` file extension
                          will be processed.
  --version               Show the version.
  -h, --help              Show help information.
```
## Tips

```sh
# generate completion script for zsh
mrkdwn --generate-completion-script zsh >~/.zsh/completion/_mrkdwn
```