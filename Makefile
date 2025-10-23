# Makefile for MIT Discord Bot
# Usage:
#   make install     # create venv + install deps
#   make run         # run the bot
#   make freeze      # lock deps to requirements.txt
#   make doctor      # print useful versions
#   make clean       # remove venv and caches
#
# Customize:
#   make run MAIN=your_script.py
#   make install REQ=dev-requirements.txt

SHELL := /bin/bash
.ONESHELL:

PY      ?= python3
VENV    ?= .venv
PIP     := $(VENV)/bin/pip
PYTHON  := $(VENV)/bin/python
REQ     ?= requirements.txt
MAIN    ?= discord_bot.py

.DEFAULT_GOAL := help

.PHONY: help venv install run freeze clean doctor test-key

## help: Show this help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_.-]+:.*##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

## venv: Create virtualenv (if missing)
venv:
	@if [ ! -d "$(VENV)" ]; then \
		$(PY) -m venv $(VENV); \
		echo "✅ Created venv at $(VENV)"; \
	else \
		echo "ℹ️  venv exists: $(VENV)"; \
	fi

## install: Upgrade pip/wheel and install deps from $(REQ)
install: venv
	$(PIP) install --upgrade pip wheel
	@if [ -f "$(REQ)" ]; then \
		echo "📦 Installing from $(REQ)"; \
		$(PIP) install -r $(REQ); \
	else \
		echo "⚠️  No $(REQ) found; skipping dependency install."; \
	fi

## run: Run the bot (loads .env via python-dotenv in your code)
run: install
	$(PYTHON) $(MAIN)

## freeze: Lock current venv packages to $(REQ)
freeze:
	$(PIP) freeze | sed '/^\-e /d' > $(REQ)
	@echo "📌 Wrote locked deps to $(REQ)"

## test-key: Check .env has OPENAI_API_KEY and TOKEN
test-key:
	@if [ ! -f ".env" ]; then echo "❌ .env not found"; exit 1; fi
	@if ! grep -q '^OPENAI_API_KEY=' .env; then echo "❌ OPENAI_API_KEY missing in .env"; exit 1; fi
	@if ! grep -q '^TOKEN=' .env; then echo "❌ TOKEN missing in .env"; exit 1; fi
	@echo "✅ .env looks good."

## clean: Remove venv and Python caches
clean:
	rm -rf $(VENV) **/__pycache__ .pytest_cache
	@echo "🧹 Cleaned."

## doctor: Print versions to help debug
doctor: venv
	@echo "Python: $$($(PY) --version)"
	@echo "Pip:    $$($(PIP) --version)"
	@echo "discord.py: $$($(PIP) show discord.py 2>/dev/null | awk -F': ' '/Version/ {print $$2}')"
	@echo "openai:     $$($(PIP) show openai 2>/dev/null | awk -F': ' '/Version/ {print $$2}')"
