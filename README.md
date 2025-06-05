# 🎬 Tools Tube ✂️

**Tools Tube** é uma poderosa ferramenta de terminal que facilita o download de vídeos e músicas do YouTube com diversas opções — como corte de trechos, playlists, múltiplos vídeos e extração de áudio em MP3.

---


## 🚀 Funcionalidades

- 📥 Baixar vídeos/músicas inteiros ou trechos definidos ✂️ (início e fim personalizados) ✂️
- 🎬 Download de múltiplos vídeos/músicas de uma vez com nomes automáticos ou manuais
- 📃 Baixar playlists completas ou trechos específicos (Vídeo ou Música)
- 🎧 Extrair áudio (🎶 MP3) diretamente de vídeos
- 🍎 Interface com seleção de diretório via Finder (macOS)
- 📁 Escolha automática ou manual do diretório de saída

---

# 💡 Como Usar

Torne o script executável

```bash
chmod +x cortar_youtube.sh
```

### 🕹️ Execute o script

```bash
./cortar_youtube.sh
```

### 🧩 Responda às perguntas no terminal:

```
URL do vídeo do YouTube

Tempo de início (ex: 00:01:30)

Tempo de fim (ex: 00:02:45)

Nome do arquivo de saída (sem .mp4)

Diretório onde deseja salvar (pressione Enter para usar o atual)
```

---

## 📦 Requisitos e Instalação 🛠️

### 1. Instalar dependências

Este script requer duas ferramentas:

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) – para baixar vídeos do YouTube.
- [`ffmpeg`](https://ffmpeg.org/) – para processar os arquivos de vídeo e áudio.

#### 💻 No macOS (via Homebrew):

```bash
brew install yt-dlp ffmpeg
```
- Terminal com suporte a ANSI escape codes (para cores)

#### 🐧 No Linux (Debian/Ubuntu):

```bash
sudo apt update
sudo apt install yt-dlp ffmpeg
```

#### 🪟 No Windows:

```
- Instale o Git Bash ou use o WSL (subsistema Linux do Windows).
- Baixe e adicione yt-dlp e ffmpeg ao PATH.
- https://github.com/yt-dlp/yt-dlp/releases
- https://ffmpeg.org/download.html
```

## 👾 Clonar o repositório ou baixar o script

```bash
git clone https://github.com/markssants/cortar-youtube.git
```

---

## 🔧 Configuração

O script salva o caminho padrão dos downloads em um arquivo `.cortar_youtube_default_dir` no mesmo diretório do script.

Você pode:
- Definir manualmente um novo diretório
- Usar o Finder para escolher a pasta
- Usar o diretório atual


## 📂 Estrutura de Menu

```
1. Baixar 1 vídeo (com opções de corte)
2. Baixar vários vídeos (sequencialmente)
3. Baixar playlist (vídeo ou música)
4. Baixar música (converter vídeo para MP3)
5. Sair
```
