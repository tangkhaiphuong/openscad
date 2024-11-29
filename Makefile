# Description: Makefile for the project
# Author: Patrick Tang

# Variables
OPENSCAD_PATH := $(HOME)/Documents/OpenSCAD/libraries
PROJECT_PATHS := $(shell ls src)
LIB_URLS := "https://github.com/BelfrySCAD/BOSL2.git"

.PHONY: all
all: init render

# Targets
init:
	@echo "Put libraries in $(OPENSCAD_PATH)"
	@for lib in $(LIB_URLS); do \
		echo "Cloning $$lib"; \
		name=$$(basename "$$lib" ".git"); \
		rm -rf "$(OPENSCAD_PATH)/$$name"; \
		git clone "$$lib" "$(OPENSCAD_PATH)/$$name"; \
	done

render:
	@echo "Building the project"
	mkdir -p "out"
	@for project in $(PROJECT_PATHS); do \
		echo "Processing $$project"; \
		openscad -o "out/$$project.stl" "src/$$project/index.scad"; \
	done

.PHONY: clean
clean:
	@echo "Cleaning the project"
	rm -rf "out"

