<div align="center">

# shrub.nvim 🌱

### Collection of [Treesitter](https://tree-sitter.github.io/tree-sitter/) powered utilities for common JavaScript/TypeScript source code edits and refactors

[![GitHub](https://img.shields.io/badge/GitHub-black.svg?style=for-the-badge&logo=github)](

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.9+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

</div>

## 📚 Features

-   [x] convert between implicit and explicit arrow function return statements
-   [x] add/remove braces from conditional statements
-   [ ] convert between arrow and function declaration

## 📦 Installation

This Plugin assumes you have nvim-treesitter and the following parsers installed:

-   JavaScript
-   TypeScript

### [lazy.nvim](https://github.com/folke/lazy.nvim#-plugin-spec)

The following plugin spec will initialize the plugin with the default configuration.

```lua
return {
  "ianjkaplan/shrub.nvim",
  config = true
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
}
```

_you can provide custom key bindings by passing your own keys to the `keys` field_

## ⚙️ Configuration

| Default Key Binding | Lua                                             | Description                                                                                                                                                                                                                                                                                                       |
| ------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`<leader>jer`**   | `lua require("shrub").statement_block_surround` | When the cursor in the body of a function or conditional that doesnt have a wrapping `{}` will add a surrounding statement block                                                                                                                                                                                  |
| **`<leader>jir`**   | `lua require("shrub").statement_block_remove`   | If the cursor is in the body of an arrow function, will remove surrounding `{}` and will move everything following the `return` statement to an implicit return (e.g `const myFn => "result"`). If the cursor is in a conditional everything will produce a one line early return e.g `if (true) return "result"` |

**shrub.nvim** only provides a few key bindings to perform common text manipulations. It does not format or lint your code. It is recommended to have prettier and eslint set up in your Javascript/Typescript to format and lint your code

## Development

## 🚧 Under Construction

If you experience any issues, see some improvement you think would be amazing, or just have some feedback or advice, make an issue!

### Running the tests

This project uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/tree/master) to run tests. To run the tests, run the following command:

```zsh
nvim --headless -c 'PlenaryBustedDirectory tests'
```

_Make sure that the javascript and typescript parsers are installed and in the runtime path for the test neovim instance_
