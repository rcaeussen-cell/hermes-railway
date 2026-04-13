# hermes-railway

One-click Railway deployments for [Hermes Agent](https://github.com/NousResearch/hermes-agent), a self-improving autonomous AI agent with Telegram support.

## Agents

Two starter agents are currently included in the template, each pre-configured for a different LLM provider:

| Agent | Provider | Default Model |
|---|---|---|
| [starter-openai](agents/starter-openai) | OpenAI | `gpt-5.4-mini` |
| [starter-google](agents/starter-google) | Google Gemini | `gemini-2.5-flash` |

A [starter-anthropic](agents/starter-anthropic) agent is included in the repo but not yet published as part of the Railway template.

## Deploy

[![Deploy Hermes agents on Railway](https://railway.com/button.svg)](https://railway.com/deploy/WnRR8F?referralCode=alphasec)

Each agent is independently deployable. Set the Railway root directory to the agent folder (e.g. `agents/starter-openai`) when deploying.

## Configuration

Set the following environment variables in Railway after deploying:

### starter-openai

| Variable | Required | Description |
|---|---|---|
| `OPENAI_API_KEY` | Yes | OpenAI API key |
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token from [@BotFather](https://t.me/botfather) |
| `TELEGRAM_ALLOWED_USERS` | No | Comma-separated Telegram user IDs. Empty allows all |
| `HERMES_MODEL` | Yes | E.g. `gpt-5.4-mini` |

### starter-google

| Variable | Required | Description |
|---|---|---|
| `GOOGLE_API_KEY` | Yes | Google AI Studio API key |
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token from [@BotFather](https://t.me/botfather) |
| `TELEGRAM_ALLOWED_USERS` | No | Comma-separated Telegram user IDs. Empty allows all |
| `HERMES_MODEL` | Yes | E.g. `gemini-2.5-flash` |

### starter-anthropic

| Variable | Required | Description |
|---|---|---|
| `ANTHROPIC_API_KEY` | Yes | Anthropic API key |
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token from [@BotFather](https://t.me/botfather) |
| `TELEGRAM_ALLOWED_USERS` | No | Comma-separated Telegram user IDs. Empty allows all |
| `HERMES_MODEL` | Yes | E.g. `claude-sonnet-4-5` |

## Persistence

A Railway volume is required, mounted at `/data`. Sessions, memory, skills, and agent config persist across restarts.

## License

MIT
