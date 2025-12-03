#!/usr/bin/env bash

# This script installs the Slack Summarizer tool by:
# 1. Creating a virtualenv named "claude-summarizer" in a user-specified directory
# 2. Installing dependencies from requirements.txt
# 3. Creating a fetch-conversation executable at ~/.local/bin
#
# Example usage:
#   ./install.sh

set -e

# Get the absolute path to the project directory (where this script lives)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Project directory: $PROJECT_DIR"
echo ""

# Prompt for virtualenv base directory
read -p "Enter the directory where the virtualenv should be created [default: ~/.virtualenvs]: " VENV_BASE

# Default to ~/.virtualenvs if empty
if [ -z "$VENV_BASE" ]; then
    VENV_BASE="~/.virtualenvs"
fi

# Expand tilde to home directory
VENV_BASE="${VENV_BASE/#\~/$HOME}"

# Create the base directory if it doesn't exist
if [ ! -d "$VENV_BASE" ]; then
    echo "Creating directory: $VENV_BASE"
    mkdir -p "$VENV_BASE"
fi

VENV_PATH="$VENV_BASE/claude-summarizer"

# Create virtualenv if it doesn't exist
if [ ! -d "$VENV_PATH" ]; then
    echo "Creating virtualenv at: $VENV_PATH"
    python3 -m venv "$VENV_PATH"
    echo "Virtualenv created successfully."
else
    echo "Virtualenv already exists at: $VENV_PATH"
fi

# Install requirements
echo ""
echo "Installing dependencies from requirements.txt..."
"$VENV_PATH/bin/pip" install --upgrade pip
"$VENV_PATH/bin/pip" install -r "$PROJECT_DIR/requirements.txt"
echo "Dependencies installed successfully."

# Create ~/.local/bin if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Create the fetch-conversation executable
EXECUTABLE_PATH="$HOME/.local/bin/fetch-conversation"
echo ""
echo "Creating executable at: $EXECUTABLE_PATH"

cat > "$EXECUTABLE_PATH" << EOF
#!/usr/bin/env bash

# Slack Summarizer - Fetch Conversation Tool
# This script fetches and formats Slack conversations for summarization

VENV_PATH="$VENV_PATH"
PROJECT_DIR="$PROJECT_DIR"

# Check if virtualenv exists
if [ ! -f "\$VENV_PATH/bin/python" ]; then
    echo "ERROR: Virtualenv not found at \$VENV_PATH"
    echo "Please run the install script to create the virtualenv."
    exit 1
fi

# Change to project directory and run fetch_conversation.py
cd "\$PROJECT_DIR"
"\$VENV_PATH/bin/python" fetch_conversation.py "\$@"
EOF

# Make the executable runnable
chmod +x "$EXECUTABLE_PATH"

echo "Installation complete!"
echo ""
echo "The 'fetch-conversation' command is now available at: $EXECUTABLE_PATH"
echo ""
echo "To use it, ensure ~/.local/bin is in your PATH, or run:"
echo "  $EXECUTABLE_PATH <slack-url>"
echo ""
echo "You may need to add this to your ~/.bashrc or ~/.zshrc:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
