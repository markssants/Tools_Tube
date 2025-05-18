# 🎬 Cortar Trecho de Vídeo do YouTube via Terminal

Este script Bash permite **baixar um trecho específico de um vídeo do YouTube** usando `yt-dlp` e `ffmpeg`. Ideal para quem deseja extrair rapidamente uma parte de um vídeo sem precisar baixar tudo ou usar editores pesados.

## 🚀 Funcionalidades

- Baixa diretamente um trecho específico do YouTube (entre dois tempos).
- Suporte a codecs compatíveis com edição (AVC1 + MP4A).
- Permite personalizar o nome e o diretório de saída.
- Interface amigável via terminal.

---

## 🛠️ Requisitos e Instalação

### 1. Instalar dependências

Este script requer duas ferramentas:

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) – para baixar vídeos do YouTube.
- [`ffmpeg`](https://ffmpeg.org/) – para processar os arquivos de vídeo e áudio.

#### 💻 No macOS (via Homebrew):

```bash
brew install yt-dlp ffmpeg
```

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

#### 👾 Clonar o repositório ou baixar o script

```bash
git clone https://github.com/markssants/cortar-youtube.git
```

# 💡 Como Usar

Dê permissão de execução ao script

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

### 🧪 Exemplo

```
URL do vídeo do YouTube: https://youtube.com/watch?v=abc123
Início do clipe (formato HH:MM:SS): 00:01:00
Fim do clipe (formato HH:MM:SS): 00:02:00
Nome do arquivo de saída (sem extensão): meu_clipe
Diretório para salvar o vídeo: ~/Videos
✅ Clipe salvo como: ~/Videos/meu_clipe.mp4
```

#### 📁 Estrutura de Saída

- O vídeo cortado será salvo como NOME.mp4 no diretório indicado.
- Um arquivo temporário é gerado e renomeado automaticamente.

#### 🧼 Limpeza

O script já remove o arquivo temporário baixado, mantendo apenas o clipe final com o nome desejado.

### Também dá pra acrescentar:
#### 🔧 Funcionalidades Técnicas
    - Suporte a múltiplos trechos (batch)
    - Permitir que o usuário forneça vários tempos de início/fim e o script baixe todos de uma vez.
    - Barra de progresso amigável (tqdm ou rich) Para mostrar o andamento do download/corte.
