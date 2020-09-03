" Config for various neovim specific plugins/features, e.g. nvim-lsp
" Last change   02 Sep 2020


packadd nvim-lsp


lua <<EOF
    local lsp = require('nvim_lsp')

    local function mapper(mode, key, result)
        vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, slient})
    end

    local function custom_on_attach(client)
        require('completion').on_attach(client)

        mapper('n', 'gd',    '<cmd>lua vim.lsp.buf.declaration()<CR>')
        mapper('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
        mapper('n', 'K',     '<cmd>lua vim.lsp.buf.hover()<CR>')
        mapper('n', 'gD',    '<cmd>lua vim.lsp.buf.implementation()<CR>')
        mapper('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        mapper('n', '1gD',   '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        mapper('n', 'gr',    '<cmd>lua vim.lsp.buf.references()<CR>')
        mapper('n', 'g0',    '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
        mapper('n', 'gW',    '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

        vim.cmd('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
        vim.cmd('setlocal completeopt=menuone,noinsert,noselect')
    end

    lsp.texlab.setup({
                on_attach = custom_on_attach,
                settings  = {
                    latex = {
                        forwardSearch = {
                            executable = "evince_dbus.py",
                            args = { "%p", "%l", "%f" }
                        }
                    }
                }
            })
EOF
