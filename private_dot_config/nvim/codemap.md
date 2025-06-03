# Neovim Configuration Codemap

## Core Architecture

### Entry Points
- **init.lua** - Main entry point with version check (requires Neovim 0.11+)
- **lua/core/init.lua** - Plugin manager bootstrap and core module loader

### Core Modules (`lua/core/`)
- **options.lua** - Editor settings, GUI optimizations, file type associations
- **keymaps.lua** - Comprehensive keybinding system with LSP and filetype-specific mappings
- **lsp.lua** - LSP client configuration and floating window styling
- **autocommands.lua** - Auto-commands for various editor behaviors

## Plugin System (`lua/plugins/`)

### UI & Interface
- **snacks.lua** - Primary UI framework (dashboard, picker, explorer, notifications)
- **colorscheme.lua** - rose-pine theme with custom highlights
- **oil.lua** - File manager integration
- **flash.lua** - Fast navigation system
- **trouble.lua** - Diagnostic and quickfix management

### Completion & AI
- **blink.lua** - Rust-based completion engine with Copilot integration
- **codecompanion.lua** - AI coding assistant with custom MCP tools and system prompts

### Development Tools
- **dap.lua** - Debug Adapter Protocol setup with Go and Dart-specific configurations
- **neotest.lua** - Testing framework integration
- **conform.lua** - Code formatting
- **lint.lua** - Linting configuration
- **treesitter.lua** - Syntax highlighting and parsing

### Editor Enhancements
- **multicursor.lua** - Multiple cursor functionality
- **mini.lua** - Mini plugin suite
- **kuala.lua** - HTTP request testing
- **markdown.lua** - Markdown support
- **neorg.lua** - Note-taking and organization
- **rainbow.lua** - Rainbow bracket highlighting

## Language Server Configuration (`lsp/`)

### Supported Languages (9 total)
- **gopls.lua** - Go language server
- **lua_ls.lua** - Lua language server
- **ts_ls.lua** - TypeScript/JavaScript language server
- **omnisharp.lua** - C# language server
- **svelte-language-server.lua** - Svelte framework support
- **prismals.lua** - Prisma ORM support
- **templ.lua** - Templ templating language
- **clangd.lua** - C/C++ language server
- **dartls.lua** - Dart/Flutter language server

## Custom Plugins (`plugin/`)

### Utilities
- **tuiwrapper.lua** - Interactive command wrapper for TUI applications (lazygit, lazydocker)
- **termmy.lua** - Custom terminal wrapper
- **dotenv.lua** - Environment variable loading
- **uuid.lua** - UUID generation utilities
- **refernce_point.lua** - Reference point system

### Custom Systems
- **bookmark/init.lua** - Bookmarking system integration

## Key Functions & Mappings

### Core Navigation
```lua
-- Window Management
<C-hjkl>         -> Window navigation
ss/sv            -> Split horizontal/vertical
<C-arrows>       -> Resize windows

-- Buffer Management
<Tab>/<S-Tab>    -> Next/Previous buffer
<leader>1-9      -> Jump to buffer by index
<leader><leader> -> Buffer picker

-- File Operations
<leader>sf       -> Find files (Snacks picker)
<leader>sg       -> Live grep
<leader>/        -> Search lines in buffer
-                -> Oil file manager
```

### Development Workflows
```lua
-- LSP Operations (auto-mapped on LSP attach)
gd               -> Go to definition
gi               -> Go to implementation
gr               -> Show references
K                -> Hover documentation
<leader>ca       -> Code actions
<leader>rn       -> Rename symbol

-- Debugging (DAP)
<F5>             -> Smart debug (Go test detection)
<F1-3>           -> Step into/over/out
<F7>             -> Toggle DAP UI
<F9>             -> Debug last test (Go)
<leader>b        -> Toggle breakpoint

-- Testing (Go-specific)
<leader>tt       -> Run current test file
<leader>tf       -> Run single test
<leader>to       -> Show test output
<leader>tc       -> Go test subcase
<leader><F5>     -> Debug current test
```

### AI & Tools
```lua
-- CodeCompanion Integration
-- Custom MCP tools via mcphub.nvim:
-- - tree: Project tree overview
-- - search: Grep functionality  
-- - multi_grep: Multiple term search
-- - bat_range: Syntax highlighted file ranges
-- - recent_git_changes: Git change tracking
-- - project_overview: Statistics with tokei
-- - fuzzy_file_search: Fuzzy file finding

-- Multicursor
<C-n>            -> Add cursor to next match
<C-s>            -> Skip current match
<C-q>            -> Toggle multicursor mode
<leader>x        -> Delete cursor
<leader><esc>    -> Clear all cursors
```

### Diagnostics & Trouble
```lua
<leader>xx       -> Toggle workspace diagnostics
<leader>xX       -> Toggle buffer diagnostics
<leader>cs       -> Toggle symbols
<leader>cl       -> Toggle LSP references
<leader>xL       -> Toggle location list
<leader>xQ       -> Toggle quickfix
```

## Configuration Patterns

### Plugin Manager (lazy.nvim)
- Lazy loading enabled for performance
- Health checking active
- Lockfile management for reproducible builds
- Spec-based configuration with imports

### LSP Setup Pattern
- Individual server configurations in `lsp/` directory
- Custom floating window borders (rounded)
- Automatic keymap attachment on LSP client attach
- Mason integration for server management

### Filetype-Specific Configurations
- Pattern-based auto-command registration
- HTTP files: Kulala integration for API testing
- Go test files: Specialized debugging and testing keybindings
- Dynamic keymap loading based on file patterns

### GUI Optimization (Neovide)
- Font scaling support (Ctrl+=/Ctrl+-)
- macOS-specific keybindings (Cmd+S, Cmd+V)
- Cursor animation and trail configuration
- Line spacing optimization

## Dependencies & Integrations

### External Tools Required
- **eza** - Modern ls replacement for tree output
- **tokei** - Code statistics
- **ripgrep (rg)** - Fast grep replacement
- **fd** - Fast find replacement
- **bat** - Cat replacement with syntax highlighting
- **lazygit** - Git TUI
- **lazydocker** - Docker TUI
- **git** - Version control integration

### Language Dependencies
- **Go** - gopls, delve debugger, go test integration
- **Node.js** - TypeScript/JavaScript tooling
- **Rust** - For Blink.cmp compilation
- **C/C++** - clangd for language support
- **Dart** - Dart SDK for language server and debug adapter

## Security & Best Practices

### Code Quality Rules
- Zero tolerance for hardcoded secrets
- Mandatory codemap.md maintenance
- Input validation and defensive coding
- Environment isolation for credentials
- Security review requirements for sensitive code

### Development Patterns
- TDD approach encouraged
- Comprehensive error handling
- Modular architecture
- Reuse over duplication
- Performance-conscious plugin choices

## Performance Optimizations

### Rust-Based Tools
- Blink.cmp for faster completion than nvim-cmp
- Modern Lua APIs (uv/loop)
- Lazy loading strategy

### Memory Management
- Plugin lazy loading
- Conditional feature loading
- Efficient buffer management
- Smart caching strategies

This codemap serves as the definitive reference for understanding the structure, dependencies, and functionality of the Neovim configuration.



