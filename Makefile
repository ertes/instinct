.PHONY: all init

package = $(or $(filter-out skeleton,$(patsubst %.cabal,%,$(wildcard *.cabal))),$(notdir $(realpath .)))

all: dist/setup-config $(package).cabal
	cabal build
	cabal test

$(package).cabal:
	sed -i -e 's/_PACKAGE_/$(package)/g' \
		.gitignore \
		LICENSE \
		README.md \
		Setup.lhs \
		program/Main.hs \
		skeleton.cabal \
		test/Bench.hs \
		test/Props.hs
	mv skeleton.cabal $(package).cabal
	ln -s dist/build/$(package)/$(package)
	git init
	git remote add origin git@github.com:ertes/$(package).git
	git add \
		LICENSE Makefile README.md Setup.lhs .gitignore \
		$(package).cabal program test

dist/setup-config: $(package).cabal
	cabal configure --enable-benchmarks --enable-tests
