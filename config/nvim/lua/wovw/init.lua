require("wovw.set")
require("wovw.remap")
require("wovw.lazy_init")

local augroup = vim.api.nvim_create_augroup
local wovwGroup = augroup('wovw', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = wovwGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('BufEnter', {
    group = wovwGroup,
    callback = function()
        vim.cmd.colorscheme("tokyonight-night")
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
