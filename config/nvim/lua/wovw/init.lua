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
    callback = function(args)
        -- Check if any attached LSP client can format
        local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
        local can_format = false
        for _, client in pairs(clients) do
            if client.supports_method("textDocument/formatting") then
                can_format = true
                break
            end
        end

        if can_format then
            vim.lsp.buf.format({ async = false })
        else
            -- Fallback to removing trailing whitespace
            vim.cmd([[%s/\s\+$//e]])
        end
    end,
})

autocmd('BufEnter', {
    group = wovwGroup,
    callback = function()
        vim.cmd.colorscheme("tokyonight-night")
        vim.cmd [[highlight TreesitterContext guibg=NONE ctermbg=NONE]]
    end
})

autocmd('FileType', {
    group = wovwGroup,
    pattern = 'netrw',
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_preview = 1
vim.g.netrw_altv = 1
