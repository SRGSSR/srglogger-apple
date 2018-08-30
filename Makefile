#!/usr/bin/xcrun make -f

.PHONY: all
all:
	@echo "Building the project..."
	@xcodebuild build
	@echo ""

.PHONY: package
package:
	@echo "Packaging binaries..."
	@mkdir -p archive
	@carthage build --no-skip-current
	@carthage archive --output archive
	@echo ""

.PHONY: clean
clean:
	@echo "Cleaning up build products..."
	@xcodebuild clean
	@rm -rf $(CARTHAGE_FOLDER)
	@echo ""

.PHONY: help
help:
	@echo "The following targets are available:"
	@echo "   all                         Build project dependencies and the project"
	@echo "   package                     Build and package the framework for attaching to github releases"
	@echo "   clean                       Clean the project and its dependencies"
	@echo "   help                        Display this message"
