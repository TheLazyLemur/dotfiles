---@class InputComponent
---@field public bufnr number
---@field public winid number
---@field public callback fun(input: string)
local InputComponent = {}
InputComponent.__index = InputComponent

---@class InputComponentOpts
---@field relative string
---@field height number
---@field width number
---@field row number
---@field col number
local InputComponentOpts = {}
InputComponentOpts.__index = InputComponentOpts

---@param callback fun(input: string)
---@return InputComponent
function InputComponent:new(callback)
    local instance = setmetatable({}, InputComponent)
    instance.callback = callback
    return instance
end

---@param opts InputComponentOpts | nil
function InputComponent:open(opts)
    local default_opts = {
        relative = "editor",
        width = 20,
        height = 10,
        row = 0,
        col = 0,
    }

    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    self.bufnr = vim.api.nvim_create_buf(false, true)
    self.winid = vim.api.nvim_open_win(self.bufnr, true, {
        relative = opts.relative,
        width = opts.width,
        height = opts.height,
        row = opts.row,
        col = opts.col,
        style = "minimal",
        border = "single",
        title = "Input",
    })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = self.bufnr,
        group = vim.api.nvim_create_augroup("Input-Comp-TextChanged", { clear = true }),
        callback = function()
            self.callback(vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)[1])
        end
    })
end

---@class Component
---@field public InputComponent InputComponent
---@field public InputComponentOpts InputComponentOpts
return {
    InputComponent = InputComponent,
    InputComponentOpts = InputComponentOpts,
}
