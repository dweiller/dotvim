vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking test',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank({
            higroup = 'Decorator',
            timeout = 250,
            on_visual = false,
        })
    end,
})
