# 🎬 Tools Tube ✂️

**Tools Tube** é uma poderosa ferramenta de terminal que facilita o download de vídeos e músicas do YouTube com diversas opções — como corte de trechos, playlists, múltiplos vídeos e extração de áudio em MP3.

---


# 🚀 Funcionalidades

- 📥 Baixar vídeos/músicas inteiros ou trechos definidos ✂️ (início e fim personalizados) ✂️
  
- 🎬 Download de múltiplos vídeos/músicas de uma vez com nomes automáticos ou manuais
  
- 📃 Baixar playlists completas ou trechos específicos (Vídeo ou Música)
- 🎧 Extrair áudio (🎶 MP3) diretamente de vídeos
- 🍎 Interface com seleção de diretório via Finder (macOS)
- 📁 Escolha automática ou manual do diretório de saída

---


## 📦 Requisitos

### Instalar dependências

Este script requer duas ferramentas:

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) – para baixar vídeos do YouTube.
- [`ffmpeg`](https://ffmpeg.org/) – para processar os arquivos de vídeo e áudio.

### 💻 No macOS (via Homebrew):
- MacOS (o script usa AppleScript para interação com o Finder)
- Terminal com suporte a ANSI escape codes (para cores)

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

---


# 🛠️ Instalação

### 👾 Clonar o repositório
Ou baixe/copie o script `Tools_Tube.sh` para uma pasta no seu sistema e torne-o executável:

```bash
git clone https://github.com/markssants/Tools_Tube.git/
```

---


# 💡 Como Usar

### 🕹️ Torne o script executável

```bash
chmod +x Tools_Tube.sh
```

### ▶️ Execute o script

```bash
./Tools_Tube.sh
```

---


## 🔧 Configuração

Na primeira execução, será solicitado um diretório padrão para salvar os arquivos.
O script salva o caminho padrão dos downloads em um arquivo `.tools_tube_default_dir` no mesmo diretório do script.

Você pode:
- Usar o diretório padrão (armazenado em `.tools_tube_default_dir`)
- Definir manualmente um novo diretório
- Usar o Finder para escolher a pasta
- Digitar o caminho manualmente
- Usar o diretório atual

---


## 🖥️ Interface

O script possui uma interface de terminal colorida e menus interativos. Exemplo:

gif das telas do script

---


## 📂 Menu Principal

```
1. Baixar 1 vídeo (com opção de corte personalizado)
  
   - Escolha o início e fim do vídeo (ou completo).


2. Baixar vários vídeos sequencialmente
  
   - Informe múltiplas URLs e escolha entre manter os títulos originais ou renomear.


3. Baixar playlist

   - Baixe a playlist inteira ou um intervalo (ex: do 5 ao 12)
   - Escolha entre baixar como vídeo ou áudio
   - Defina como nomear os arquivos (prefixo, título ou modo interativo)

4. Baixar música (converter para MP3)

   - Extraia o áudio do vídeo com nome personalizado ou baseado no título original.
```

---


## 📝 Observações

- O script **não salva histórico de URLs**.
- O uso do Finder para selecionar diretórios depende do `osascript`, exclusivo do macOS.
- Pode ser interrompido a qualquer momento com `CTRL+C`.
  

## 🧼 Arquivos temporários

O script renomeia automaticamente os arquivos baixados e limpa os temporários, deixando apenas o vídeo final com o nome desejado.

---

## 🧩 Estrutura do Script

*   `Tools_Tube.sh`: O script principal com toda a lógica de download e interação com o usuário.
*   `executar.sh`: Um script auxiliar para facilitar a execução do `Tools_Tube.sh` usando atalho pra abrir o Tools_Tube.
*   `.tools_tube_default_dir`: Arquivo oculto gerado pelo script para armazenar o caminho do diretório de download padrão.

---

## 🔒 Licença ✅

📜 Este projeto é de uso livre e pode ser adaptado conforme sua necessidade.


---

Desenvolvido para facilitar o download e gerenciamento de conteúdo do YouTube.

* Feito com 💜 por [Marks]
