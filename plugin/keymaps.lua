local mappings = {}

mappings.luasnip = {
    { 'i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", { expr = true } },
    { 's', '<Tab>', '<cmd>lua require"luasnip".jump(1)<CR>', { noremap = true } },
    { 'i', '<S-Tab>', '<cmd>lua require"luasnip".jump(-1)<CR>', { noremap = true } },
    { 's', '<S-Tab>', '<cmd>lua require"luasnip".jump(-1)<CR>', { noremap = true } },
    { 'i', '<C-E>', '<Plug>luasnip-next-choice', {} },
    { 's', '<C-E>', '<Plug>luasnip-next-choice', {} },
}

vim.g.kommentary_create_default_mappings = false
mappings.kommentary = {
    { 'n', '<leader>cc', '<Plug>kommentary_line_default', {} },
    { 'n', '<leader>c', '<Plug>kommentary_motion_default', {} },
    { 'x', '<leader>c', '<Plug>kommentary_visual_default<ESC>', {} },
    { 'n', '<leader>ic', '<Plug>kommentary_line_increase', {} },
    { 'x', '<leader>ic', '<Plug>kommentary_visual_increase', {} },
    { 'n', '<leader>dc', '<Plug>kommentary_line_decrease', {} },
    { 'x', '<leader>dc', '<Plug>kommentary_visual_decrease', {} },
}

mappings.zettelkasten = {
    { 'n', '<leader>zi', '<cmd>lua require"zettelkasten".open_index()<CR>', {} },
    { 'n', '<leader>zn', '<cmd>lua require"zettelkasten".new_zettel()<CR>', {} },
}

for _, plugin in pairs(mappings) do
    for _, v in ipairs(plugin) do
        vim.api.nvim_set_keymap(unpack(v))
    end
end
