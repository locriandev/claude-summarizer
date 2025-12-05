# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Slack Thread Summarizer that fetches Slack conversations and formats them for AI-powered summarization. The tool can be run as a standalone command-line script or integrated with Claude Code via a slash command.

## Architecture

### Core Components

- `fetch_conversation.py`: Main entry point script that orchestrates fetching and formatting Slack threads
- `summarizerlib/slack.py`: Contains `SlackThreadFinder` class with core Slack API integration logic
  - `fetch_thread_by_permalink()`: Parses Slack permalink URLs and fetches thread messages
  - `fetch_thread_conversation()`: Calls Slack API to retrieve thread replies
  - `format_thread_for_summary()`: Formats messages into readable conversation format
  - `get_username()`: Resolves user IDs to human-readable names (with caching)

### Authentication

The application requires two Slack tokens stored in a `.env` file:
- `SLACK_TOKEN`: Bot token (xoxb-...) for Slack API access
- `USER_TOKEN`: User token (xoxp-...) for searching messages

Tokens are loaded using `python-dotenv` in fetch_conversation.py:15-23.

### Permalink Parsing

Slack permalinks follow the format:
```
https://{workspace}.slack.com/archives/{CHANNEL_ID}/p{TIMESTAMP}
```

The timestamp in the URL (16 digits) is converted to Slack's internal format by inserting a decimal point after the 10th digit (e.g., `1234567890123456` becomes `1234567890.123456`). See summarizerlib/slack.py:87-95.

## Development Commands

### Setup
```bash
./install.sh
```
Creates virtualenv at a specified location (default: `~/.virtualenvs/claude-summarizer`), installs dependencies, and creates the `fetch-conversation` executable at `~/.local/bin/fetch-conversation`.

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Run Directly
```bash
python fetch_conversation.py "https://redhat-internal.slack.com/archives/{CHANNEL_ID}/p{TIMESTAMP}"
```

### Run via Installed Command
```bash
fetch-conversation "https://redhat-internal.slack.com/archives/{CHANNEL_ID}/p{TIMESTAMP}"
```

## Claude Code Integration

The `.claude/commands/slack_thread.md` slash command enables usage within Claude Code:
```
/slack_thread <slack-permalink>
```

This command calls the `fetch-conversation` executable and expects Claude to provide a structured summary including:
- Core problem/topic
- Resolution or action plan
- Components involved
- Issues to fix
- Relevant links
