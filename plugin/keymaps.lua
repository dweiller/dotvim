local mappings = {}

mappings.general = {
    { 'n', '[d', vim.diagnostic.goto_prev },
    { 'n', ']d', vim.diagnostic.goto_next },
}

mappings.luasnip = {
    { 'i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", { remap = true, expr = true, replace_keycodes = false } },
    { 's', '<Tab>', function() require"luasnip".jump(1) end },
    { {'i', 's'}, '<S-Tab>', function() require"luasnip".jump(-1) end },
    { {'i', 's'}, '<C-E>', '<Plug>luasnip-next-choice' },
}

vim.g.kommentary_create_default_mappings = false
mappings.kommentary = {
    { 'n', '<leader>cc', '<Plug>kommentary_line_default' },
    { 'n', '<leader>c', '<Plug>kommentary_motion_default' },
    { 'x', '<leader>c', '<Plug>kommentary_visual_default<ESC>' },
    { 'n', '<leader>ic', '<Plug>kommentary_line_increase' },
    { 'x', '<leader>ic', '<Plug>kommentary_visual_increase' },
    { 'n', '<leader>dc', '<Plug>kommentary_line_decrease' },
    { 'x', '<leader>dc', '<Plug>kommentary_visual_decrease' },
}

mappings.zettelkasten = {
    { 'n', '<leader>zi', function() require"zettelkasten".open_index() end },
    { 'n', '<leader>zn', function() require"zettelkasten".new_zettel() end },
}


for _, plugin in pairs(mappings) do
    for _, v in ipairs(plugin) do
        vim.keymap.set(unpack(v))
    end
end
