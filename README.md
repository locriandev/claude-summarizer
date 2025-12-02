# Slack Thread Summarizer

A Slack thread summarizer that uses a Claude AI to generate AI-powered summaries of Slack conversations.

## Quick Start

### Prerequisites

1. Python 3.x with virtualenv support
2. Slack bot token and user token

### Setup

#### Option 1: Standalone Wrapper Script (Recommended)

For the most convenient experience, install the wrapper script that handles virtual environments automatically:

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd claude-summarizer
   ```

2. Create a virtual environment and install dependencies:
   ```bash
   python3 -m venv .venv
   .venv/bin/pip install -r requirements.txt
   ```

3. Set up your Slack credentials as environment variables (add to your shell profile):
   ```bash
   export SLACK_TOKEN=xoxb-your-bot-token-here
   export USER_TOKEN=xoxp-your-user-token-here
   ```

4. Edit the `slack-summarizer` script and update the `PROJECT_DIR` path:
   ```bash
   PROJECT_DIR="/path/to/your/claude-summarizer"
   ```

5. Install the wrapper script globally:
   ```bash
   chmod +x slack-summarizer
   sudo cp slack-summarizer /usr/local/bin/
   sudo chmod 755 /usr/local/bin/slack-summarizer
   ```

6. Now you can run from anywhere:
   ```bash
   slack-summarizer "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"
   ```

#### Option 2: Manual Virtual Environment

1. Create and activate a virtual environment:
   ```bash
   python3 -m venv ~/.virtualenvs/summarizer
   ~/.virtualenvs/summarizer/bin/pip install -r requirements.txt
   ```

2. Create a `.env` file with your Slack credentials:
   ```
   SLACK_TOKEN=xoxb-your-bot-token-here
   USER_TOKEN=xoxp-your-user-token-here
   ```

3. Run the script manually:
   ```bash
   ~/.virtualenvs/summarizer/bin/python fetch_conversation.py "https://slack-url..."
   ```

### Usage

#### With Wrapper Script (Option 1)
```bash
slack-summarizer "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"
```

#### Manual Execution (Option 2)
```bash
# Activate virtual environment first
source ~/.virtualenvs/summarizer/bin/activate
# Then run the script
python fetch_conversation.py "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"
```

### Getting Slack Tokens

You'll need two types of tokens:

1. **Bot Token (SLACK_TOKEN)**: Create a Slack app and install it to your workspace
2. **User Token (USER_TOKEN)**: Generate a user token with appropriate scopes

Both tokens can be obtained from your Slack app configuration at https://api.slack.com/apps
