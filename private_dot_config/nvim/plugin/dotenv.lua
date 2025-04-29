local function load_dotenv()
    local cwd = vim.fn.getcwd()
    local dotenv = vim.fn.findfile(".env", cwd .. ";")
    if dotenv == "" then
        return
    end
    for line in io.lines(dotenv) do
        if not line:match("^%s*#") and line:match("%S") then
            local key, val = line:match("^([%w_]+)%s*=%s*(.*)$")
            if key and val then
                val = val:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
                vim.env[key] = val
            end
        end
    end
end

load_dotenv()
