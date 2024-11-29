# Description: Makefile for the project
# Author: Patrick Tang

# Variables
OPENSCAD_PATH := $(PWD)/lib
PROJECT_PATHS := $(shell ls src)
LIB_URLS := "bosl;https://github.com/BelfrySCAD/BOSL2.git"

.PHONY: all
all: init render

# Targets
init:
	@echo "Put libraries in $(OPENSCAD_PATH)"
	@for lib in $(LIB_URLS); do \
		IFS=';' read -r name url <<< "$$lib"; \
		echo "Cloning $$url"; \
		rm -rf "$(OPENSCAD_PATH)/$$name"; \
		git clone "$$url" "$(OPENSCAD_PATH)/$$name"; \
		for project in $(PROJECT_PATHS); do \
			ln -s "$(OPENSCAD_PATH)/$$name" "src/$$project/$$name"; \
		done \
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

