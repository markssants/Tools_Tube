# ✂️ Tools Tube

Um utilitário em Bash interativo e colorido para baixar vídeos, trechos, playlists ou apenas o áudio de vídeos do YouTube usando `yt-dlp` e `ffmpeg`.

## 🚀 Funcionalidades

- 📥 Baixar vídeos inteiros ou trechos definidos (início e fim personalizados)
- 🎬 Baixar múltiplos vídeos de uma vez
- 🎶 Baixar playlists completas ou trechos específicos
- 🎧 Extrair áudio (MP3) diretamente de vídeos
- 📂 Interface com seleção de diretório via Finder (macOS)
- 🧠 Lembra o diretório padrão para uso futuro

## 📦 Requisitos

- macOS (o script usa AppleScript para interação com o Finder)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [ffmpeg](https://ffmpeg.org/)

Instale com Homebrew:

```bash
brew install yt-dlp ffmpeg
```

## 🔧 Instalação

Clone ou baixe este repositório e dê permissão de execução ao script:

```bash
chmod +x Tools_Tube.sh
```

## ▶️ Uso

Execute o script no terminal:

```bash
./Tools_Tube.sh
```

### Menu Principal

1. **Baixar 1 vídeo (com opção de corte)**  
   Escolha o início e fim do vídeo (ou deixe em branco para completo).

2. **Baixar vários vídeos**  
   Informe múltiplas URLs e escolha entre manter os títulos originais ou renomear.

3. **Baixar playlist**  
   Baixe a playlist completa ou apenas parte dela, com várias opções de nomeação.

4. **Baixar música (converter para MP3)**  
   Extraia o áudio do vídeo com nome personalizado ou baseado no título original.

5. **Sair**

## 📁 Configuração de Diretório

Na primeira execução, será solicitado um diretório padrão para salvar os arquivos. Você pode:

- Usar o diretório padrão (armazenado em `.cortar_youtube_default_dir`)
- Escolher um novo via Finder
- Digitar o caminho manualmente

## 💡 Dicas

- O script salva o caminho do diretório padrão no arquivo `.cortar_youtube_default_dir` no mesmo diretório do script.
- Ideal para quem quer baixar trechos sem usar interfaces gráficas complexas.
- Recomendado para criadores de conteúdo, professores, editores e estudantes.

## 📜 Licença

Este projeto é de uso livre e pode ser adaptado conforme sua necessidade.

---

Feito com ❤️ por [Seu Nome]
