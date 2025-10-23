from dotenv import load_dotenv
from openai import AsyncOpenAI
import discord, os

load_dotenv()

oa_client = AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))
if not os.getenv("OPENAI_API_KEY"):
    raise RuntimeError("Missing OPENAI_API_KEY in .env")

intents = discord.Intents.default()
intents.message_content = True  # also enable this in the Discord Developer Portal

client = discord.Client(intents=intents)

async def call_openai(question: str) -> str:
    completion = await oa_client.chat.completions.create(
        model="gpt-4o",
        messages=[{
            "role": "user",
            "content": f"Respond like an MIT professor to the following question: {question}"
        }]
    )
    return completion.choices[0].message.content

@client.event
async def on_ready():
    print(f"We have logged in as {client.user}")

@client.event
async def on_message(message: discord.Message):
    if message.author == client.user:
        return

    if message.content.startswith("$hello"):
        await message.channel.send("Hello!")

    if message.content.startswith("$question"):
        print(f"Message: {message.content}")
        question = message.content.split("$question", 1)[1].strip()
        print(f"Question: {question}")
        response = await call_openai(question)
        print(f"Assistant: {response}\n----")
        await message.channel.send(response)

client.run(os.getenv("TOKEN"))
