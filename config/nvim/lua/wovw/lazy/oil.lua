return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
        require("oil").setup({
            keymaps = {
                ["C-h"] = false,
                ["C-l"] = false,
                ["M-h"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
                ["M-l"] = "actions.refresh",
            },
            view_options = {
                show_hidden = true,
            }
        })

        vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}
