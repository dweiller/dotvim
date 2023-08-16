local mappings = {}

mappings.general = {
    { 'n', '[d', vim.diagnostic.goto_prev },
    { 'n', ']d', vim.diagnostic.goto_next },
    { 'n', '<leader>pv', vim.cmd.Explore },
    { 'v', 'J', ":move '>+1<CR>gv=gv" },
    { 'v', 'K', ":move '<-2<CR>gv=gv" },
    { 'n', 'n', 'nzzzv:lua require("hlnext").HLNext()<CR>', { silent = true } },
    { 'n', 'N', 'Nzzzv:lua require("hlnext").HLNext()<CR>', { silent = true } },
    { 'n', '*', '*zzzv:lua require("hlnext").HLNext()<CR>', { silent = true } },
    { 'n', '#', '#zzzv:lua require("hlnext").HLNext()<CR>', { silent = true } },
    { 'n', '<leader>y', '"+y', { desc = 'yank to + register' } },
    { 'v', '<leader>y', '"+y', { desc = 'yank to + register' } },
    { 'n', '<leader>Y', '"+y$', { desc = 'yank to + register' } },
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

local ts_builtin = require'telescope.builtin'

mappings.telescope = {
    { 'n', '<leader>ff', ts_builtin.find_files, { desc = 'Find files' } },
    { 'n', '<leader>fg', ts_builtin.live_grep, { desc = 'Grep files' } },
    { 'n', '<C-p>', ts_builtin.git_files, { desc = 'Find git files' } }
}

do
    local mark = require'harpoon.mark'
    local ui = require'harpoon.ui'
    mappings.harpoon = {
        { 'n', '<leader>ma', mark.add_file, { desc = 'Add file to harpoon' } },
        { 'n', '<leader>ms', ui.toggle_quick_menu, { desc = 'Show harpoon marks' } },
        { 'n', '<M-j>', function() ui.nav_file(1) end, { desc = 'Harpoon to file 1' } },
        { 'n', '<M-k>', function() ui.nav_file(2) end, { desc = 'Harpoon to file 2' } },
        { 'n', '<M-l>', function() ui.nav_file(3) end, { desc = 'Harpoon to file 3' } },
        { 'n', '<M-;>', function() ui.nav_file(4) end, { desc = 'Harpoon to file 4' } },
    }
end

mappings.undotree = {
    { 'n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' } },
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
