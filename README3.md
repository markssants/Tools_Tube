# ✂️ Tools Tube - Baixe vídeos do YouTube com estilo via Terminal

Este script interativo em Bash permite baixar vídeos do YouTube com **diversas opções**, incluindo:

- Cortar trechos específicos com precisão
- Baixar múltiplos vídeos de uma vez
- Baixar playlists completas ou parciais
- Converter vídeos em músicas (.mp3)

Tudo isso direto do **Terminal** com uma interface amigável, colorida e fluida — totalmente otimizado para **macOS**.

---

## 🚀 Funcionalidades

- 🧠 Interface interativa e intuitiva via terminal
- ✂️ Corte de trechos exatos (início e fim personalizados)
- 📥 Download de múltiplos vídeos com nomes automáticos ou manuais
- 🎶 Extração de áudio (formato MP3)
- 📃 Download de playlists inteiras ou por intervalo
- 📁 Escolha automática ou manual do diretório de saída
- 🍎 Integração com o Finder para selecionar pastas no macOS

---

## 🛠️ Requisitos

Instale os seguintes pacotes antes de usar:

### macOS (via Homebrew):

```bash
brew install yt-dlp ffmpeg
```

### Linux (Debian/Ubuntu):

```bash
sudo apt update
sudo apt install yt-dlp ffmpeg
```

### Windows:

- Use Git Bash ou WSL (Linux no Windows)
- Adicione `yt-dlp` e `ffmpeg` ao PATH
- Baixe em:
  - https://github.com/yt-dlp/yt-dlp/releases
  - https://ffmpeg.org/download.html

---

## 📦 Instalação

1. Clone ou baixe o script:

```bash
git clone https://github.com/seu-usuario/tools-tube.git
cd tools-tube
chmod +x Tools_Tube.sh
```

2. Execute o script:

```bash
./Tools_Tube.sh
```

---

## 💡 Exemplos de uso

### 1️⃣ Baixar um trecho de vídeo

- Informe a URL do YouTube
- Defina o tempo de início e fim (formato `HH:MM:SS`)
- Escolha se deseja usar o título original como nome
- Escolha onde salvar

### 2️⃣ Baixar múltiplos vídeos

- Insira quantos vídeos quiser (até 99)
- Forneça as URLs uma a uma
- Escolha entre nomes automáticos ou sequenciais

### 3️⃣ Baixar playlist

- Escolha entre baixar como vídeo ou áudio
- Baixe a playlist inteira ou um intervalo (ex: do 5 ao 12)
- Defina como nomear os arquivos (prefixo, título ou modo interativo)

### 4️⃣ Baixar música

- Informe a URL do vídeo
- Ele será convertido automaticamente para `.mp3`

---

## 🧼 Arquivos temporários

O script renomeia automaticamente os arquivos baixados e limpa os temporários, deixando apenas o vídeo final com o nome desejado.

---

## 🧠 Extras Técnicos

- Totalmente modular e comentado
- Suporte a atalhos com Enter e sugestões padrões
- Organização avançada de diretórios e preferências salvas

---

## 📂 Estrutura de saída

Todos os vídeos são salvos no diretório escolhido, com nomes limpos e compatíveis com qualquer sistema de arquivos.

---

## 🤝 Contribuições

Pull requests e sugestões são bem-vindos! Este projeto nasceu para tornar tarefas repetitivas no YouTube mais simples, rápidas e agradáveis.

---

## ✅ Licença

MIT — Livre para uso e modificação.

---

Desfrute do poder do terminal com um toque de estilo! ✨
