local mappings = {
    {'i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", { expr = true }},
    {'s', '<Tab>', '<cmd>lua require"luasnip".jump(1)<CR>', { noremap = true }},
    {'i', '<S-Tab>', '<cmd>lua require"luasnip".jump(-1)<CR>', { noremap = true }},
    {'s', '<S-Tab>', '<cmd>lua require"luasnip".jump(-1)<CR>', { noremap = true }},
    {'i', '<C-E>', '<Plug>luasnip-next-choice', {}},
    {'s', '<C-E>', '<Plug>luasnip-next-choice', {}},
}

for _, v in ipairs(mappings) do
    vim.api.nvim_set_keymap(unpack(v))
end
