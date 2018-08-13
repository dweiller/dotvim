Installation instructions
-------------------------

1.  Clone the repository:

		git clone --recurse-submodules git://github.com/dweiller/dotvim.git ~/.vim
2.  Run the install script:

		cd ~/.vim
		chmod u+x install.sh
		./install.sh
3. Dependencies:
  - You must have exuberant-ctags installed in order for TagBar to function. See [ctags](http://ctags.sourceforge.net/ctags.html). To install in Ubuntu run:

			sudo apt-get install exuberant-ctags

  - You can also use universal-ctags, though currently you will have to build it yourself. See [universal-ctags](http://github.com/universal-ctags/ctags).

Installation of bundles
-----------------------

To install bundles as submodules we have a helper script dotvim.sh.

To install a bundle as a git submodule run
		dotvim.sh bundle --install=url
where the url is for a git repository. NOTE: The dotvim.sh script is currently untested.
