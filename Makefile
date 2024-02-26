fmt:
	echo "===> Formatting"
	stylua lua/ --config-path=.stylua.toml

lint:
	echo "===> Linting"
	luacheck lua/ --globals vim

pr-ready: fmt lint

.PHONY: test
test:
	nvim --headless -c "source scripts/minimal_init.lua" -c "PlenaryBustedDirectory tests"
