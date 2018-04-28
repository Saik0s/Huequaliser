.PHONY: all
all: generate

.PHONY: setup
setup:
	Scripts/setup
	xcodegen

.PHONY: generate
generate:
	xcodegen

.PHONY: bootstrap
bootstrap:
	Scripts/bootstrap

.PHONY: changelog
changelog:
	Scripts/changelog

.PHONY: carthage
carthage:
	Scripts/cart

.PHONY: formatter
formatter:
	Scripts/formatter
