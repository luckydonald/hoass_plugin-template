# Is this a frontend or backend project, or both?
# Set explicit (e.g. by `make lint FRONTEND=1 BACKEND=1`), or detect the
# presence of the directories. FRONTEND_DIR picks the concrete frontend folder.
FRONTEND ?= $(shell if [ -d frontend ] || [ -d frontend_vue ]; then echo 1; else echo 0; fi)
BACKEND  ?= $(if $(wildcard custom_components),1,0)

# Prefer frontend/ then frontend_vue/
FRONTEND_DIR := $(shell if [ -d frontend ]; then echo frontend; elif [ -d frontend_vue ]; then echo frontend_vue; else echo ''; fi)

.PHONY: release lint format build setup help commit init fix-commits commit-fix rebase-template template-rebase

help:
	@echo "Plugin Template - Development Commands"
	@echo ""
	@echo "Usage: make <target> [FRONTEND=1] [BACKEND=1]"
	@echo ""
	@echo "Targets:"
	@echo "  init           - Initialize/update plugin from template (runs scripts/init.sh)"
	@echo "  setup          - Set up the full development environment (frontend + backend)"
	@echo "  setup-ts       - Set up frontend development environment (TypeScript)"
	@echo "  setup-py       - Set up backend  development environment (Python)"
	@echo "  test           - Run all tests (frontend + backend)"
	@echo "  test-ts        - Run frontend tests"
	@echo "  test-py        - Run backend tests"
	@echo "  test-coverage  - Run tests with coverage report"
	@echo "  lint           - Run all linters (frontend + backend)"
	@echo "  lint-ts        - Lint/type‑check TypeScript only"
	@echo "  lint-py        - Lint/format Python only"
	@echo "  format         - Format all code (frontend + backend)"
	@echo "  format-ts      - Format TypeScript only"
	@echo "  format-py      - Format Python only"
	@echo "  build          - Build what needs to be build"
	@echo "  build-ts       - Build frontend"
	@echo "  commit         - Commit changes with structured messages"
	@echo "  fix-commits    - Fix AI commit messages (update totals and edit messages)"
	@echo "  commit-fix     - Alias for 'fix-commits' above"
	@echo "  release        - Bump version, lint, build, and push release"
	@echo "  rebase-template- Update plugin from template repository"
	@echo "  template-rebase- Alias for 'rebase-template' above"
	@echo "  help           - Show this help message"

init:
	@chmod +x scripts/init.sh
	@./scripts/init.sh

fix-commits:
	@chmod +x scripts/fix-commits.sh
	@./scripts/fix-commits.sh

commit-fix: fix-commits

setup: setup-backend setup-frontend

setup-backend:
ifeq ($(BACKEND),1)
	@echo "Setting up Python development environment..."
	uv sync
else
	@echo "No Python sources detected – skipping backend setup."
endif

setup-frontend:
ifeq ($(FRONTEND),1)
	@echo "Setting up frontend development environment..."
	@if [ -n "$(FRONTEND_DIR)" ]; then \
		cd $(FRONTEND_DIR) && if [ -f package.json ]; then \
			if command -v npm >/dev/null 2>&1; then npm install; elif command -v yarn >/dev/null 2>&1; then yarn install; else echo "No npm/yarn found"; fi; \
		fi; \
	fi
else
	@echo "No frontend sources detected – skipping frontend setup."
endif

test: test-py test-ts

test-py:
ifeq ($(BACKEND),1)
	@echo "Running Python tests..."
	uv run pytest tests/
else
	@echo "No Python sources detected – skipping backend tests."
endif

test-ts:
ifeq ($(FRONTEND),1)
	@echo "Running frontend tests..."
	@if [ -n "$(FRONTEND_DIR)" ]; then \
		cd $(FRONTEND_DIR) && if [ -f package.json ]; then \
			if command -v npm >/dev/null 2>&1; then npm run test; elif command -v yarn >/dev/null 2>&1; then yarn test; else echo "No npm/yarn found"; fi; \
		fi; \
	fi
else
	@echo "No frontend sources detected – skipping frontend tests."
endif

test-coverage: test-coverage-py test-coverage-ts

test-coverage-py:
ifeq ($(BACKEND),1)
	@echo "Running Python tests with coverage..."
	uv run pytest tests/ --cov --cov-report=html --cov-report=term
	@echo "Python coverage report generated in htmlcov/"
else
	@echo "No Python sources detected – skipping backend coverage."
endif

test-coverage-ts:
ifeq ($(FRONTEND),1)
	@echo "Running frontend tests with coverage..."
	cd frontend && yarn test:coverage
	@echo "Frontend coverage report generated in frontend/coverage/"
else
	@echo "No frontend sources detected – skipping frontend coverage."
endif

lint: lint-py lint-ts

lint-py:
ifeq ($(BACKEND),1)
	@echo "Linting Python..."
	uv run ruff check custom_components/
	uv run ruff format --check custom_components/
else
	@echo "No Python sources detected – skipping backend lint."
endif

lint-ts:
ifeq ($(FRONTEND),1)
	@echo "Type checking / linting frontend..."
	@if [ -n "$(FRONTEND_DIR)" ]; then \
		cd $(FRONTEND_DIR) && if [ -f package.json ]; then \
			if command -v npm >/dev/null 2>&1; then npm run lint || npm run type-check || true; elif command -v yarn >/dev/null 2>&1; then yarn lint || yarn type-check || true; else echo "No npm/yarn found"; fi; \
		fi; \
	fi
else
	@echo "No frontend sources detected – skipping TypeScript lint."
endif

format: format-py format-ts

format-py:
ifeq ($(BACKEND),1)
	@echo "Formatting Python..."
	uv run ruff check --fix custom_components/ || true
	uv run ruff format custom_components/
	uv run ruff check --fix custom_components/
else
	@echo "No Python sources detected – skipping backend format."
endif

format-ts:
ifeq ($(FRONTEND),1)
	@echo "Formatting TypeScript..."
	@if [ -n "$(FRONTEND_DIR)" ]; then \
		cd $(FRONTEND_DIR) && if [ -f package.json ]; then \
			if command -v npm >/dev/null 2>&1; then npm run format; elif command -v yarn >/dev/null 2>&1; then yarn format; else echo "No npm/yarn found"; fi; \
		fi; \
	fi
else
	@echo "No frontend sources detected – skipping TypeScript format."
endif

build: build-frontend

build-frontend:
ifeq ($(FRONTEND),1)
	@echo "Building frontend..."
	@if [ -n "$(FRONTEND_DIR)" ]; then \
		cd $(FRONTEND_DIR) && if [ -f package.json ]; then \
			if command -v npm >/dev/null 2>&1; then npm install --silent && npm run build; elif command -v yarn >/dev/null 2>&1; then yarn install --silent && yarn build; else echo "No npm/yarn found"; fi; \
		fi; \
	fi
else
	@echo "No frontend sources detected – skipping build."
endif

commit:
	@chmod +x scripts/commit.sh
	@./scripts/commit.sh

release:
	@chmod +x scripts/release.sh
	@./scripts/release.sh

rebase-template:
	@chmod +x scripts/update-from-template.sh
	@./scripts/update-from-template.sh

template-rebase: rebase-template

%:
	@echo "Unknown target '$@'. Showing help:"
	@$(MAKE) help
