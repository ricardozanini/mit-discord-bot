# MIT Discord Bot

A minimal Discord bot that can:
- Respond to `$hello`
- Answer questions with OpenAI via `$question ...` (e.g., `$question why is the sky blue?`)

Built with **discord.py**, **OpenAI Python SDK**, and **python-dotenv**. Includes a `Makefile` for one-command setup and run.

---

## Prerequisites

- macOS (Linux/Windows work too)
- Python 3.10+ (recommended: 3.12/3.13)
- A Discord Bot token (Developer Portal → *Bot* → **Token**)
- An OpenAI **API** key (platform.openai.com → **API Keys**)  
  > Note: ChatGPT Plus/Pro subscriptions do **not** include API credits. Add billing/credits to your API project.

---

## Quick Start

1) **Clone or download** this project and `cd` into it.

2) **Create a `.env`** file in the project root:
   ```
   OPENAI_API_KEY=sk-...
   TOKEN=your_discord_bot_token
   ```

3) **Run with Makefile**
   ```bash
   make run
   ```
   This will:
   - create a virtualenv at `.venv/`
   - install dependencies from `requirements.txt`
   - run the bot entrypoint (default: `discord_bot.py`)

> To use a different script:
> ```bash
> make run MAIN=your_script.py
> ```

---

## Commands

- **$hello**  
  Replies with “Hello!”

- **$question <your text>**  
  Sends your text to OpenAI and replies like an MIT professor. Example:
  ```
  $question why is the sky blue?
  ```

---

## Configuration

- **Discord Message Content Intent**  
  In the Discord Developer Portal → *Bot*, enable **Message Content Intent** (you already set `intents.message_content=True` in code).

- **Environment variables** (from `.env`)
  - `OPENAI_API_KEY` – your OpenAI API key
  - `TOKEN` – Discord bot token

---

## Makefile Targets

```text
make install   # create .venv and install dependencies
make run       # run the bot (uses MAIN=discord_bot.py by default)
make freeze    # export exact versions to requirements.txt
make doctor    # print helpful versions (Python, pip, package versions)
make clean     # remove venv and caches
```

---

## Project Structure

```
.
├── discord_bot.py          # Example entrypoint with $hello and $question
├── requirements.txt         # Python dependencies
├── Makefile                 # Setup/run helpers
└── README.md
```

*(Optional)* Add a `.gitignore`:
```
.venv/
__pycache__/
.env
*.pyc
```

---

## Troubleshooting

- **`coroutine was never awaited`**  
  You defined an `async def` and forgot `await`. In handlers like `on_message`, always `await call_openai(...)`.

- **`on_message() takes 0 positional arguments but 1 was given`**  
  The signature must be `async def on_message(message: discord.Message):`.

- **OpenAI error `insufficient_quota` (HTTP 429)**  
  Your API project has no credits or hit limits. Add a payment method / credits in the API billing dashboard.

- **`command not found: python3`**  
  Install Python (e.g., `brew install python`) or use pyenv.

- **No response to `$question`**  
  Check your `.env`, confirm `OPENAI_API_KEY` and `TOKEN` names, and ensure the bot has **Message Content Intent** enabled in the portal.

---

## License

MIT.

---

## Acknowledgments

- [discord.py](https://github.com/Rapptz/discord.py)  
- [OpenAI Python SDK](https://github.com/openai/openai-python)  
- [python-dotenv](https://github.com/theskumar/python-dotenv)
