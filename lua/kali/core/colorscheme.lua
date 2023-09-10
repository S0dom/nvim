vim.cmd "colorscheme catppuccin"

local colorscheme = "catppuccin"

local status_ok, _ = pcall(vim.cmd, "colorschem " .. colorscheme)
if not status_ok then
    vim.notify("colorschem " .. colorscheme .. "not found!")
    return
end

-- This is needed so the WinSeparator is seen with the colorschemes
-- Set `fg` to the color you want your window separators to have
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'gray', bold = true })
