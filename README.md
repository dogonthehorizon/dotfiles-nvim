# dotfiles-nvim

My personal nvim configuration.

## Required Tools

To ensure all plugins work correctly, you will need the following tools installed on your system:

### Plugin Specifics

- **[rg](https://github.com/BurntSushi/ripgrep)**: Required for `snacks.picker` (grep).
- **[fzf](https://github.com/junegunn/fzf)**: Optional but recommended for fuzzy finding speed.
- **[tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md)**: Required for building/updating Tree-sitter parsers (`nvim-treesitter`).
  ```sh
  # Install via Homebrew
  brew install tree-sitter-cli
  # Or npm
  npm install -g tree-sitter-cli
  ```

## Installation

```sh
git clone https://github.com/dogonthehorizon/dotfiles-nvim ~/.config/nvim/
```
