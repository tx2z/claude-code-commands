# CLAUDE.md - Claude Code Command Collection

This directory contains a collection of Claude Code command packages. Each subdirectory is an independent, self-contained command that can be installed separately.

## Directory Structure

```
claude-code/
├── README.md                           # Main documentation
├── CLAUDE.md                           # This file (context for Claude)
├── claude-code-security-scan/          # /security-scan command
├── claude-code-code-review/            # /code-review command
├── claude-code-refactor-scan/          # /refactor-scan command
├── claude-code-doc-gen/                # /doc-gen command
├── claude-code-api-validator/          # /api-validator command
├── claude-code-test-coverage-audit/    # /test-coverage-audit command
├── claude-code-performance-scan/       # /performance-scan command
├── claude-code-release-notes/          # /release-notes command
└── claude-code-kb-generator/           # /init-kb and /update-kb commands
```

## Command Package Structure

Each command package follows a consistent structure:

```
claude-code-[command-name]/
├── README.md                   # Package documentation
├── LICENSE                     # MIT License
├── .gitignore
├── commands/
│   └── [command-name].md      # Main command definition (orchestrator)
└── [domain]/
    ├── agents/                 # Specialized scanning agents
    │   ├── agent-1.md
    │   ├── agent-2.md
    │   └── ...
    └── templates/              # Report templates
        └── report-template.md
```

## Key Conventions

### Command Definition (YAML Frontmatter)
```yaml
---
description: Short description of command
allowed-tools: Bash(...), Read, Glob, Grep, Edit, Write, Task, AskUserQuestion, WebSearch
argument-hint: [scope options]
---
```

### Agent Definition
```yaml
---
description: "[Internal] [Domain] agent - use /[command] instead"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, WebSearch
---
```

### Finding Output Format
All agents use a standardized output format:
```
FINDING: [CATEGORY-ID] Title
SEVERITY: Critical|High|Medium|Low
FILE: path/to/file.ts:lineNumber
DESCRIPTION: Detailed explanation
CODE:
```language
code snippet
```
REMEDIATION: Step-by-step fix
```

## Working with Commands

### Creating a New Command
1. Use `claude-code-security-scan` as the reference implementation
2. Follow the folder structure pattern
3. Create agents with `disable-model-invocation: true`
4. Include comprehensive search patterns (Glob/Grep)
5. Add severity classifications
6. Create report templates with mustache-style variables

### Modifying Existing Commands
1. Each command is in its own Git repository
2. Make changes in the respective subdirectory
3. Commit and push to GitHub independently

### Testing Commands
Commands can be tested by:
1. Copying the command folder to a test project's `.claude/` directory
2. Running the command with different modes
3. Verifying the generated reports

## GitHub Repositories

| Command | Repository |
|---------|------------|
| security-scan | https://github.com/tx2z/claude-code-security-scan |
| code-review | https://github.com/tx2z/claude-code-code-review |
| refactor-scan | https://github.com/tx2z/claude-code-refactor-scan |
| doc-gen | https://github.com/tx2z/claude-code-doc-gen |
| api-validator | https://github.com/tx2z/claude-code-api-validator |
| test-coverage-audit | https://github.com/tx2z/claude-code-test-coverage-audit |
| performance-scan | https://github.com/tx2z/claude-code-performance-scan |
| release-notes | https://github.com/tx2z/claude-code-release-notes |
| kb-generator | https://github.com/tx2z/claude-code-kb-generator |

## Tech Stack Coverage

All commands include patterns for:
- TypeScript/JavaScript (React, Node.js, Next.js, Express, Vue, Angular)
- Python (Django, FastAPI, Flask)
- PHP (Laravel, Symfony)
- .NET/C# (ASP.NET Core, Entity Framework)
- Go (Gin, Echo, Chi)
- Java (Spring Boot)
- Rust

## Notes for Claude

When working in this repository:
1. Each subdirectory is a separate Git repository - don't mix changes across packages
2. Follow the established patterns from `claude-code-security-scan`
3. Agents should have read-only tools; commands can have write tools
4. Use WebSearch in agents to look up current best practices
5. Always include multi-language support in detection patterns
6. Generate timestamped reports to `[command]-reports/` directories
7. **Always use `gh` (GitHub CLI) for all git operations** - use `gh repo sync`, `gh pr create`, etc. instead of raw git commands for push/pull/PR operations
