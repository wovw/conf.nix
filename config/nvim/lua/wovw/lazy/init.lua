return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false
    },
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    { 'wakatime/vim-wakatime', lazy = false },
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({})
        end,
    },
    "eandrju/cellular-automaton.nvim",
}
