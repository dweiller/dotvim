-- bail out if bootstrapping
if _G['bootstrap-paq'] then
    return
end

-- nvim-cmp
if (pcall(require, 'cmp')) then
    local cmp = require('cmp')
    cmp.setup {
        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'path' },
            { name = 'luasnip' },
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert(),
    }

    cmp.setup.cmdline {
        mapping = cmp.mapping.preset.cmdline(),
    }
end

local function mapper(mode, key, result, opts, desc)
    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { buffer = 0, noremap = true, silent = true, desc = desc })
    vim.keymap.set(mode, key, result, opts)
end

-- nvim-treesitter
if (pcall(require, 'nvim-treesitter')) then
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "vimdoc", "vim", "comment", "markdown", "c", "lua" },
        sync_install = false,
        highlight = {
            enable = true,
            disable = { 'vimdoc' },
        },
        indent = { enable = true, },
        incremental_selection = { enable = true, },
        playground = { enable = true },
        query_linter = { enable = true },
        tree_docs = { enable = true },
    }

    local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
    parser_config.fen = {
        filetype = 'fen',
    }

    parser_config.gcode = {
        filetype = 'gcode',
    }
end

-- gitsigns.nvim
local next_change = function()
    if vim.wo.diff then
        return ']c'
    else
        return '<cmd>Gitsigns next_hunk<CR>'
    end
end

local prev_change = function()
    if vim.wo.diff then
        return '[c'
    else
        return '<cmd>Gitsigns prev_hunk<CR>'
    end
end

if (pcall(require, 'gitsigns')) then
    require'gitsigns'.setup {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local opts = { buffer = bufnr }
            mapper('n', ']c', next_change, { buffer = bufnr, expr = true, desc = "goto next change" })
            mapper('n', '[c', prev_change, { buffer = bufnr, expr = true, desc = "goto previous change" })
            mapper('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "stage change" })
            mapper('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "reset change" })
            mapper('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "unstage change" })
            mapper('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "stage buffer" })
            mapper('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = "reset buffer" })
            mapper('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "preview change" })
            mapper('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "show blame" })
            mapper('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "show diff" })
            mapper('n', '<leader>hD', function() gs.diffthis("~") end, { buffer = bufnr, desc = "show diff against HEAD" })
            mapper('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = "toggle deleted change" })
            mapper('n', '<leader>hl', gs.setloclist, { buffer = bufnr, desc = "send hunks to loclist" })
        end,
    }
end

-- zettelkasten
require'zettelkasten'.setup()

-- kommentary
if (pcall(require, 'kommentary')) then
    require'kommentary.config'.configure_language("arduino", {
        single_line_comment_string = "//",
        multi_line_comment_strings = {"/*", "*/"},
    })
end

-- leap
if (pcall(require, 'leap')) then
    require'leap'.add_default_mappings()
end

-- neogen
if (pcall(require, 'neogen')) then
    require'neogen'.setup({
        snippet_engine = "luasnip",
    })
end

-- fidget
if (pcall(require, 'fidget')) then
    require'fidget'.setup()
end

-- nvim-dap
if (pcall(require, 'dap')) then
    require'dap'.adapters.zig = {
        type = 'executable',
        command = 'lldb-vscode-14',
    }
end

-- nvim-surround
if (pcall(require, 'nvim-surround')) then
    require'nvim-surround'.setup({})
end
