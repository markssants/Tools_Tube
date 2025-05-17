#!/bin/bash

# Verifica se yt-dlp e ffmpeg estão instalados
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "yt-dlp não está instalado. Use: brew install yt-dlp"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "ffmpeg não está instalado. Use: brew install ffmpeg"; exit 1; }

# Entrada do usuário
read -p "URL do vídeo do YouTube: " video_url
read -p "Início do clipe (formato HH:MM:SS): " inicio
read -p "Fim do clipe (formato HH:MM:SS): " fim
read -p "Nome do arquivo de saída (sem extensão): " nome_saida
read -p "Diretório para salvar o vídeo (pressione Enter para usar o diretório atual): " diretorio_saida

# Define o diretório (usa o atual se vazio)
if [ -z "$diretorio_saida" ]; then
  diretorio_saida="."
fi



# Cria o diretório se não existir
mkdir -p "$diretorio_saida"

# Define nome do arquivo temporário
nome_base="clipe_youtube"
saida="${nome_saida}.mp4"
saida_completa="${diretorio_saida}/${saida}"

# Baixa o trecho com codecs compatíveis
yt-dlp \
  --download-sections "*$inicio-$fim" \
  -f "bv*[ext=mp4][vcodec^=avc1]+ba[ext=m4a][acodec^=mp4a]/mp4" \
  -o "${nome_base}.%(ext)s" \
  "$video_url"

# Localiza o arquivo baixado
arquivo=$(ls ${nome_base}.* | head -n 1)

# Renomeia e move para o diretório de destino
mv "$arquivo" "$saida_completa"

echo "✅ Clipe salvo como: $saida_completa"
