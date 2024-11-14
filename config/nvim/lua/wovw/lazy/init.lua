return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false
    },
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({})
        end,
    },
    { 'wakatime/vim-wakatime', lazy = false },
    "eandrju/cellular-automaton.nvim",
}
