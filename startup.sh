
# Fungsi menampilkan pesan dengan warna
print_message() {
  local color=$1
  local message=$2
  case $color in
    red) echo -e "\033[31m$message\033[0m" ;;
    green) echo -e "\033[32m$message\033[0m" ;;
    yellow) echo -e "\033[33m$message\033[0m" ;;
    blue) echo -e "\033[34m$message\033[0m" ;;
    *) echo -e "$message" ;;
  esac
}

# Fungsi memeriksa file bot
check_bot_file() {
  if [ ! -f "$BOT_FILE" ]; then
    print_message red "[❌] File bot ($BOT_FILE) tidak ditemukan!"
    read -p "Apakah Anda ingin membuat file bot baru? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      print_message blue "[ℹ️] Membuat file bot baru ($BOT_FILE)..."
      cat <<EOT > $BOT_FILE
import os
import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

bot = commands.Bot(command_prefix='!', intents=discord.Intents.all())

@bot.event
async def on_ready():
    print(f'Bot {bot.user} telah online!')

@bot.command()
async def ping(ctx):
    await ctx.send(f'Pong! {round(bot.latency * 1000)}ms')

if __name__ == "__main__":
    bot.run(os.getenv('DISCORD_TOKEN'))
EOT
      print_message green "[✅] File bot ($BOT_FILE) berhasil dibuat!"
      print_message yellow "[⚠️] Jangan lupa buat file .env dengan token bot Anda!"
      echo "Contoh isi .env:"
      echo "DISCORD_TOKEN=your_token_here"
      exit 1
    else
      print_message red "[❌] Proses dibatalkan. File bot diperlukan!"
      exit 1
    fi
  else
    print_message green "[✅] File bot ($BOT_FILE) ditemukan!"
  fi
}

check_dependencies() {
  if [ ! -f "requirements.txt" ]; then
    print_message yellow "[⚠️] File requirements.txt tidak ditemukan!"
    read -p "Apakah Anda ingin membuat file requirements.txt? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      echo "discord.py" > requirements.txt
      echo "python-dotenv" >> requirements.txt
      print_message green "[✅] File requirements.txt berhasil dibuat!"
    else
      print_message yellow "[ℹ️] Menginstall discord.py secara default..."
      pip install discord.py python-dotenv
    fi
  else
    print_message blue "[ℹ️] Menginstall dependensi dari requirements.txt..."
    pip install -r requirements.txt
  fi
}

main() {
  print_message blue "======================================"
  print_message blue " Discord Bot Python - Interactive Setup "
  print_message blue "======================================"

  check_bot_file

  check_dependencies

  print_message green "[🚀] Menjalankan bot Discord..."
  python3 $BOT_FILE
}

main
