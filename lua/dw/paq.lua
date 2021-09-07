--Bootstrap paq
local fn = vim.fn


local download_packages = false
local function download_paq()
    if fn.input('Download Paq? (y for yes): ') ~= 'y' then
        return
    end

    local install_path = string.format('%s/site/pack/paqs/start/paq-nvim', fn.stdpath('data'))

    print 'Downloading paq-nvim'

    local out = fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})

    print(out)
    download_packages = true
    vim.opt.runtimepath:append(install_path)
end

if not pcall(require, 'paq') then
    download_paq()
end

require 'paq' {
    'savq/paq-nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
    {'norcalli/nvim-colorizer.lua', opt=true},
}

if download_packages then
    print 'Downloading Paq packages, you will need to restart neovim in order for them to work'
    require 'paq':install()
    _G['bootstrap-paq'] = true
end
