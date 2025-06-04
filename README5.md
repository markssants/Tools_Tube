# ✂️ Tools Tube ✂️

**Tools Tube** é um script Bash interativo para macOS que facilita o download de vídeos e músicas do YouTube com diversas opções — como corte de trechos, playlists, múltiplos vídeos e extração de áudio em MP3.

---

## 📦 Requisitos

- `yt-dlp`
- `ffmpeg`
- macOS com `osascript` disponível (AppleScript)
- Terminal que suporte ANSI escape sequences (para cores)

Instale os requisitos via Homebrew:

```bash
brew install yt-dlp ffmpeg
```

---

## 🚀 Instalação

Clone o repositório ou copie o script `Tools_Tube.sh` para uma pasta no seu sistema e torne-o executável:

```bash
chmod +x Tools_Tube.sh
```

Execute com:

```bash
./Tools_Tube.sh
```

---

## 🎯 Funcionalidades

- **Baixar 1 vídeo com corte personalizado**
  - Permite definir início e fim do clipe (em formato `HH:MM:SS`)
  - Usa o título do vídeo ou nome personalizado

- **Baixar vários vídeos sequencialmente**
  - Permite colar até 10 links
  - Opções de nomeação automática ou manual

- **Baixar uma playlist completa**
  - Diversos modos de nomear os arquivos:
    - `01 - Título.mp4`
    - `Título.mp4`
    - `PrefixoPersonalizado_01.mp4`
    - Interativo (renomeia cada vídeo)

- **Extrair áudio em MP3**
  - A partir de qualquer link de vídeo
  - Nome personalizado ou título do vídeo

- **Gerenciamento de diretórios**
  - Salvar automaticamente em um diretório padrão
  - Seleção de pastas via Finder
  - Armazenamento do diretório padrão em `.cortar_youtube_default_dir`

---

## 🖥️ Interface

O script possui uma interface de terminal colorida e menus interativos. Exemplo:

```
🌟  Menu Principal  🌟

1. Baixar 1 vídeo (com opções de corte)
2. Baixar vários vídeos (sequencialmente)
3. Baixar playlist inteira
4. Baixar música (converter para MP3)
5. Sair
```

---

## 📝 Observações

- O script **não salva histórico de URLs**.
- O uso do Finder para selecionar diretórios depende do `osascript`, exclusivo do macOS.
- Pode ser interrompido a qualquer momento com `CTRL+C`.

---

## 📁 Estrutura dos arquivos gerados

Por padrão, os vídeos e áudios são salvos em um diretório configurável. O caminho padrão pode ser redefinido a qualquer momento pelas opções do menu.

---

## 🔒 Licença

Este projeto é de uso pessoal. Sinta-se livre para adaptar e compartilhar, desde que não seja comercializado sem autorização.

---

## 🙌 Agradecimentos

Inspirado na praticidade de ferramentas como `yt-dlp`, este script busca tornar o download e organização de vídeos algo acessível, rápido e personalizável para usuários de macOS.
