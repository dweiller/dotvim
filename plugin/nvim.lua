-- bail out if bootstrapping
if _G['bootstrap-paq'] then
    return
end

-- nvim-cmp
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- nvim-lsp
local lspconfig = require('lspconfig')

local function mapper(mode, key, result, opts)
    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { buffer = 0, noremap = true, silent = true })
    vim.keymap.set(mode, key, result, opts)
end

local function custom_on_attach(client, bufnr)
    local opts = { buffer = bufnr }
    mapper('n', 'gd',    vim.lsp.buf.declaration, opts)
    mapper('n', '<c-]>', vim.lsp.buf.definition, opts)
    mapper('n', 'K',     vim.lsp.buf.hover, opts)
    mapper('n', 'gi',    vim.lsp.buf.implementation, opts)
    mapper('n', '<c-k>', vim.lsp.buf.signature_help, opts)
    mapper('n', '1gD',   vim.lsp.buf.type_definition, opts)
    mapper('n', 'gr',    vim.lsp.buf.references, opts)
    mapper('n', 'g0',    vim.lsp.buf.document_symbol, opts)
    mapper('n', 'gW',    vim.lsp.buf.workspace_symbol, opts)
    mapper('n', '<leader>=', vim.lsp.buf.format, opts)
    mapper('n', '<leader>a', vim.lsp.buf.code_action, opts)
    mapper('n', '<leader>rn', vim.lsp.buf.rename, opts)

    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
end

lspconfig.texlab.setup {
    on_attach = custom_on_attach,
    settings  = {
        latex = {
            forwardSearch = {
                executable = "evince_dbus.py",
                args = { "%p", "%l", "%f" }
            }
        }
    },
    capabilities = capabilities,
}

lspconfig.ocamllsp.setup {
    on_attach = custom_on_attach,
    root_dir = lspconfig.util.root_pattern(
                    'dune-project',
                    'dune-workspace',
                    '*.opam',
                    'package.json',
                    '.merlin',
                    'dune'),
    capabilities = capabilities,
}

lspconfig.zls.setup {
    on_attach = custom_on_attach,
    capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
    on_attach = custom_on_attach,
    capabilities = capabilities,
}

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "vimdoc", "vim", "comment", "markdown", "c", "lua" },
    sync_install = false,
    auto_intall = true,
    highlight = {
        enable = true,
        disable = { 'vimdoc' },
    },
    indent = { enable = true, },
    incremental_selection = { enable = true, },
    context_commentstring = { enable = true, },
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

require'gitsigns'.setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }
        mapper('n', ']c', next_change, { buffer = bufnr, expr = true })
        mapper('n', '[c', prev_change, { buffer = bufnr, expr = true })
        mapper('n', '<leader>hs', gs.stage_hunk, opts)
        mapper('n', '<leader>hr', gs.reset_hunk, opts)
        mapper('n', '<leader>hu', gs.undo_stage_hunk, opts)
        mapper('n', '<leader>hS', gs.stage_buffer, opts)
        mapper('n', '<leader>hR', gs.reset_buffer, opts)
        mapper('n', '<leader>hp', gs.preview_hunk, opts)
        mapper('n', '<leader>hb', function() gs.blame_line({ full = true }) end, opts)
        mapper('n', '<leader>hd', gs.diffthis, opts)
        mapper('n', '<leader>hD', function() gs.diffthis("~") end, opts)
        mapper('n', '<leader>td', gs.toggle_deleted, opts)
    end,
}

-- zettelkasten
require'zettelkasten'.setup()

-- kommentary
require'kommentary.config'.configure_language("arduino", {
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})

-- leap
require'leap'.add_default_mappings()
