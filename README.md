Installation instructions
-------------------------

  1. Clone the repository:

         git clone --recurse-submodules git://github.com/dweiller/dotvim.git REPO

     where `REPO` should be `~/.vim` and `.config/nvim` for neovim. If the directory exists, ether remove it first or you'll have to integrate this repo manually into your setup.

  2. Run make sure `vimrc` is sourced by (neo)vim (and `REPO` is on the runtimepath if you didn't clone it into the suggested place).

     For vim this can be done by symlinking:

         ln -s ~/.vim/vimrc ~/.vimrc

    For neovim do:

         ln -s ~/.config/nvim/vimrc ~/.config/nvim/init.vim

#### Dependencies:

  - You must have [exuberant-ctags](http://ctags.sourceforge.net/ctags.html) or [universal-ctags](http://github.com/universal-ctags/ctags) installed in order for TagBar to function. To install in Ubuntu run:

        sudo apt install exuberant-ctags

    or

        sudo apt install universal-ctags

  - I'd recommend universal-ctags - it's a maintained fork of exuberant-ctags, but is only available in the Ubuntu repositories from disco (19.04) onwards. If you're on an older version I would suggest building universal-ctags from source rather than using exuberant-ctags (I recall discovering universal-ctags after having problems with exuberant-ctags).

#### Vim compatibility

I generally use neovim, but hopefully the configuration here should work with modern versions of vim (probably not the smaller builds) as well. I only use vim occasionally and if I encounter problems I fix them, but things might break for vim in between times that I load up vim.
