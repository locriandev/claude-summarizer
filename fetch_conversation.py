#!/usr/bin/env python3

"""
This program fetches a Slack conversation by permalink and formats it for reading.
Example usage:
    python fetch_conversation.py "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"
"""

import os
import sys
from dotenv import load_dotenv
from summarizerlib.slack import SlackThreadFinder


def main(permalink):
    """
    Fetch and format a Slack conversation.
    """
    # Load environment variables from .env file
    load_dotenv()

    slack_token = os.getenv('SLACK_TOKEN')
    user_token = os.getenv('USER_TOKEN')

    if not slack_token or not user_token:
        print("Error: SLACK_TOKEN and USER_TOKEN must be set in .env file")
        return

    # Initialize the Slack thread finder
    finder = SlackThreadFinder(slack_token, user_token)

    print(f"Fetching conversation from: {permalink}\n")

    # Fetch the thread
    conversation = finder.fetch_thread_by_permalink(permalink)

    if not conversation:
        print("No conversation found or error occurred.")
        return

    # Format the thread for display
    formatted = finder.format_thread_for_summary(conversation)

    print("=" * 80)
    print("FORMATTED CONVERSATION")
    print("=" * 80)
    print(formatted)
    print("=" * 80)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python fetch_conversation.py <slack_permalink>")
        print('Example: python fetch_conversation.py "https://redhat-internal.slack.com/archives/CB95J6R4N/p1764683404081219"')
        sys.exit(1)

    permalink = sys.argv[1]
    main(permalink)
