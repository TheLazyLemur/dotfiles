local now = MiniDeps.now

now(function()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.g.have_nerd_font = false

  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.mouse = "a"
  vim.opt.showmode = false
  vim.opt.clipboard = "unnamedplus"
  vim.opt.breakindent = true
  vim.opt.undofile = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.signcolumn = "yes"
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  vim.opt.splitright = true
  vim.opt.splitbelow = true
  vim.opt.list = false
  vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
  vim.opt.inccommand = "split"
  vim.opt.cursorline = true
  vim.opt.scrolloff = 10
  vim.opt.hlsearch = true
  vim.opt.laststatus = 3
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  vim.opt.swapfile = false
  vim.opt.wrap = false

  if vim.g.neovide then
    vim.opt.linespace = 0
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_input_macos_alt_is_meta = false
  end
end)
