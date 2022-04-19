local mappings = {}

mappings.general = {
    { 'n', '[d', vim.diagnostic.goto_prev, { noremap = true } },
    { 'n', ']d', vim.diagnostic.goto_next, { noremap = true } },
}

mappings.luasnip = {
    { 'i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", { remap = true, expr = true } },
    { 's', '<Tab>', function() require"luasnip".jump(1) end, { noremap = true } },
    { {'i', 's'}, '<S-Tab>', function() require"luasnip".jump(-1) end, { noremap = true } },
    { {'i', 's'}, '<C-E>', '<Plug>luasnip-next-choice', {} },
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
    { 'n', '<leader>zi', function() require"zettelkasten".open_index() end, { noremap = true } },
    { 'n', '<leader>zn', function() require"zettelkasten".new_zettel() end, { noremap = true } },
}


vim.g.lightspeed_no_default_keymaps = true
mappings.lightspeed = {
    { 'n', 's', '<Plug>Lightspeed_s', {} },
    { 'x', 's', '<Plug>Lightspeed_s', {} },
    { 'n', 'S', '<Plug>Lightspeed_S', {} },
    { 'n', 'gs', '<Plug>Lightspeed_gs', {} },
    { 'n', 'gS', '<Plug>Lightspeed_gS', {} },
    { 'o', 'z', '<Plug>Lightspeed_z', {} },
    { 'o', 'Z', '<Plug>Lightspeed_Z', {} },
    { 'o', 'x', '<Plug>Lightspeed_x', {} },
    { 'o', 'X', '<Plug>Lightspeed_X', {} },
}

for _, plugin in pairs(mappings) do
    for _, v in ipairs(plugin) do
        vim.keymap.set(unpack(v))
    end
end
