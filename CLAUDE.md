# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Slack thread summarizer that uses a locally-hosted LLaMA model to generate summaries of Slack conversations. The application fetches Slack threads (either by permalink or by searching for specific labels), formats them, and sends them to a LLaMA inference server for summarization.

## Architecture

The codebase consists of three main components:

1. **FastAPI Application** (`app.py`): Exposes REST endpoints for summarization
   - `/summarize-url`: Summarizes a single Slack thread given its permalink
   - `/summarize-art-attention`: Summarizes all threads with `:art-attention:` label (excluding resolved ones)

2. **Slack Integration** (`summarizerlib/slack.py`): Handles Slack API interactions
   - `SlackThreadFinder`: Searches for messages, fetches threads, resolves user IDs to names
   - Uses both bot token (`SLACK_TOKEN`) and user token (`USER_TOKEN`) for different API endpoints

3. **Summary Generation** (`summarizerlib/summary.py`): Orchestrates the summarization process
   - `SummaryGenerator`: Fetches threads from Slack, formats them, sends to LLaMA server
   - Uses Jinja2 template (`prompt-template.j2`) loaded from `PROMPT_TEMPLATE` environment variable
   - Communicates with LLaMA server via HTTP POST to `/completion` endpoint

## Quick Start: Summarizing a Slack Conversation

When the user asks to summarize a Slack conversation (e.g., "summarize https://redhat-internal.slack.com/archives/C099GCW0B0Q/p1763631092378489"), follow these steps:

### 1. Prerequisites Check

**Virtual Environment**: Check if the `summarizer` virtualenv exists at `~/.virtualenvs/summarizer/bin/python`
   - If it doesn't exist, ask the user if you should create it and install dependencies from `requirements.txt`
   - To create the virtualenv:
     ```bash
     python3 -m venv ~/.virtualenvs/summarizer
     ~/.virtualenvs/summarizer/bin/pip install -r requirements.txt
     ```

**Credentials**: Check if `.env` file exists in the repository root
   - If it doesn't exist, ask the user to create it with the following format:
     ```
     SLACK_TOKEN=xoxb-your-bot-token-here
     USER_TOKEN=xoxp-your-user-token-here
     ```
   - The `.env` file should contain:
     - `SLACK_TOKEN`: Bot token for Slack API access
     - `USER_TOKEN`: User token for Slack search API

### 2. Fetch the Conversation

Use the `fetch_conversation.py` script to retrieve the Slack thread:

```bash
~/.virtualenvs/summarizer/bin/python fetch_conversation.py "https://redhat-internal.slack.com/archives/..."
```

This script will:
- Load credentials from the `.env` file
- Fetch the thread using `SlackThreadFinder`
- Format the conversation for easy reading and summarization
- Display the formatted output

### 3. Provide the Summary

After fetching the formatted conversation, analyze it and provide a TL;DR summary that includes:
- **Core Problem**: Describe the main issue or topic being discussed
- **Resolution/Action Plan**: Identify the current solution or next steps
- **Components Involved**: List specific software components, repositories, or Jira tickets mentioned
- **Issues to Fix**: Highlight any problems that need addressing
- **Relevant Links**: Include important URLs from the conversation (GitHub commits, builds, documentation, etc.)

## Environment Variables

The application requires these environment variables:

- `SLACK_TOKEN`: Bot token for Slack API access (stored in `.env`)
- `USER_TOKEN`: User token for Slack search API (stored in `.env`)
- `PROMPT_TEMPLATE`: The content of the Jinja2 prompt template (loaded from `prompt-template.j2`)
- `LLAMA_SERVER_HOST`: Hostname of LLaMA server (default: `localhost`)
- `LLAMA_SERVER_PORT`: Port of LLaMA server (default: `8080`)

## Development Commands

### Running the Application Locally

1. **Start the LLaMA server** (using podman):
   ```bash
   podman network create llama-net
   podman run -d --name llama-server \
     --network llama-net \
     -p 8080:8080 \
     -v "$(pwd)/models:/models:z" \
     ghcr.io/ggml-org/llama.cpp:server \
     -m /models/mistral-7b-instruct-v0.2.Q5_K_M.gguf \
     -c 4096 \
     --host 0.0.0.0 \
     --port 8080 \
     --threads 8 \
     --parallel 2 \
     --rope-frequency-base 1000000 \
     --temperature 0.3
   ```

2. **Set environment variables**:
   ```bash
   export SLACK_TOKEN=your-slack-token
   export USER_TOKEN=your-user-token
   export PROMPT_TEMPLATE="$(cat prompt-template.j2)"
   ```

3. **Run the FastAPI application**:
   ```bash
   python app.py
   ```
   Or using uvicorn directly:
   ```bash
   uvicorn app:app --host 0.0.0.0 --port 8000 --reload
   ```

### Testing the API

Test with a specific Slack permalink:
```bash
curl "http://127.0.0.1:8000/summarize-url?url=https://redhat-internal.slack.com/archives/GDBRP5YJH/p1746057618660169"
```

Test the art-attention summarizer:
```bash
curl "http://127.0.0.1:8000/summarize-art-attention"
```

Test the LLaMA server directly:
```bash
curl --request POST \
     --url http://0.0.0.0:8080/completion \
     --header "Content-Type: application/json" \
     --data '{"prompt": "what is the result of 2+2?","n_predict": 128}'
```

### Building Containers

Build the API container:
```bash
podman build -t api -f container/Dockerfile-api .
```

Run the API container:
```bash
podman run -d --name api \
  --network llama-net \
  -p 8000:8000 \
  -e USER_TOKEN=${USER_TOKEN} \
  -e SLACK_TOKEN=${SLACK_TOKEN} \
  -e PROMPT_TEMPLATE="$(cat prompt-template.j2)" \
  -e LLAMA_SERVER_HOST="llama-server" \
  -e LLAMA_SERVER_PORT="8080" \
  api
```

## OpenShift Deployment

The `container/resources/` directory contains Kubernetes/OpenShift manifests for deploying both the LLaMA server and the API application. See `container/README.md` for detailed deployment instructions.

Key OpenShift resources:
- `llama-model-pvc.yaml`: PersistentVolumeClaim for storing the LLaMA model
- `llama-deployment.yaml` & `llama-service.yaml`: LLaMA server deployment and service
- `slack-summarizer-deployment.yaml`: API application deployment (requires `slack-credentials` secret)
- `slack-summarizer-route.yaml`: Route with extended timeout for slow model responses

## Code Style Notes

- Python files use type hints throughout
- Functions have docstrings in triple-quote format with Args/Return Values sections
- Private functions (used only within a module) are prefixed with underscore
- The prompt template is stored in `prompt-template.j2` and loaded as an environment variable
