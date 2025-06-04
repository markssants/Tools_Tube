# ✂️ Tools Tube ✂️

Um script de shell para macOS projetado para baixar vídeos e áudio do YouTube com várias opções de personalização.

## Funcionalidades

*   **Baixar Vídeo Único com Corte:** Baixe um vídeo específico e defina horários de início e fim para cortar o clipe.
*   **Baixar Múltiplos Vídeos:** Cole uma lista de URLs de vídeos para baixá-los sequencialmente.
    *   Opção de nomear os arquivos com o título original ou sequencialmente (ex: `ex1.mp4`, `ex2.mp4`).
*   **Baixar Playlist:**
    *   Baixe uma playlist inteira ou um intervalo específico de vídeos (ex: do vídeo 5 ao 10).
    *   Escolha baixar como **Vídeo (.mp4)** ou **Música (.mp3)**.
    *   Visualização da contagem de vídeos e lista de títulos antes do download.
    *   Opções de nomeação:
        *   Padrão (ex: `01 - Título Original.mp4`)
        *   Apenas Título Original (ex: `Título Original.mp4`)
        *   Prefixo Personalizado + Índice (ex: `MinhaSerie_01.mp4`)
        *   Renomear cada vídeo individualmente (interativo).
*   **Baixar Música (MP3):** Forneça a URL de um vídeo e baixe-o diretamente como um arquivo MP3.
*   **Diretório de Saída Persistente:**
    *   Defina um diretório padrão para salvar os arquivos.
    *   Opção de escolher um diretório diferente a cada vez usando o Finder ou digitando o caminho.
*   **Interface de Menu Interativa:** Navegação fácil através de menus coloridos no terminal.
*   **Verificação de Dependências:** Verifica automaticamente se `yt-dlp` e `ffmpeg` estão instalados.
*   **Abrir no Finder:** Opção para abrir a pasta de destino no Finder após o download.

## Requisitos

*   **macOS**
*   **Homebrew** (para fácil instalação das dependências)
*   **yt-dlp:** Utilitário de linha de comando para baixar vídeos.
    ```bash
    brew install yt-dlp
    ```
*   **ffmpeg:** Necessário para processamento de vídeo/áudio (corte, conversão para MP3).
    ```bash
    brew install ffmpeg
    ```

## Como Usar

1.  **Navegue até o diretório do script:**
    Abra o Terminal e use o comando `cd` para ir até a pasta onde `Tools_Tube.sh` e `executar.sh` estão localizados.
    ```bash
    cd /caminho/para/seu/script/Tools_Tube
    ```

2.  **Torne os scripts executáveis (apenas na primeira vez):**
    ```bash
    chmod +x ./Tools_Tube.sh
    chmod +x ./executar.sh
    ```

3.  **Execute o script:**
    Você pode usar o script `executar.sh` que lida com a navegação e permissões:
    ```bash
    ./executar.sh
    ```
    Ou, se você já estiver no diretório correto e o script `Tools_Tube.sh` for executável:
    ```bash
    ./Tools_Tube.sh
    ```

4.  **Siga as instruções no menu:**
    O script apresentará um menu principal com as opções disponíveis.

## Configuração

*   **Diretório Padrão:** Na primeira execução ou através das "Outras opções" de diretório, você pode definir um diretório padrão para salvar os arquivos. Esse caminho é armazenado no arquivo `.cortar_youtube_default_dir` dentro da pasta do script.

## Estrutura do Script

*   `Tools_Tube.sh`: O script principal com toda a lógica de download e interação com o usuário.
*   `executar.sh`: Um script auxiliar para facilitar a execução do `Tools_Tube.sh`.
*   `.cortar_youtube_default_dir`: Arquivo oculto gerado pelo script para armazenar o caminho do diretório de download padrão.

---

Desenvolvido para facilitar o download e gerenciamento de conteúdo do YouTube.
