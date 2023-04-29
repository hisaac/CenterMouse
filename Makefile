# Grabs the current directory and the path to this file for use in other scripts
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir  := $(dir $(mkfile_path))
project_dir := $(mkfile_dir)
scripts_dir := $(project_dir)scripts/

build:
	@echo "Building project..."
	@$(scripts_dir)build.sh
.PHONY: build

clean:
	rm -rf $(project_dir)DerivedData
.PHONY: clean
