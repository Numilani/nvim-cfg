# Going Mouseless: Numi's Neovim Config

# Config File Structure

## Neovim Settings

- **init.lua**

init.lua is the entry point for the entire configuration. 
When starting out, you probably shouldn't touch this, unless you're changing the color scheme.
- **/lua/opts.lua**

opts.lua is where you can configure various Neovim core settings.
things like leaderkey, tab size, folding options, search and case-sensitivity settings, etc.
- **/lua/tweaks.lua**

tweaks.lua has various script snippets that run on startup. 
It's not a terribly well-organized file, more of a catch-all for things that don't fit elsewhere.
Notable features include:
    - "super backspace" - when backspacing, delete all whitespace up to the previous line.
    - enable system clipboard copying, even over SSH
    - configuration for file skeletons (more on this later)
- **/lua/lsp_settings.lua**

lsp_settings.lua mostly handles settings pertaining to Neovim's LSP implementation itself, rather than any one LSP.
It does actually enable some LSPs that require a more manual touch as well, though.
Also, treesitter fold options are set here.
- **/lua/keybinds.lua**

keybinds.lua, despite what you might think, doesn't hold **ALL** the keybinds.
Instead, this contains *keybinds not specific to any one plugin,* with one or two exceptions (mostly relating to keeping related keybinds near each other for organization).
- **/lua/debug_opts.lua**

like lsp_settings.lua, this handles settings pertaining to Neovim's debug breakpoints implementation.
You can set custom icons/colors for debug breakpoints and whatnot here.

## Plugin settings

- **/template/<folder>**

Templates can be used in two ways: as manually-triggered templates via the `:Template` command, or as automatically-triggered "file skeletons", based on filename.
Skeletons must have associated pattern rules created, which can be pretty powerful. 
An example is listed in `tweaks.lua`, though if you plan to use these extensively it would probably be better to make a `skeletons.lua` file and put them there.
Alternatively, manual templates are simply placed into the template folder (I group mine into subfolders by language, but you don't have to), and then invoked via `:Template <filename>`.

Templates are pretty extensible, ranging from simple autofills based on file name all the way up to full Lua-powered snippets and tab-through form-style completions.
More info here: https://github.com/nvimdev/template.nvim

- **/lua/config/lazy.lua**

This is just a copy-paste of the init code for Lazy.lua, the plugin manager used for this config.
Lazy is one of the most popular plugin managers for Neovim, though not the only one.
You can view its interface with the `:Lazy` command to learn more about it.

- **/lua/plugins/\*.lua**

To keep things simple, I've grouped similar plugins into their own lua files. 
Any lua file that starts with a `return {}` inside the plugins folder will automatically get picked up by lazy.nvim,
so you can add your own groups as needed. I've also added comments describing each plugin, and you can find custom keymappings related to that plugin called out in the `keys` section.
Some plugins come with their own keys pre-mapped, and those aren't in `keys`, so if you're not sure what a plugin does and I haven't explained it below, a quick google search should yield more information.

> NOTE: I **highly recommend** perusing these plugins before starting any serious work. 
Not only do some of them (the AI plugins in particular) require some setup if you plan to use them in any way that isn't exactly how I used them,
but some of them have many more settings than what I choose to actively use that you may find very helpful.
Half the reason why Neovim is awesome is the complete control it gives you over your dev environment; get to know it, tweak it, fiddle with it, and make it yours!

---
# Installation

## Prerequisites

The following languages/tools need to be installed globally:
- Lua (lua-rocks is optional, but recommended)
- Ruby (Gem)
- Python (pip)
- Dotnet
- Nodejs (npm)

Additionally, the following utilites are needed:
- treesitter CLI (https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
- fzf
- ripgrep
- fd
- unzip


## Initial Setup

Once you install Neovim and clone this config into your settings folder, Lazy should automatically start on launch and begin installing plugins.
There may or may not be a couple of errors that occur during this, due to the order of plugin installs being non-deterministic, but these should go away upon restarting.

Next, Mason should attempt to download and install a pre-set list of LSPs, linters, debuggers and formatters for some common languages. 
If you've installed all the prerequisites, this should work; if not, a few may fail.
You can always re-attempt the downloads with `:MasonToolsInstall`, or simply use `:Mason` to browse through available LSPs/DAPs/linters/formatters and install them yourself.

Finally, a manual step: installing treesitters. Treesitters are what turn code into syntax trees used for highlighting, and they're installed individually for different languages. 
Thankfully, the `:TSInstall` command has tab-completion, so you can peruse which ones are available fairly easily. 
`:TSInstall` also accepts a list of languages, so if you know which treesitters you need, you can run `:TSInstall <lang_a> <lang_b> <lang_c> ...` to get them all at once.

After this, I highly recommand 

---

# Notable Plugins / Keybind Crash Course

> NOTE: This is not going to call out existing vim keybinds; there are lots of learning tools for that already. 
Try vimtutor from the command line, if it's availble, or google "vim adventure" for a gamified learning experience!

## UI Elements 

- `<F2>` toggles the file tree
- `<F3>` toggles the floating terminal
- `<F4>` toggles the task runner dropdown, which pulls from the VSCode `tasks.json` file present in the project. `<Shift-F4>` toggles the task runner view window, where you can monitor the state of running tasks and their associated terminals.
- `<F12>` toggles fullscreen mode for a window.
 
- `<Tab>` and `<Shift-Tab>` navigate open buffers
- Ctrl + arrow keys resize windows
- `<Space>` is the default leader key, but if you press no other buttons after, it should display the which-key UI, which lets you peruse keybinds a bit, if you're getting a bit lost.
- `<leader>w` closes a tab but stops if there are unsaved changes; `<leader>W` forces it to close regardless of saving.

## AI tools

- `<leader>ai` opens your configured AI CLI (claude code / copilot CLI / etc)
- `<leader>ac` toggles a chat window - great for quick conversations!
- `:CodeCompanion <question>` can also be used for quick one-liner questions.

## Code Assists

- `<Ctrl-C>` does not copy; it toggles the code completion menu!
- `<Ctrl-J` and `<Ctrl-K>` navigate the list, and `<Tab>` inserts and jumps to the end of the line.
- Some code completions are snippets that may let you fill pieces and jump around using `<Tab>` as well, just FYI.

- `<leader>fr` activates Grug Find and Replace, a more advanced, project-wide replacement tool.

> `<leader>c` tends to be the "prefix" for most code-related commands.

- `<leader>cr` renames a variable across the workspace.
- `<leader>cv` gives you "hover info" - this is LSP-dependent, but usually it at least shows type info and docs if available.
- `<leader>ca` gives you "code actions" - this is, again, whatever your LSP offers.
- `<leader>cd` shows diagnostics for the current file; `<leader>cD` shows diagnostics for the whole workspace (or at least as much as the LSP supports displaying).
- `<leader>cs` shows a list of all symbols for the file
- `<leader>cu` lets you see "usages" of whatever your cursor was hovering. This includes definitions, implementations, incoming/outgoing calls, etc.
- `<leader>ct` shows all your TODO comments!
- `<leader>cj` isn't actually from a plugin; if you have `jq` installed on your system, it will attempt to run JSON formatting on the current buffer!
- `<leader>cf` will manually trigger Conform formatting on your current buffer with whichever formatters you have configured. 

## Code Testing

- `<leader>ts` will show the Neotest summary window, where you can see and execute individual tests.
- `<leader>to` will open the output pane, where you can view test output or information on failing tests.
- `<leader>tt` will run the test nearest to your cursor, `<leader>tT` will run the test suite in the current file.

## Code Debugging

- `<F5>` shows the debug launch options, as well as handling settings for any running debug sessions.
- `<F6>` steps out of a function; `<F7>` steps over, `<F8>` steps into.
- `<F9>` puts a breakpoint on the current line.
- `<F10>` toggles the debug UI, letting you view breakpoints, logs, watches, etc
- `<F11>` SHOULD evaluate what your cursor is on - this is WIP, use with caution. Usually easier to set a watch manually.

## Find commands

> `<leader>f` is the find prefix

- `<leader>ff` lists open buffers
- `<leader>fF` searches all file names
- `<leader>fg` does a "grep search" - basically fuzzy text search against the whole workspace
- `<leader>fc` shows "git changes", listing only files with uncommitted modifications in git

## Goto commands

> `<leader>g` is the goto prefix

- `<leader>gu` - Goto usages
- `<leader>gd` - Goto definition, `<leader>gD` goes to type definition (i.e. interfaces)
- `<leader>gi` and `<leader>go` goto incoming/outgoing calls

- `<leader>j` activates "jump mode" - start typing the first 2-3 letters of something you see on screen and you'll be given a jump option to move your cursor there.

## QFlist/Loclist/bookmarks
> for QFlist, replace `l` with `q`. for bookmarks, replace `l` with `m`

- `<leader>lo` opens your loclist
- `<leader>la` adds the current line to the loclist
- `<leader>ld` deletes the entry
- `<leader>]l` and `<leader>[l` move through the loclist entries in the current file

# Other Commands to Know

`:Leet`
`:Gitsigns preview_hunk`
`:Neogit`
`:Template`
`:OverseerRun`
`:Telescope`
`:checkhealth`

