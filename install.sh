#!/bin/bash

# Claude Code Commands Installer
# This script helps you install Claude Code commands to your project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Command definitions (compatible with bash 3.x)
COMMAND_NAMES=(
    "security-scan"
    "code-review"
    "refactor-scan"
    "doc-gen"
    "api-validator"
    "test-coverage-audit"
    "performance-scan"
    "release-notes"
    "kb-generator"
)

COMMAND_FOLDERS=(
    "claude-code-security-scan"
    "claude-code-code-review"
    "claude-code-refactor-scan"
    "claude-code-doc-gen"
    "claude-code-api-validator"
    "claude-code-test-coverage-audit"
    "claude-code-performance-scan"
    "claude-code-release-notes"
    "claude-code-kb-generator"
)

COMMAND_DESCS=(
    "Security vulnerability scanning for your codebase"
    "Comprehensive code quality review"
    "Identify refactoring opportunities"
    "Generate documentation for your code"
    "Validate API endpoints and contracts"
    "Audit test coverage and quality"
    "Identify performance issues"
    "Generate release notes from commits"
    "Generate knowledge base (init-kb, update-kb)"
)

# GitHub base URL for README links
GITHUB_BASE="https://github.com/tx2z"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_folder_for_command() {
    local cmd=$1
    for i in "${!COMMAND_NAMES[@]}"; do
        if [[ "${COMMAND_NAMES[$i]}" == "$cmd" ]]; then
            echo "${COMMAND_FOLDERS[$i]}"
            return
        fi
    done
    echo ""
}

get_desc_for_command() {
    local cmd=$1
    for i in "${!COMMAND_NAMES[@]}"; do
        if [[ "${COMMAND_NAMES[$i]}" == "$cmd" ]]; then
            echo "${COMMAND_DESCS[$i]}"
            return
        fi
    done
    echo ""
}

# Extract personalization prompt from a repo's README
extract_prompt_from_readme() {
    local readme_file=$1

    if [[ ! -f "$readme_file" ]]; then
        echo ""
        return
    fi

    # Extract content between "Run this prompt in Claude Code:" and the next "```" after the code block
    awk '
        /Run this prompt in Claude Code:/ { found=1; next }
        found && /^```$/ && !in_block { in_block=1; next }
        found && /^```$/ && in_block { exit }
        found && in_block { print }
    ' "$readme_file"
}

# Track installed commands for personalization
INSTALLED_COMMANDS=()

show_personalization_prompts() {
    local target_dir=$1
    local prompt_file="$target_dir/.claude/PERSONALIZE.md"

    if [[ ${#INSTALLED_COMMANDS[@]} -eq 0 ]]; then
        return
    fi

    # Show installed commands and how to use them
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}  Ready to use!${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Run these commands in Claude Code:"
    echo ""

    for cmd in "${INSTALLED_COMMANDS[@]}"; do
        echo -e "  ${GREEN}/$cmd${NC}"
    done

    # Create the prompts file silently
    cat > "$prompt_file" << 'HEADER'
# Personalization Prompts

Run these prompts in Claude Code to optimize each command for your specific codebase.
This is **optional** but recommended - it makes the commands more accurate by removing
irrelevant patterns and adding project-specific ones.

---

HEADER

    for cmd in "${INSTALLED_COMMANDS[@]}"; do
        local folder=$(get_folder_for_command "$cmd")
        local readme_file="$SCRIPT_DIR/$folder/README.md"
        local github_url="$GITHUB_BASE/$folder#optional-optimize-for-your-tech-stack"

        # Try to extract prompt from README
        local prompt=$(extract_prompt_from_readme "$readme_file")

        if [[ -n "$prompt" ]]; then
            # Add extracted prompt to file
            cat >> "$prompt_file" << EOF
## /$cmd

\`\`\`
$prompt
\`\`\`

[View in README]($github_url)

---

EOF
        else
            # Fallback: link to README
            cat >> "$prompt_file" << EOF
## /$cmd

See the personalization section in the README:
$github_url

---

EOF
        fi
    done

    # Show optional personalization info
    echo ""
    echo -e "${YELLOW}Optional:${NC} Personalize commands for your tech stack"
    echo -e "  See ${BOLD}$prompt_file${NC}"
    echo ""
}

print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}        ${BOLD}Claude Code Commands Installer${NC}                       ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_usage() {
    echo -e "${BOLD}Usage:${NC}"
    echo "  ./install.sh [OPTIONS] [COMMAND...]"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo "  -h, --help          Show this help message"
    echo "  -l, --list          List available commands"
    echo "  -a, --all           Install all commands"
    echo "  -i, --interactive   Interactive mode (select commands)"
    echo "  -d, --directory     Target directory (default: current directory)"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  ./install.sh --interactive              # Interactive selection"
    echo "  ./install.sh --all                      # Install all commands"
    echo "  ./install.sh security-scan code-review  # Install specific commands"
    echo "  ./install.sh -d /path/to/project --all  # Install to specific directory"
    echo ""
}

list_commands() {
    echo -e "${BOLD}Available Commands:${NC}"
    echo ""
    for i in "${!COMMAND_NAMES[@]}"; do
        echo -e "  ${GREEN}/${COMMAND_NAMES[$i]}${NC}"
        echo -e "    ${COMMAND_DESCS[$i]}"
        echo ""
    done
}

install_command() {
    local cmd=$1
    local target_dir=$2

    local folder=$(get_folder_for_command "$cmd")
    if [[ -z "$folder" ]]; then
        echo -e "  ${RED}✗${NC} Unknown command: $cmd"
        return 1
    fi

    local source_dir="$SCRIPT_DIR/$folder"
    local dest_dir="$target_dir/.claude/commands"

    if [[ ! -d "$source_dir" ]]; then
        echo -e "${RED}Error: Command folder not found: $source_dir${NC}"
        echo -e "${YELLOW}Try running: git submodule update --init${NC}"
        return 1
    fi

    # Create destination directory
    mkdir -p "$dest_dir"

    # Copy command files
    if [[ -d "$source_dir/commands" ]]; then
        cp -r "$source_dir/commands/"* "$dest_dir/" 2>/dev/null || true
    fi

    # Copy domain folders (security, review, etc.)
    for domain_dir in "$source_dir"/*/; do
        if [[ -d "$domain_dir" ]]; then
            domain_name=$(basename "$domain_dir")
            if [[ "$domain_name" != "commands" ]]; then
                cp -r "$domain_dir" "$dest_dir/"
            fi
        fi
    done

    echo -e "  ${GREEN}✓${NC} Installed ${BOLD}/$cmd${NC}"
    INSTALLED_COMMANDS+=("$cmd")
}

# Pure bash interactive multi-select menu
interactive_select() {
    local target_dir=$1
    local count=${#COMMAND_NAMES[@]}

    # Selection state (0 = not selected, 1 = selected)
    local selected=()
    for ((i=0; i<count; i++)); do
        selected[$i]=0
    done

    local cursor=0
    local menu_lines=$((count + 4))

    # Hide cursor and save terminal state
    printf '\e[?25l'
    stty -echo 2>/dev/null

    # Cleanup on exit
    cleanup() {
        printf '\e[?25h'
        stty echo 2>/dev/null
    }
    trap cleanup EXIT INT TERM

    # Draw the menu
    draw_menu() {
        # Move up to redraw (except first time)
        if [[ $1 == "redraw" ]]; then
            printf '\e[%dA' "$menu_lines"
        fi

        echo -e "${BOLD}Select commands to install:${NC}"
        echo -e "${YELLOW}↑/↓ Navigate  Space Toggle  a All  n None  Enter Confirm  q Cancel${NC}"
        echo ""

        for i in "${!COMMAND_NAMES[@]}"; do
            local prefix="  "
            local checkbox="○"
            local line_color=""
            local reset="${NC}"

            # Highlight current row
            if [[ $i -eq $cursor ]]; then
                prefix="▸ "
                line_color="${CYAN}"
            fi

            # Show selection state
            if [[ ${selected[$i]} -eq 1 ]]; then
                checkbox="${GREEN}●${NC}${line_color}"
            fi

            printf '\e[K'  # Clear line
            echo -e "${line_color}${prefix}${checkbox} /${COMMAND_NAMES[$i]}${reset} - ${COMMAND_DESCS[$i]}"
        done

        # Status line
        printf '\e[K'
        local sel_count=0
        for s in "${selected[@]}"; do
            ((sel_count += s))
        done

        if [[ $sel_count -gt 0 ]]; then
            echo -e "${GREEN}$sel_count selected${NC} - Press Enter to install"
        else
            echo -e "${YELLOW}None selected${NC} - Use Space to select, a for all"
        fi
    }

    # Initial draw
    draw_menu "first"

    # Read input loop
    while true; do
        # Read a single character
        IFS= read -rsn1 key

        # Handle escape sequences (arrow keys)
        if [[ $key == $'\e' ]]; then
            read -rsn1 key2
            read -rsn1 key3
            key="${key}${key2}${key3}"
        fi

        case "$key" in
            $'\e[A'|k)  # Up arrow or k
                ((cursor > 0)) && ((cursor--))
                ;;
            $'\e[B'|j)  # Down arrow or j
                ((cursor < count - 1)) && ((cursor++))
                ;;
            ' ')  # Space - toggle selection
                if [[ ${selected[$cursor]} -eq 1 ]]; then
                    selected[$cursor]=0
                else
                    selected[$cursor]=1
                fi
                ;;
            ''|$'\n')  # Enter - confirm
                break
                ;;
            a|A)  # Select all
                for ((i=0; i<count; i++)); do
                    selected[$i]=1
                done
                ;;
            n|N)  # Select none
                for ((i=0; i<count; i++)); do
                    selected[$i]=0
                done
                ;;
            q|Q)  # Quit
                cleanup
                echo ""
                echo -e "${YELLOW}Cancelled.${NC}"
                exit 0
                ;;
        esac

        # Redraw menu
        draw_menu "redraw"
    done

    # Restore terminal
    cleanup

    echo ""

    # Install selected commands
    local installed=0

    for i in "${!COMMAND_NAMES[@]}"; do
        if [[ ${selected[$i]} -eq 1 ]]; then
            install_command "${COMMAND_NAMES[$i]}" "$target_dir"
            ((installed++))
        fi
    done

    if [[ $installed -eq 0 ]]; then
        echo -e "${YELLOW}No commands installed.${NC}"
    else
        echo ""
        echo -e "${GREEN}Successfully installed $installed command(s) to:${NC}"
        echo -e "  ${BOLD}$target_dir/.claude/commands/${NC}"
        show_personalization_prompts "$target_dir"
    fi
}

interactive_mode() {
    local target_dir=$1
    interactive_select "$target_dir"
}

# Main
main() {
    local target_dir="$(pwd)"
    local mode=""
    local commands_to_install=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_header
                print_usage
                exit 0
                ;;
            -l|--list)
                print_header
                list_commands
                exit 0
                ;;
            -a|--all)
                mode="all"
                shift
                ;;
            -i|--interactive)
                mode="interactive"
                shift
                ;;
            -d|--directory)
                target_dir="$2"
                shift 2
                ;;
            -*)
                echo -e "${RED}Unknown option: $1${NC}"
                print_usage
                exit 1
                ;;
            *)
                commands_to_install+=("$1")
                shift
                ;;
        esac
    done

    print_header

    # Validate target directory
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${RED}Error: Target directory does not exist: $target_dir${NC}"
        exit 1
    fi

    # Determine mode
    if [[ ${#commands_to_install[@]} -gt 0 ]]; then
        # Install specific commands
        echo -e "${BOLD}Installing commands to:${NC} $target_dir"
        echo ""

        for cmd in "${commands_to_install[@]}"; do
            install_command "$cmd" "$target_dir"
        done

        echo ""
        echo -e "${GREEN}Done!${NC}"
        show_personalization_prompts "$target_dir"

    elif [[ "$mode" == "all" ]]; then
        # Install all commands
        echo -e "${BOLD}Installing all commands to:${NC} $target_dir"
        echo ""

        for cmd in "${COMMAND_NAMES[@]}"; do
            install_command "$cmd" "$target_dir"
        done

        echo ""
        echo -e "${GREEN}Successfully installed all commands!${NC}"
        show_personalization_prompts "$target_dir"

    elif [[ "$mode" == "interactive" ]]; then
        interactive_mode "$target_dir"

    else
        # No mode specified, show help
        echo -e "${YELLOW}No commands specified. Use --interactive for selection or --help for usage.${NC}"
        echo ""
        print_usage
        exit 1
    fi
}

main "$@"
