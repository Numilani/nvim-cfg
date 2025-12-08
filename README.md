## Remember Thase Shortcuts!
- <c-a*> / <c-i*> - Change Around / Change Inside
  - Change does a visual select and allows "type-over" replacement
  - Around and Inside select everything within predefined regions, such as
    inside brackets, a sentence, a line, etc.
- 'gcc' / 'gc#<motion>' / (visual) 'gc' - comment line/comment motion/comment selection
  - i.e. `gc5j` comments the current line and the 5 below it
- '.' - the "repeat last" command
  - Doesn't work with *everything*, but works with a lot
  - ex `>0j.` indents a line, then moves down and repeats
- <C-space> and <C-e> - show/hide autocomplete!
- sa<motion> - add "surrounding" characters!
  - ex `saiw(` will surround the inside word with parentheses

## Setting Up New Languages
tl;dr - LSPs/DAPs get installed in Mason and auto-configured via bridges,
        Formatters/Linters get configured in their plugin and bridges install them via Mason.


### Installing LSPs
- Use Mason (:Mason) to install the LSP
- mason-lspconfig should automatically detect the LSP and register it
  - overrides/custom configuration help can be found via :h mason-lspconfig-automatic-server-setup

### Installing DAPs
- Use Mason (:Mason) to install the DAP
- mason-nvim-dap should automatically detect the DAP and register it
  - overrides/custom configuration can be done via the handler function table
    (see https://github.com/jay-babu/mason-nvim-dap.nvim)

### Installing Formatters
- Register the formatter by filetype with conform
  - see https://github.com/stevearc/conform.nvim for details
- mason-conform should pick up the formatter request and install it via Mason

### Installing Linters
- Register the formatter by filetype with nvim-lint
  - see https://github.com/mfussenegger/nvim-lint for details
- mason-nvim-lint should pick up the linter request and install it via Mason
