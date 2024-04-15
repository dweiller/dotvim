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

local function mapper(mode, key, result, opts, desc)
    opts = opts or {}
    opts = vim.tbl_extend('keep', opts, { buffer = 0, noremap = true, silent = true, desc = desc })
    vim.keymap.set(mode, key, result, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf, noremap = true, silent = true }
        mapper('n', 'gd',    vim.lsp.buf.declaration, opts, "goto declaration (LSP)")
        mapper('n', '<c-]>', vim.lsp.buf.definition, opts, "goto definifion (LSP)")
        mapper('n', 'K',     vim.lsp.buf.hover, opts, "hover information (LSP)")
        mapper('n', 'gi',    vim.lsp.buf.implementation, opts, "list implementations (LSP)")
        mapper('n', '<c-k>', vim.lsp.buf.signature_help, opts, "signature help (LSP)")
        mapper('n', '1gD',   vim.lsp.buf.type_definition, opts, "goto type definition (LSP)")
        mapper('n', 'gr',    vim.lsp.buf.references, opts, "list references (LSP)")
        mapper('n', 'g0',    vim.lsp.buf.document_symbol, opts, "list document symbols (LSP)")
        mapper('n', 'gW',    vim.lsp.buf.workspace_symbol, opts, "list workspace symbols (LSP)")
        mapper('n', '<leader>=', vim.lsp.buf.format, opts, "format (LSP)")
        mapper('n', '<leader>a', vim.lsp.buf.code_action, opts, "code action (LSP)")
        mapper('n', '<leader>rn', vim.lsp.buf.rename, opts, "rename symbol (LSP)")

        vim.api.nvim_buf_set_option(ev.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
    end
})

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
    on_new_config = function(new_config, new_root_dir)
        local root_config = lspconfig.util.path.join(new_root_dir, "zls.json")
        if lspconfig.util.path.exists(root_config) then
            table.insert(new_config.cmd, "--config-path")
            table.insert(new_config.cmd, root_config)
        end
    end,
}

lspconfig.rust_analyzer.setup {
    on_attach = custom_on_attach,
    capabilities = capabilities,
}

-- nvim-treesitter
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

-- neogen
require'neogen'.setup({
    snippet_engine = "luasnip",
})

-- fidget
require'fidget'.setup()

-- nvim-dap
require'dap'.adapters.zig = {
    type = 'executable',
    command = 'lldb-vscode-14',
}
