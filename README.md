# dotfiles-nvim

My personal nvim configuration.

## Required Tools

To ensure all plugins work correctly, you will need the following tools installed on your system:

### Core Dependencies
- **Neovim** >= 0.10.0
- **Git**: For downloading plugins.
- **Curl** / **Wget**: For downloading external tools (via Mason).
- **Unzip**, **Gzip**, **Tar**: For extracting tools.
- **C Compiler** (gcc/clang): Required for compiling some Tree-sitter parsers.

### Plugin Specifics
- **[rg](https://github.com/BurntSushi/ripgrep)**: Required for `snacks.picker` (grep).
- **[fzf](https://github.com/junegunn/fzf)**: Optional but recommended for fuzzy finding speed.
- **[Node.js](https://nodejs.org/) & [Yarn](https://yarnpkg.com/)**: Required for `markdown-preview.nvim` and some Mason tools (like `pyright`, `prettier`).
- **[tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md)**: Required for building/updating Tree-sitter parsers (`nvim-treesitter`).
  ```sh
  # Install via Homebrew
  brew install tree-sitter-cli
  # Or npm
  npm install -g tree-sitter-cli
  ```

### Managed by [Mason](https://github.com/williamboman/mason.nvim)
Most other tools (LSPs, linters, formatters) are managed automatically by `mason.nvim`. You can verify their status with `:Mason` inside Neovim.
- **LSPs**: `lua_ls`, `pyright`, `ts_ls`, `gopls`, etc.
- **Formatters**: `stylua`, `prettier`, `black`, `isort`, etc.
- **Linters**: `eslint_d`, `ruff`, `golangci-lint`, etc.

## Installation

```sh
git clone https://github.com/dogonthehorizon/dotfiles-nvim ~/.config/nvim/
```
