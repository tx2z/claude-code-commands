# Claude Code Command Collection

A collection of powerful, specialized commands for [Claude Code](https://claude.ai/code) - Anthropic's official CLI for Claude.

Each command is a self-contained package that can be installed independently or all together using the installer.

## Quick Start

### Option 1: Clone Everything (Recommended)

```bash
# Clone with all commands
git clone --recursive https://github.com/tx2z/claude-code-commands.git

# Install commands to your project using the interactive installer
cd claude-code-commands
./install.sh --interactive

# Or install all commands at once
./install.sh --all -d /path/to/your-project
```

### Option 2: Install Specific Commands

```bash
# Clone the collection
git clone --recursive https://github.com/tx2z/claude-code-commands.git
cd claude-code-commands

# Install only what you need
./install.sh security-scan code-review -d /path/to/your-project
```

### Option 3: Clone Individual Commands

Each command has its own repository for standalone installation:

```bash
cd your-project
mkdir -p .claude/commands
git clone https://github.com/tx2z/claude-code-security-scan .claude/commands/security-scan
```

## Installer Usage

```bash
./install.sh [OPTIONS] [COMMAND...]

Options:
  -h, --help          Show help message
  -l, --list          List available commands
  -a, --all           Install all commands
  -i, --interactive   Interactive mode (select commands)
  -d, --directory     Target directory (default: current directory)

Examples:
  ./install.sh --interactive                    # Interactive selection
  ./install.sh --all                            # Install all to current dir
  ./install.sh --all -d ~/projects/myapp        # Install all to specific dir
  ./install.sh security-scan code-review        # Install specific commands
```

## Personalizing Commands (Optional)

After installation, the script creates a `.claude/PERSONALIZE.md` file with prompts you can run in Claude Code to optimize each command for your specific tech stack.

**Why personalize?**
- Removes irrelevant patterns (e.g., Django checks from a Node.js project)
- Adds project-specific conventions and patterns
- Improves accuracy and reduces scan time

**How to personalize:**
1. Open your project in Claude Code
2. Copy a prompt from `.claude/PERSONALIZE.md`
3. Paste it into Claude Code and run it
4. Review the proposed changes before applying

This is optional but recommended for best results.

## Available Commands

| Command | Description | Repository |
|---------|-------------|------------|
| `/security-scan` | OWASP security vulnerability scanner | [claude-code-security-scan](https://github.com/tx2z/claude-code-security-scan) |
| `/code-review` | Multi-perspective code reviews (Peer, Architect, Security, Product, CTO) | [claude-code-code-review](https://github.com/tx2z/claude-code-code-review) |
| `/refactor-scan` | Identify refactoring opportunities and technical debt | [claude-code-refactor-scan](https://github.com/tx2z/claude-code-refactor-scan) |
| `/doc-gen` | Generate documentation (README, API docs, architecture) | [claude-code-doc-gen](https://github.com/tx2z/claude-code-doc-gen) |
| `/api-validator` | Validate APIs against REST/GraphQL best practices | [claude-code-api-validator](https://github.com/tx2z/claude-code-api-validator) |
| `/test-coverage-audit` | Audit test quality beyond line coverage | [claude-code-test-coverage-audit](https://github.com/tx2z/claude-code-test-coverage-audit) |
| `/performance-scan` | Detect performance issues and optimization opportunities | [claude-code-performance-scan](https://github.com/tx2z/claude-code-performance-scan) |
| `/release-notes` | Generate release notes in multiple formats | [claude-code-release-notes](https://github.com/tx2z/claude-code-release-notes) |
| `/init-kb` `/update-kb` | Generate and maintain project knowledge base | [claude-code-kb-generator](https://github.com/tx2z/claude-code-kb-generator) |

## Command Overview

### /security-scan
Comprehensive OWASP security scanning with 11 specialized agents covering:
- OWASP Top 10 (Web)
- OWASP API Security Top 10
- Secret detection
- License compliance
- CVE vulnerability checking
- Docker security

**Modes:** `full`, `quick`, `api-only`, `web-only`, `secrets-only`, `category:A01-A10`, `category:API1-API10`

---

### /code-review
Multi-perspective code reviews using 5 specialized agents:
- **PEER01** - Peer Developer (readability, DRY, SOLID)
- **ARCH01** - Software Architect (patterns, coupling, scalability)
- **SEC01** - Security Reviewer (OWASP, vulnerabilities)
- **PROD01** - Product Perspective (UX, a11y, i18n)
- **CTO01** - CTO/Strategic (maintainability, compliance, cost)

**Modes:** `full`, `quick`, `peer`, `arch`, `security`, `product`, `cto`, `pr`

---

### /refactor-scan
Identify refactoring opportunities with 6 agents:
- **REF01** - Code Complexity (cyclomatic, nesting, method length)
- **REF02** - Duplication (copy-paste, DRY violations)
- **REF03** - Design Patterns (factory, strategy, observer opportunities)
- **REF04** - Code Smells (Martin Fowler's catalog)
- **REF05** - Modernization (outdated patterns, upgrades)
- **REF06** - Architecture Debt (circular deps, god objects)

**Modes:** `full`, `quick`, `complexity`, `duplication`, `patterns`, `modernize`, `debt`, `extract`

---

### /doc-gen
Generate comprehensive documentation with 6 agents:
- **DOC01** - README Generator
- **DOC02** - API Documentation (REST/GraphQL)
- **DOC03** - Architecture Documentation (diagrams, ADRs)
- **DOC04** - Setup Guide
- **DOC05** - Inline Comments (JSDoc, docstrings)
- **DOC06** - Component Documentation (React/Vue)

**Modes:** `full`, `readme`, `api`, `arch`, `setup`, `contrib`, `changelog`, `inline`, `storybook`

---

### /api-validator
Validate APIs against best practices with 7 agents:
- **API01** - REST Best Practices
- **API02** - GraphQL Best Practices
- **API03** - OpenAPI/Swagger Spec
- **API04** - API Security
- **API05** - API Performance
- **API06** - API Consistency
- **API07** - API Versioning

**Modes:** `full`, `rest`, `graphql`, `openapi`, `security`, `performance`, `versioning`, `consistency`

---

### /test-coverage-audit
Audit test quality with 6 agents:
- **TEST01** - Coverage Gaps
- **TEST02** - Test Quality (AAA pattern, isolation)
- **TEST03** - Mutation Testing Analysis
- **TEST04** - Flaky Tests Detection
- **TEST05** - Test Performance
- **TEST06** - Test Organization

**Modes:** `full`, `gaps`, `quality`, `unit`, `integration`, `e2e`, `mutation`, `flaky`, `performance`

---

### /performance-scan
Detect performance issues with 7 agents:
- **PERF01** - Algorithm Complexity
- **PERF02** - Memory Issues
- **PERF03** - Database Performance
- **PERF04** - Frontend Performance
- **PERF05** - Network Optimization
- **PERF06** - Async Operations
- **PERF07** - Build/Bundle Analysis

**Modes:** `full`, `quick`, `frontend`, `backend`, `database`, `memory`, `bundle`, `runtime`, `network`

---

### /release-notes
Generate release notes in multiple formats with 5 agents:
- **REL01** - Technical Notes (GitHub releases, changelogs)
- **REL02** - Marketing Notes (App Store, user-friendly)
- **REL03** - Internal Notes (team communication)
- **REL04** - Security Notes (CVE disclosures)
- **REL05** - Changelog Maintenance

**Modes:** `technical`, `marketing`, `internal`, `security`, `full`

**Arguments:** `--from=<tag>`, `--to=<tag>`, `--version=<semver>`, `--date=<date>`

---

### /init-kb & /update-kb
Generate and maintain a comprehensive knowledge base for your project:
- Automated CLAUDE.md generation
- Project structure analysis
- Dependency documentation
- Architecture insights

**Commands:** `/init-kb` (initial generation), `/update-kb` (incremental updates)

---

## Tech Stack Support

All commands support multiple programming languages and frameworks:

- **TypeScript/JavaScript** - React, Node.js, Next.js, Express, Vue, Angular
- **Python** - Django, FastAPI, Flask
- **PHP** - Laravel, Symfony
- **.NET/C#** - ASP.NET Core, Entity Framework
- **Go** - Gin, Echo, Chi
- **Java** - Spring Boot
- **Rust**

## Updating Commands

To update all commands to their latest versions:

```bash
cd claude-code-commands
git submodule update --remote --merge
```

To update a specific command:

```bash
cd claude-code-commands/claude-code-security-scan
git pull origin main
```

## Contributing

Each command is maintained in its own repository. Please submit issues and pull requests to the specific command repository.

## License

All commands are released under the MIT License.

## Author

Created by [tx2z](https://github.com/tx2z)
