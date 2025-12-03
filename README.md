# Slack Thread Summarizer

A Slack thread summarizer that uses Claude AI to generate AI-powered summaries of Slack conversations.

## Quick Start

### Prerequisites

1. Python 3.x with virtualenv support
2. Slack bot token and user token

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd claude-summarizer
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

   The installer will:
   - Prompt you for a virtualenv directory (defaults to `~/.virtualenvs` if you press Enter)
   - Create a virtualenv named `claude-summarizer` in that directory
   - Install all required dependencies from `requirements.txt`
   - Create the `fetch-conversation` executable at `~/.local/bin/fetch-conversation`

3. Create a `.env` file in the project directory with your Slack credentials:
   ```
   SLACK_TOKEN=xoxb-your-bot-token-here
   USER_TOKEN=xoxp-your-user-token-here
   ```

4. Ensure `~/.local/bin` is in your PATH (add to your `~/.bashrc` or `~/.zshrc`):
   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

### Usage

#### Command Line
After installation, you can use the `fetch-conversation` command from anywhere:

```bash
fetch-conversation "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"
```

#### With Claude Code
If you're using [Claude Code](https://claude.com/claude-code), you can use the `/slack_thread` slash command for an even better experience:

```
/slack_thread https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219
```

Claude will automatically fetch the conversation and provide a structured TL;DR summary including:
- Core problem/topic
- Resolution or action plan
- Components involved
- Issues to fix
- Relevant links

### Getting Slack Tokens

You'll need two types of tokens:

1. **Bot Token (SLACK_TOKEN)**: Create a Slack app and install it to your workspace
2. **User Token (USER_TOKEN)**: Generate a user token with appropriate scopes

Both tokens can be obtained from your Slack app configuration at https://api.slack.com/apps
