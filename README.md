Installation instructions
-------------------------

  1. Clone the repository:

         git clone --recurse-submodules git://github.com/dweiller/dotvim.git ~/.vim

  2. Run the install script:

         cd ~/.vim
         chmod u+x install.sh
         ./install.sh

#### Dependencies:

  - You must have [exuberant-ctags](http://ctags.sourceforge.net/ctags.html) or [universal-ctags](http://github.com/universal-ctags/ctags) installed in order for TagBar to function. To install in Ubuntu run:

        sudo apt install exuberant-ctags

    or

        sudo apt install universal-ctags

  - I'd recommend universal-ctags - it's a maintained fork of exuberant-ctags, but is only avaliable in the Ubuntu repos from disco (19.04) onwards. If you're on an older version I would suggest building universal-ctags from source rather than using exuberant-ctags (I recall discovering universal ctags after having problems with exuberant-ctags).

Installation of bundles
-----------------------

To install bundles as submodules we have a helper script dotvim.sh.

To install a bundle as a git submodule run
		dotvim.sh bundle --install=url
where the url is for a git repository.
