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
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- nvim-lsp
local lspconfig = require('lspconfig')

local function mapper(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, slient})
end

local function custom_on_attach(client)
    mapper('n', 'gd',    '<cmd>lua vim.lsp.buf.declaration()<CR>')
    mapper('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    mapper('n', 'K',     '<cmd>lua vim.lsp.buf.hover()<CR>')
    mapper('n', 'gD',    '<cmd>lua vim.lsp.buf.implementation()<CR>')
    mapper('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    mapper('n', '1gD',   '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    mapper('n', 'gr',    '<cmd>lua vim.lsp.buf.references()<CR>')
    mapper('n', 'g0',    '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    mapper('n', 'gW',    '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

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

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
    highlight = { enable = true, },
    indent = { enable = true, },
    incremental_selection = { enable = true, },
}

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.fen = {
    filetype = 'fen',
}

parser_config.gcode = {
    filetype = 'gcode',
}
