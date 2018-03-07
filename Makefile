.PHONY: all
all:
	bundle exec xcake make

.PHONY: setup
setup:
	Scripts/setup

.PHONY: bootstrap
bootstrap:
	Scripts/bootstrap

.PHONY: changelog
changelog:
	Scripts/changelog

.PHONY: dependencies
dependencies:
	Scripts/dependencies

.PHONY: formatter
formatter:
	Scripts/formatter
