# Slack Thread Summarizer

A Slack thread summarizer that uses a Claude AI to generate AI-powered summaries of Slack conversations.

## Quick Start

### Prerequisites

1. Python 3.x with virtualenv support
2. Slack bot token and user token

### Setup

1. Create and activate a virtual environment:
   ```bash
   python3 -m venv ~/.virtualenvs/summarizer
   ~/.virtualenvs/summarizer/bin/pip install -r requirements.txt
   ```

2. Create a `.env` file with your Slack credentials:
   ```
   SLACK_TOKEN=xoxb-your-bot-token-here
   USER_TOKEN=xoxp-your-user-token-here
