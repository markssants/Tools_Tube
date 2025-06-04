#!/bin/bash

# Cores
BOLD_RED='\033[1;91m' # Vermelho brilhante em negrito
BOLD_GREEN='\033[1;92m' # Verde brilhante em negrito
BOLD_YELLOW='\033[1;93m' # Amarelo brilhante em negrito
BOLD_LIGHT_BLUE='\033[1;94m' # Azul claro/brilhante em negrito
BOLD_CYAN='\033[1;96m' # Ciano brilhante em negrito, conforme seu exemplo
BOLD_WHITE='\033[1;97m' # Branco brilhante em negrito
NC='\033[0m' # No Color

# Título do Script
SCRIPT_TITLE_LINE="${BOLD_RED}✂️   ${NC}${BOLD_YELLOW}Tools${NC} ${BOLD_RED}Tube ✂️${NC}"

# Função para limpar a tela e mostrar o título
clear_and_show_title() {
  # especialmente no Terminal.app do macOS, usamos printf '\33c\e[3J'.
  printf '\33c\e[3J'
  echo 
  echo -e "$SCRIPT_TITLE_LINE"
  echo
}

# Verifica se yt-dlp e ffmpeg estão instalados
command -v yt-dlp >/dev/null 2>&1 || { echo -e >&2 "${BOLD_RED}❌ yt-dlp não está instalado. Use: brew install yt-dlp${NC}"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo -e >&2 "${BOLD_RED}❌ ffmpeg não está instalado. Use: brew install ffmpeg${NC}"; exit 1; }

SCRIPT_INSTALL_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

# Arquivo para armazenar o caminho do diretório padrão
CONFIG_FILE_PATH="${SCRIPT_INSTALL_DIR}/.cortar_youtube_default_dir"

# Função para definir ou atualizar o diretório padrão
set_or_update_default_directory() {
  echo -e "  ${BOLD_CYAN}ℹ️  Abrindo o Finder para você escolher o diretório padrão...${NC}"
  local chosen_dir
  # AppleScript modificado para maior robustez
  chosen_dir=$(osascript -e '
    on run argv
      set scriptPath to item 1 of argv
      set chosenFolderPath to ""
      try
        set defaultLocationAlias to (POSIX file scriptPath as alias)
        try
          set chosenFolderPath to POSIX path of (choose folder with prompt "Escolha o DIRETÓRIO PADRÃO para salvar os vídeos:" default location defaultLocationAlias)
        on error number -128 # Usuário cancelou "choose folder"
          # chosenFolderPath permanece ""
        end try
      on error errMsg number errNum # Erro ao converter para alias ou outro erro inesperado
        log "AppleScript error (set_or_update_default_directory): " & errMsg & " (Number: " & errNum & ")"
        # Tenta abrir "choose folder" sem um local padrão como fallback
        try
          set chosenFolderPath to POSIX path of (choose folder with prompt "Escolha o DIRETÓRIO PADRÃO para salvar os vídeos:")
        on error number -128 # Usuário cancelou "choose folder" (fallback)
          # chosenFolderPath permanece ""
        end try
      end try
      return chosenFolderPath
    end run
  ' "$SCRIPT_INSTALL_DIR")

  if [[ -n "$chosen_dir" ]]; then
    chosen_dir="${chosen_dir%/}" # Remove trailing slash
    if mkdir -p "$chosen_dir"; then # Tenta criar/validar o diretório
      if echo "$chosen_dir" > "$CONFIG_FILE_PATH"; then
        diretorio_saida="$chosen_dir" # Define a variável global
        echo -e "  ${BOLD_GREEN}👍 Diretório padrão definido/atualizado para: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
        echo -e "  ${BOLD_LIGHT_BLUE}💾 Salvo em: $CONFIG_FILE_PATH${NC}"
        return 0 # Sucesso
      else
        echo -e "  ${BOLD_RED}❌ Erro ao salvar o caminho do diretório padrão em '$CONFIG_FILE_PATH'.${NC}"
        # Fallback será tratado pelo chamador se necessário
        return 1 # Falha
      fi
    else
      echo -e "  ${BOLD_RED}❌ Erro ao criar/acessar o diretório escolhido: \"$chosen_dir\".${NC}"
      return 1 # Falha
    fi
  else
    echo -e "  ${BOLD_YELLOW}⚠️  Seleção do diretório padrão cancelada.${NC}"
    return 1 # Falha, usuário cancelou
  fi
}

# Função que encapsula a lógica original de seleção de diretório (linhas 74-294 do script original)
# Retorna 0 em sucesso (diretorio_saida global é definido), 1 em falha.
_run_original_directory_selection_block() {
  # Inicializa diretorio_saida. Deve ser definido por uma das lógicas abaixo.
  # Esta variável é global e será modificada por esta função.
  diretorio_saida=""


while [[ -z "$diretorio_saida" ]]; do # Loop until a directory is chosen or script exits
  echo # Linha em branco para separar do prompt anterior, se houver

  # Prepara a informação do diretório padrão para exibição no menu
  default_dir_exists_text=" (${BOLD_RED}não${NC})" # Padrão para "não"
  if [[ -f "$CONFIG_FILE_PATH" && -r "$CONFIG_FILE_PATH" ]]; then
    temp_default_dir_from_file=$(<"$CONFIG_FILE_PATH")
    temp_default_dir_from_file="${temp_default_dir_from_file%/}" # Remove trailing slash
    if [[ -n "$temp_default_dir_from_file" && -d "$temp_default_dir_from_file" ]]; then
      default_dir_exists_text=" (${BOLD_GREEN}sim${NC})" # Muda para (sim) se existir e for válido
    fi
  # Se o arquivo de configuração não existir ou não for legível, default_dir_exists_text
  # permanecerá como " (não)"
  fi

  echo -e "${BOLD_YELLOW}📂  Escolha o diretório para salvar o vídeo:  📂${NC}"
  echo
  echo -e "   ${BOLD_CYAN}1.${NC} ${BOLD_WHITE}Usar diretório ${BOLD_WHITE}padrão${default_dir_exists_text} ${BOLD_RED}(Pressione Enter ou '1')${NC}"
  echo -e "   ${BOLD_CYAN}2.${NC} ${BOLD_WHITE}Escolher pelo ${BOLD_LIGHT_YELLOW}Finder ${BOLD_CYAN}(Digite 'f' ou '2')${NC}"
  echo -e "   ${BOLD_CYAN}3.${NC} ${BOLD_WHITE}Outras opções ${BOLD_CYAN}(Digite 'o' ou '3')${NC}"
  echo
  read -p "$(echo -e "${BOLD_LIGHT_BLUE}📂  Opção ou caminho: ${NC}")" escolha_diretorio_main

  if [[ -z "$escolha_diretorio_main" || "$escolha_diretorio_main" == "1" ]]; then # Opção 1: Usar diretório padrão
    echo # Linha em branco
    if [[ -f "$CONFIG_FILE_PATH" && -r "$CONFIG_FILE_PATH" ]]; then
      default_dir_from_file=$(<"$CONFIG_FILE_PATH")
      default_dir_from_file="${default_dir_from_file%/}" # Remove trailing slash
      if [[ -n "$default_dir_from_file" && -d "$default_dir_from_file" ]]; then
        diretorio_saida="$default_dir_from_file"
        echo -e "  ${BOLD_GREEN}👍 Usando diretório padrão salvo: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
      else
        echo -e "  ${BOLD_YELLOW}⚠️  Diretório padrão salvo em '$CONFIG_FILE_PATH' não é válido ou não encontrado.${NC}"
        echo -e "  ${BOLD_CYAN}ℹ️  Você será solicitado a definir um agora.${NC}"
        if ! set_or_update_default_directory; then
            echo -e "  ${BOLD_YELLOW}⚠️  Definição do diretório padrão cancelada/falhou. Escolha uma opção novamente.${NC}"
            # diretorio_saida remains empty, loop continues
        fi # If successful, diretorio_saida is set by the function, loop will terminate
      fi
    else
      echo -e "  ${BOLD_CYAN}ℹ️  Nenhum diretório padrão configurado.${NC}"
      echo -e "  ${BOLD_CYAN}ℹ️  Você será solicitado a definir um agora.${NC}"
      if ! set_or_update_default_directory; then
          echo -e "  ${BOLD_YELLOW}⚠️  Definição do diretório padrão cancelada/falhou. Escolha uma opção novamente.${NC}"
          # diretorio_saida remains empty, loop continues
      fi # If successful, diretorio_saida is set by the function, loop will terminate
    fi
  elif [[ "$escolha_diretorio_main" == "f" || "$escolha_diretorio_main" == "F" || "$escolha_diretorio_main" == "2" ]]; then # Opção 2: Escolher pelo Finder
    echo
    echo -e "  ${BOLD_CYAN}ℹ️  Abrindo o Finder para seleção de diretório...${NC}"
    # SCRIPT_DIR_FOR_FINDER é usado aqui, definido dentro deste bloco if/elif.
    # A definição de SCRIPT_DIR_FOR_FINDER é idêntica em lógica a SCRIPT_INSTALL_DIR.
    # Removido 'local' pois não está dentro de uma função.
    SCRIPT_DIR_FOR_FINDER_MENU="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"
    # AppleScript modificado para maior robustez
    chosen_dir=$(osascript -e '
      on run argv
        set scriptPath to item 1 of argv
        set chosenFolderPath to ""
        try
          set defaultLocationAlias to (POSIX file scriptPath as alias)
          try
            set chosenFolderPath to POSIX path of (choose folder with prompt "Escolha o diretório para salvar o vídeo:" default location defaultLocationAlias)
          on error number -128 # Usuário cancelou "choose folder"
            # chosenFolderPath permanece ""
          end try
        on error errMsg number errNum # Erro ao converter para alias ou outro erro inesperado
          log "AppleScript error (main menu finder choice): " & errMsg & " (Number: " & errNum & ")"
          # Tenta abrir "choose folder" sem um local padrão como fallback
          try
            set chosenFolderPath to POSIX path of (choose folder with prompt "Escolha o diretório para salvar o vídeo:")
          on error number -128 # Usuário cancelou "choose folder" (fallback)
            # chosenFolderPath permanece ""
          end try
        end try
        return chosenFolderPath
      end run
    ' "$SCRIPT_DIR_FOR_FINDER_MENU")

    if [[ -n "$chosen_dir" ]]; then
      diretorio_saida="$chosen_dir"
    else
      echo -e "  ${BOLD_YELLOW}⚠️  ${BOLD_WHITE}Seleção pelo Finder ${BOLD_YELLOW}cancelada ou ${BOLD_RED}falhou. ${BOLD_WHITE}Escolha uma opção novamente.${NC}"
      # diretorio_saida remains empty, loop continues
    fi
  elif [[ "$escolha_diretorio_main" == "o" || "$escolha_diretorio_main" == "O" || "$escolha_diretorio_main" == "3" ]]; then # Opção 3: Outras opções
    clear_and_show_title # Limpa o terminal e mostra o título ao entrar no submenu "Outras opções"
    echo
    echo -e "${BOLD_YELLOW}⚙️  Outras opções de diretório:${NC}"

    # Prepara a informação do diretório padrão (caminho ou "sem") para a opção "Modificar" no submenu
    modify_default_dir_hint=" (${BOLD_YELLOW}sem${NC})"
    if [[ -f "$CONFIG_FILE_PATH" && -r "$CONFIG_FILE_PATH" ]]; then
      temp_default_dir_submenu=$(<"$CONFIG_FILE_PATH")
      temp_default_dir_submenu="${temp_default_dir_submenu%/}" # Remove trailing slash
      if [[ -n "$temp_default_dir_submenu" && -d "$temp_default_dir_submenu" ]]; then
        modify_default_dir_hint=" (${BOLD_YELLOW}$(realpath "$temp_default_dir_submenu")${NC})"
      fi
    fi

    echo
    echo -e "   ${BOLD_CYAN}1.${NC} Definir diretório ${BOLD_WHITE}padrão${NC}"
    echo -e "   ${BOLD_CYAN}2.${NC} Modificar diretório ${BOLD_WHITE}padrão${modify_default_dir_hint}${NC}"
    echo -e "   ${BOLD_CYAN}3.${NC} Usar o diretório ${BOLD_WHITE}atual ${BOLD_LIGHT_BLUE}($(pwd))${NC} ${BOLD_CYAN}(Digite '3')${NC}"
    echo -e "   ${BOLD_CYAN}4.${NC} Digitar caminho ${BOLD_WHITE}manualmente${NC}"
    echo -e "   ${BOLD_CYAN}5.${NC} Voltar ao menu anterior ${BOLD_CYAN}(Digite '5')${NC}"
    echo
    read -p "$(echo -e "${BOLD_LIGHT_BLUE}⚙️  Opção: ${NC}")" escolha_submenu

    case "$escolha_submenu" in
      1) # Definir diretório padrão (manualmente com editor)
        echo
        echo -e "  ${BOLD_CYAN}ℹ️  Editando o arquivo de configuração do diretório padrão: ${BOLD_YELLOW}$CONFIG_FILE_PATH${NC}"
        echo -e "  ${BOLD_CYAN}ℹ️  Insira o caminho completo para o diretório desejado na primeira linha, salve e feche o editor.${NC}"
        
        # Garante que o diretório pai do arquivo de configuração exista
        if [[ ! -d "$(dirname "$CONFIG_FILE_PATH")" ]]; then
            if ! mkdir -p "$(dirname "$CONFIG_FILE_PATH")"; then
                echo -e "  ${BOLD_RED}❌ Erro crítico ao criar o diretório para o arquivo de configuração: $(dirname "$CONFIG_FILE_PATH")${NC}"
                continue # Volta ao menu principal
            fi
        fi
        # Cria o arquivo se não existir para o editor abrir
        if [[ ! -f "$CONFIG_FILE_PATH" ]]; then
            touch "$CONFIG_FILE_PATH"
            echo -e "  ${BOLD_LIGHT_BLUE}🔧 Arquivo de configuração criado: $CONFIG_FILE_PATH${NC}"
        fi

        # Tenta usar $EDITOR, depois nano, depois vi como fallback
        if [[ -n "$EDITOR" ]]; then
            "$EDITOR" "$CONFIG_FILE_PATH"
        elif command -v nano >/dev/null 2>&1; then
            nano "$CONFIG_FILE_PATH"
        elif command -v vi >/dev/null 2>&1; then
            vi "$CONFIG_FILE_PATH"
        else
            echo -e "  ${BOLD_RED}❌ Nenhum editor de texto (nano, vi, ou \$EDITOR) encontrado. Não é possível editar manualmente.${NC}"
            continue # Volta ao menu principal
        fi

        if [[ -f "$CONFIG_FILE_PATH" && -r "$CONFIG_FILE_PATH" ]]; then
            # Lê a primeira linha não vazia, remove espaços extras e trailing slash
            edited_path=$(grep -v '^[[:space:]]*$' "$CONFIG_FILE_PATH" | head -n 1)
            edited_path="${edited_path#"${edited_path%%[![:space:]]*}"}" # Trim leading whitespace
            edited_path="${edited_path%"${edited_path##*[![:space:]]}"}" # Trim trailing whitespace
            edited_path="${edited_path%/}" # Remove trailing slash

            if [[ -z "$edited_path" ]]; then
                echo -e "  ${BOLD_YELLOW}⚠️  O arquivo de configuração está vazio ou contém apenas espaços após a edição.${NC}"
                echo -e "  ${BOLD_YELLOW}⚠️  Nenhum diretório padrão foi definido. Retornando...${NC}"
            elif mkdir -p "$edited_path" && [[ -d "$edited_path" ]]; then
                diretorio_saida="$edited_path" # Define a variável global para sair do loop principal
                echo -e "  ${BOLD_GREEN}👍 Diretório padrão definido manualmente para: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
                # Garante que o arquivo de configuração contenha apenas o caminho limpo e validado
                if ! echo "$edited_path" > "$CONFIG_FILE_PATH"; then
                    echo -e "  ${BOLD_RED}⚠️ Erro ao salvar o caminho validado no arquivo de configuração '$CONFIG_FILE_PATH'.${NC}"
                    echo -e "  ${BOLD_YELLOW}   A alteração pode não ser persistente para a próxima execução.${NC}"
                fi
            else
                echo -e "  ${BOLD_RED}❌ O caminho '$edited_path' (lido do arquivo) não é um diretório válido ou não pôde ser criado/acessado.${NC}"
                echo -e "  ${BOLD_YELLOW}⚠️  Verifique o caminho e as permissões. Retornando...${NC}"
            fi
        else
            echo -e "  ${BOLD_RED}❌ Não foi possível ler o arquivo de configuração '$CONFIG_FILE_PATH' após a edição.${NC}"
        fi
        # Se diretorio_saida foi definido, o loop principal de escolha de diretório terminará.
        # Caso contrário, o loop de "outras opções" termina e o loop principal de escolha de diretório continua.
        ;;
      2) # Modificar diretório padrão (com Finder)
        if ! set_or_update_default_directory; then
            echo -e "  ${BOLD_YELLOW}⚠️  Operação cancelada/falhou. Retornando ao menu anterior.${NC}"
            # diretorio_saida remains empty, loop continues to main menu
        fi
        # If successful, diretorio_saida is set by the function, loop will terminate
        ;;
      3) # Usar o diretório atual
        diretorio_saida="."
        echo -e "  ${BOLD_GREEN}👍 Usando o diretório atual: ${BOLD_YELLOW}$(pwd)${NC}"
        ;;
      4) # Digitar caminho manualmente
        echo
        echo -e "  ${BOLD_GREEN}📍 Diretório atual: $(pwd)${NC}"
        read -p "$(echo -e "${BOLD_YELLOW}📂  Digite o caminho do diretório: ${NC}")" manual_path
        if [[ -n "$manual_path" ]]; then # Verifica se algo foi digitado
            diretorio_saida="$manual_path"
        else
            echo -e "  ${BOLD_YELLOW}⚠️  Nenhum caminho digitado. Retornando ao menu anterior.${NC}"
            # diretorio_saida remains empty, loop continues
        fi
        ;;
      5|"") # Voltar (Enter também)
        clear_and_show_title # Limpa o terminal e mostra o título ao voltar para o menu anterior
        echo -e "  ${BOLD_LIGHT_BLUE}↩️  Retornando ao menu principal...${NC}"
        continue # Restart the while loop, re-displaying the main menu
        ;;
      *)
        echo -e "  ${BOLD_RED}❌ Opção inválida no submenu. Retornando ao menu principal.${NC}"
        continue # Restart the while loop
        ;;
    esac
  else # Tratar como caminho digitado diretamente
    if [[ -n "$escolha_diretorio_main" ]]; then # Verifica se algo foi digitado
        diretorio_saida="$escolha_diretorio_main"
    else
        echo -e "  ${BOLD_YELLOW}⚠️  Nenhum caminho ou opção válida digitada. Escolha uma opção novamente.${NC}"
        # diretorio_saida remains empty, loop continues
    fi
  fi
done # End of while [[ -z "$diretorio_saida" ]] loop

# Garante que o diretório de saída não termine com / para evitar // no caminho
diretorio_saida="${diretorio_saida%/}"

# Se, por alguma razão MUITO inesperada, o loop terminar com diretorio_saida vazio,
# este bloco serve como um último recurso. Com a lógica do loop, isso não deve acontecer.
if [[ -z "$diretorio_saida" ]]; then
    echo -e "  ${BOLD_YELLOW}⚠️ Nenhuma seleção de diretório válida. Usando o diretório atual.${NC}"
    diretorio_saida="."
fi

# Cria o diretório se não existir
if ! mkdir -p "$diretorio_saida"; then
  echo -e "  ${BOLD_RED}❌ Erro ao criar ou acessar o diretório: \"$diretorio_saida\"${NC}"
  echo -e "  ${BOLD_YELLOW}⚠️  Usando o diretório atual como fallback.${NC}"
  diretorio_saida="."
  # Tenta criar o diretório atual se a tentativa anterior falhou (altamente improvável para ".")
  if ! mkdir -p "$diretorio_saida"; then
      echo -e "  ${BOLD_RED}❌ Falha crítica ao criar o diretório atual. Saindo.${NC}"
      return 1 # Modificado de exit 1 para return 1
  fi
fi
echo # Linha em branco antes da confirmação
echo -e "  ${BOLD_GREEN}👍 Vídeos serão salvos em: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
echo # Linha em branco após a confirmação

# --- Fim da movimentação da escolha do diretório ---
  return 0 # Sucesso se chegou até aqui
}

# Função para garantir que o diretório de saída esteja definido para as opções 2, 3, 4
ensure_output_directory_is_set() {
  if [[ -n "$diretorio_saida" && -d "$diretorio_saida" ]]; then
    echo
    echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Diretório de saída atual: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
    local use_current_dir
    read -p "$(echo -e "  ${BOLD_CYAN}❓ Usar este diretório? (${NC}${BOLD_GREEN}s${NC}${BOLD_CYAN}/${NC}${BOLD_RED}n${NC}${BOLD_CYAN} para escolher outro): ${NC}")" use_current_dir
    if [[ "$use_current_dir" == "s" || "$use_current_dir" == "S" || -z "$use_current_dir" ]]; then
      if mkdir -p "$diretorio_saida"; then # Verifica se ainda é válido
        echo -e "  ${BOLD_GREEN}👍 Usando diretório atual: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
        return 0
      else
        echo -e "  ${BOLD_RED}❌ Diretório atual '$diretorio_saida' não é mais acessível. Por favor, escolha novamente.${NC}"
        diretorio_saida="" # Força nova seleção
      fi
    else
      diretorio_saida="" # Usuário quer escolher outro
    fi
  fi

  # Se o diretório não estiver definido ou o usuário quiser alterar, executa a lógica de seleção original
  if _run_original_directory_selection_block; then
    return 0 # Sucesso, 'diretorio_saida' está definido globalmente
  else
    return 1 # Falha
  fi
}

# Função para opção 2: Baixar múltiplos vídeos
process_multiple_videos() {
  echo -e "\n${BOLD_YELLOW}🎬  Modo: Baixar múltiplos vídeos${NC}"
  local num_videos_requested
  while true; do
    read -p "$(echo -e "  ${BOLD_CYAN}🔢 Quantos vídeos deseja baixar (1-10)? ${NC}")" num_videos_requested
    if [[ "$num_videos_requested" =~ ^[1-9]$|^10$ ]]; then
      break
    else
      echo -e "  ${BOLD_RED}❌ Número inválido. Por favor, insira um número entre 1 e 10.${NC}"
    fi
  done

  local video_urls=()
  echo -e "\n${BOLD_WHITE}--- Insira as URLs dos vídeos ---${NC}"
  for i in $(seq 1 "$num_videos_requested"); do
    local temp_url
    read -p "$(echo -e "  ${BOLD_CYAN}🔗 URL do vídeo $i de $num_videos_requested: ${NC}")" temp_url
    if [[ -n "$temp_url" ]]; then
      video_urls+=("$temp_url")
    else
      echo -e "  ${BOLD_YELLOW}⚠️ URL não fornecida para o vídeo $i. Será ignorado.${NC}"
    fi
  done

  local num_urls_collected=${#video_urls[@]}
  if [[ "$num_urls_collected" -eq 0 ]]; then
    echo -e "  ${BOLD_RED}❌ Nenhuma URL válida foi fornecida. Retornando.${NC}"
    return 1
  fi

  local naming_choice
  echo # Linha em branco para legibilidade
  echo -e "  ${BOLD_CYAN}🏷️  Como deseja nomear os arquivos baixados?${NC}"
  echo -e "    ${BOLD_CYAN}(${NC}${BOLD_GREEN}t${NC}${BOLD_CYAN}) Usar ${BOLD_WHITE}títulos originais${NC} dos vídeos"
  echo -e "    ${BOLD_CYAN}(${NC}${BOLD_RED}s${NC}${BOLD_CYAN}) Renomear ${BOLD_WHITE}sequencialmente${NC} (ex: ex1.mp4, ex2.mp4, ...)"
  read -p "$(echo -e "  ${BOLD_LIGHT_BLUE}👉 Escolha uma opção [${NC}${BOLD_GREEN}t${NC}${BOLD_LIGHT_BLUE}]: ${NC}")" naming_choice

  if [[ "$naming_choice" != "s" && "$naming_choice" != "S" ]]; then
    naming_choice="t" # Padrão para títulos
  else
    naming_choice="s" # Explícito para sequencial
  fi

  echo -e "\n${BOLD_WHITE}--- Iniciando downloads de $num_urls_collected vídeo(s) ---${NC}"
  for idx in "${!video_urls[@]}"; do
    local current_url="${video_urls[$idx]}"
    local video_num=$((idx + 1)) # Índice 1-based para mensagens e nomeação "ex"

    echo -e "\n${BOLD_WHITE}--- Processando Vídeo $video_num de $num_urls_collected (${current_url}) ---${NC}"
    local nome_saida_multi

    if [[ "$naming_choice" == "t" ]]; then
      echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Obtendo título do vídeo...${NC}"
      local video_title_multi
      video_title_multi=$(yt-dlp --get-title "$current_url" 2>/dev/null)
      local sanitized_video_title_multi
      sanitized_video_title_multi=$(echo "$video_title_multi" | sed 's/[^a-zA-Z0-9._-]/_/g')
      nome_saida_multi="$sanitized_video_title_multi"
      if [[ -z "$nome_saida_multi" ]]; then
          nome_saida_multi="video_${video_num}_$(date +%s)" # Fallback
          echo -e "  ${BOLD_YELLOW}⚠️ Não foi possível obter o título. Usando nome padrão: ${nome_saida_multi}${NC}"
      fi
    else # naming_choice == "s" (sequencial)
      nome_saida_multi="ex${video_num}"
    fi

    local saida_completa_multi="${diretorio_saida}/${nome_saida_multi}.mp4"
    echo -e "${BOLD_GREEN}🔽  Baixando para ${saida_completa_multi}...${NC}"
    if yt-dlp --progress -f "bv*[ext=mp4][vcodec^=avc1]+ba[ext=m4a][acodec^=mp4a]/mp4" -o "$saida_completa_multi" "$current_url"; then
        echo -e "  ${BOLD_GREEN}✅ Vídeo $video_num salvo como: ${BOLD_CYAN}$saida_completa_multi${NC}"
    else
        echo -e "  ${BOLD_RED}❌ Erro ao baixar o vídeo $i.${NC}"
    fi
  done

  # Pergunta se deseja abrir no Finder (macOS) após todos os downloads
  if [[ "$num_urls_collected" -gt 0 ]]; then # Só pergunta se algum vídeo foi processado
    echo
    read -p "$(echo -e "${BOLD_CYAN}📂 Deseja abrir a pasta no ${BOLD_WHITE}Finder? ${BOLD_CYAN}(${BOLD_GREEN}s${BOLD_CYAN}/${BOLD_RED}n${BOLD_CYAN}): ${NC}")" abrir_finder_multi
    if [[ "$abrir_finder_multi" == "s" || "$abrir_finder_multi" == "S" || -z "$abrir_finder_multi" ]]; then
      open "$diretorio_saida"
    fi
  fi

}

# Função para opção 3: Baixar playlist
process_playlist() {
  # Helper function for sanitizing filenames within this function's scope
  _sanitize_playlist_filename() {
    echo "$1" | sed 's/[^a-zA-Z0-9._-]/_/g'
  }
  echo -e "\n${BOLD_YELLOW}🎶  Modo: Baixar playlist${NC}"
  local playlist_url
  read -p "$(echo -e "  ${BOLD_CYAN}🔗 URL da playlist do YouTube: ${NC}")" playlist_url
  if [[ -z "$playlist_url" ]]; then
    echo -e "  ${BOLD_RED}❌ URL da playlist não fornecida.${NC}"
    return 1
  fi

  echo
  echo -e "${BOLD_CYAN}🏷️  Como deseja nomear os arquivos da playlist?${NC}"
  echo -e "   ${BOLD_CYAN}1.${NC} ${BOLD_WHITE}Padrão (Ex: ${NC}${BOLD_YELLOW}01 - Título Original.mp4${NC}${BOLD_WHITE})${NC}"
  echo -e "   ${BOLD_CYAN}2.${NC} ${BOLD_WHITE}Apenas Título Original (Ex: ${NC}${BOLD_YELLOW}Título Original.mp4${NC}${BOLD_WHITE})${NC}"
  echo -e "   ${BOLD_CYAN}3.${NC} ${BOLD_WHITE}Prefixo Personalizado + Índice (Ex: ${NC}${BOLD_YELLOW}MinhaSerie_01.mp4${NC}${BOLD_WHITE})${NC}"
  echo -e "   ${BOLD_CYAN}4.${NC} ${BOLD_WHITE}Renomear cada vídeo individualmente (Interativo)${NC}"
  read -p "$(echo -e "${BOLD_LIGHT_BLUE}👉 Escolha uma opção [1]: ${NC}")" naming_choice_playlist

  local output_template
  local success_playlist_download=0 # 0 for success, 1 for failure

  case "$naming_choice_playlist" in
    2)
      output_template="${diretorio_saida}/%(_sanitize_playlist_filename(title))s.%(ext)s"
      echo -e "\n${BOLD_GREEN}🔽  Baixando playlist de ${playlist_url} usando TÍTULOS ORIGINAIS...${NC}"
      ;;
    3)
      local custom_prefix
      read -p "$(echo -e "  ${BOLD_CYAN}✏️ Digite o prefixo para os nomes dos arquivos (Ex: MinhaSerie_): ${NC}")" custom_prefix
      custom_prefix=$(_sanitize_playlist_filename "$custom_prefix")
      if [[ -z "$custom_prefix" ]]; then
        echo -e "  ${BOLD_YELLOW}⚠️ Prefixo vazio, usando 'video_' como padrão.${NC}"
        custom_prefix="video_"
      fi
      output_template="${diretorio_saida}/${custom_prefix}%(playlist_index)s.%(ext)s"
      echo -e "\n${BOLD_GREEN}🔽  Baixando playlist de ${playlist_url} usando prefixo '${custom_prefix}' e índice...${NC}"
      ;;
    4)
      echo -e "\n${BOLD_GREEN}🛠️  Modo de renomeação individual...${NC}"
      echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Obtendo lista de vídeos da playlist...${NC}"
      # Get video IDs and titles, using a very unlikely separator
      local video_infos_raw
      video_infos_raw=$(yt-dlp --flat-playlist --print "%(id)s::::%(title)s" "$playlist_url" 2>/dev/null)

      if [[ -z "$video_infos_raw" ]]; then
        echo -e "  ${BOLD_RED}❌ Não foi possível obter os itens da playlist. Verifique a URL ou a conexão.${NC}"
        success_playlist_download=1 # Mark as failed
      else
        local video_count
        video_count=$(echo "$video_infos_raw" | wc -l | awk '{print $1}') # Get line count
        local current_video_num=0
        local all_individual_downloads_successful=true

        # Save current IFS and set new one for the loop
        local old_ifs="$IFS"
        IFS=$'\n' # Process line by line
        for line in $video_infos_raw; do
          IFS="::::" read -r video_id original_title <<< "$line"
          IFS="$old_ifs" # Restore IFS immediately after read

          current_video_num=$((current_video_num + 1))
          local sanitized_original_title
          sanitized_original_title=$(_sanitize_playlist_filename "$original_title")
          if [[ -z "$sanitized_original_title" ]]; then
            sanitized_original_title="video_${current_video_num}_$(date +%s)"
          fi

          echo -e "\n${BOLD_WHITE}--- Vídeo $current_video_num de $video_count: ${BOLD_YELLOW}$original_title${NC} ---${NC}"
          local custom_name_no_ext
          read -p "$(echo -e "  ${BOLD_CYAN}✏️ Nome do arquivo (sem extensão, Enter para '${NC}${BOLD_GREEN}$sanitized_original_title${NC}${BOLD_CYAN}'): ${NC}")" custom_name_no_ext

          if [[ -z "$custom_name_no_ext" ]]; then
            custom_name_no_ext="$sanitized_original_title"
          else
            custom_name_no_ext=$(_sanitize_playlist_filename "$custom_name_no_ext")
          fi

          local final_output_path="${diretorio_saida}/${custom_name_no_ext}.%(ext)s"
          local video_full_url="https://www.youtube.com/watch?v=${video_id}"

          echo -e "  ${BOLD_GREEN}🔽 Baixando '${original_title}' para '${custom_name_no_ext}.mp4'...${NC}"
          if ! yt-dlp --progress -f "bv*[ext=mp4][vcodec^=avc1]+ba[ext=m4a][acodec^=mp4a]/mp4" -o "$final_output_path" "$video_full_url"; then
            echo -e "    ${BOLD_RED}❌ Erro ao baixar o vídeo: $original_title${NC}"
            all_individual_downloads_successful=false
          else
            echo -e "    ${BOLD_GREEN}✅ Salvo como: $(ls "${diretorio_saida}/${custom_name_no_ext}."* 2>/dev/null | head -n 1)${NC}"
          fi
        done
        IFS="$old_ifs" # Restore IFS after loop

        if ! $all_individual_downloads_successful; then
            success_playlist_download=1 # Mark as failed if any video failed
        fi
      fi
      ;;
    1|*) # Padrão (Índice - Título Original) ou qualquer outra entrada
      output_template="${diretorio_saida}/%(playlist_index)s - $(_sanitize_playlist_filename '%(title)s').%(ext)s"
      echo -e "\n${BOLD_GREEN}🔽  Baixando playlist de ${playlist_url} usando PADRÃO (Índice - Título)...${NC}"
      ;;
  esac

  if [[ "$naming_choice_playlist" != "4" ]]; then # Se não for renomeação individual, baixa a playlist de uma vez
    echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Os vídeos serão salvos em: ${BOLD_YELLOW}$(realpath "$diretorio_saida")${NC}"
    if yt-dlp --progress --yes-playlist -o "$output_template" -f "bv*[ext=mp4][vcodec^=avc1]+ba[ext=m4a][acodec^=mp4a]/mp4" "$playlist_url"; then
      echo -e "  ${BOLD_GREEN}✅ Download da playlist concluído (ou tentado).${NC}"
    else
      echo -e "  ${BOLD_RED}❌ Erro durante o download da playlist.${NC}"
      success_playlist_download=1
    fi
  fi

  # Pergunta se deseja abrir no Finder (macOS) após a tentativa de download da playlist
  if [[ -n "$playlist_url" ]]; then # Só pergunta se uma URL foi fornecida
    echo
    read -p "$(echo -e "${BOLD_CYAN}📂 Deseja abrir a pasta no ${BOLD_WHITE}Finder? ${BOLD_CYAN}(${BOLD_GREEN}s${BOLD_CYAN}/${BOLD_RED}n${BOLD_CYAN}): ${NC}")" abrir_finder_playlist
    if [[ "$abrir_finder_playlist" == "s" || "$abrir_finder_playlist" == "S" || -z "$abrir_finder_playlist" ]]; then
      open "$diretorio_saida"
    fi
  fi
}

# Função para opção 4: Baixar música
process_music() {
  echo -e "\n${BOLD_YELLOW}🎵  Modo: Baixar música (MP3)${NC}"
  local video_url_music
  read -p "$(echo -e "  ${BOLD_CYAN}🎥 URL do vídeo do YouTube para extrair áudio: ${NC}")" video_url_music
  if [[ -z "$video_url_music" ]]; then
    echo -e "  ${BOLD_RED}❌ URL do vídeo não fornecida.${NC}"
    return 1
  fi

  local nome_saida_audio
  read -p "$(echo -e "  ${BOLD_LIGHT_BLUE}💾 Nome do arquivo de saída para o áudio (sem extensão, Enter para usar título do vídeo): ${NC}")" nome_saida_audio

  if [[ -z "$nome_saida_audio" ]]; then
    echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Obtendo título do vídeo para nome do arquivo...${NC}"
    nome_saida_audio=$(yt-dlp --get-title "$video_url_music" 2>/dev/null)
    nome_saida_audio=$(echo "$nome_saida_audio" | sed 's/[^a-zA-Z0-9._-]/_/g') # Sanitize
    if [[ -z "$nome_saida_audio" ]]; then
        nome_saida_audio="audio_extraido_$(date +%s)"
        echo -e "  ${BOLD_YELLOW}⚠️ Não foi possível obter o título. Usando nome padrão: ${nome_saida_audio}${NC}"
    fi
  fi
  
  local saida_completa_audio="${diretorio_saida}/${nome_saida_audio}.mp3"

  echo -e "${BOLD_GREEN}🔽  Baixando e convertendo ${video_url_music} para MP3...${NC}"
  if yt-dlp --progress -x --audio-format mp3 -o "$saida_completa_audio" "$video_url_music"; then
    echo -e "  ${BOLD_GREEN}✅ Áudio salvo como: ${BOLD_CYAN}$saida_completa_audio${NC}"
  else
    echo -e "  ${BOLD_RED}❌ Erro ao baixar ou converter o áudio.${NC}"
  fi

  # Pergunta se deseja abrir no Finder (macOS) após a tentativa de download da música
  if [[ -n "$video_url_music" ]]; then # Só pergunta se uma URL foi fornecida
    echo
    read -p "$(echo -e "${BOLD_CYAN}📂 Deseja abrir a pasta no ${BOLD_WHITE}Finder? ${BOLD_CYAN}(${BOLD_GREEN}s${BOLD_CYAN}/${BOLD_RED}n${BOLD_CYAN}): ${NC}")" abrir_finder_music
    if [[ "$abrir_finder_music" == "s" || "$abrir_finder_music" == "S" || -z "$abrir_finder_music" ]]; then
      open "$diretorio_saida"
    fi
  fi
}

# --- Início do Script Principal ---
clear_and_show_title

# Variável global para o diretório de saída. Será definida por _run_original_directory_selection_block ou ensure_output_directory_is_set
diretorio_saida="" 

while true; do
  clear_and_show_title
  echo -e "${BOLD_YELLOW}🌟  Menu Principal  🌟${NC}"
  echo
  echo -e "   ${BOLD_CYAN}1.${NC} ${BOLD_WHITE}Baixar 1 vídeo ${BOLD_GREEN}(com opções de corte)${NC}"
  echo
  echo -e "   ${BOLD_CYAN}2.${NC} ${BOLD_WHITE}Baixar vários vídeos ${BOLD_GREEN}(sequencialmente)${NC}"
  echo
  echo -e "   ${BOLD_CYAN}3.${NC} ${BOLD_WHITE}Baixar ${BOLD_GREEN}playlist ${BOLD_WHITE}inteira${NC}"
  echo
  echo -e "   ${BOLD_CYAN}4.${NC} ${BOLD_WHITE}Baixar música ${BOLD_GREEN}(converter vídeo para MP3)${NC}"
  echo
  echo -e "   ${BOLD_CYAN}5.${NC} ${BOLD_RED}Sair${NC}"
  echo
  read -p "$(echo -e "${BOLD_LIGHT_BLUE}👉  Escolha uma opção: ${NC}")" main_choice

  # Se o usuário pressionar Enter, assume a opção 1
  if [[ -z "$main_choice" ]]; then
    main_choice="1"
  fi

  case "$main_choice" in
    1)
      # Para a opção 1, executa a lógica original de seleção de diretório e depois o loop de download de vídeo único.
      if ! _run_original_directory_selection_block; then
        echo -e "  ${BOLD_RED}❌ Seleção de diretório falhou ou foi cancelada. Retornando ao menu principal.${NC}"
        sleep 2
        continue # Volta para o loop do menu principal
      fi
      # Agora 'diretorio_saida' está definido globalmente.
      # O bloco abaixo é o loop de processamento de vídeo original (linhas 295-418 do script original)
      # --- Início do loop de processamento de vídeo original ---
      while true; do
  # Prompts de entrada do usuário com cores específicas
  read -p "$(echo -e "${BOLD_CYAN}🎥  ${NC}${BOLD_CYAN}URL${NC} ${BOLD_WHITE}do vídeo do ${NC}${BOLD_RED}YouTube${NC}${BOLD_WHITE}:${NC}${BOLD_CYAN}  🔗 ${NC}")" video_url

  echo
  read -p "$(echo -e "${BOLD_YELLOW}🎬 Baixar o vídeo desde o início? ${NC}${BOLD_CYAN}(${NC}${BOLD_GREEN}s${NC}${BOLD_CYAN}/${NC}${BOLD_RED}n${NC}${BOLD_CYAN}): ${NC}")" usar_inicio_padrao

  if [[ -z "$usar_inicio_padrao" || "$usar_inicio_padrao" == "s" || "$usar_inicio_padrao" == "S" ]]; then
    inicio="" # yt-dlp interpreta como início do vídeo
    echo
    echo -e "  ${BOLD_GREEN}▶️  (Início definido para o começo do vídeo)${NC}"
  else
    echo
    read -p "$(echo -e "${BOLD_GREEN}▶️  ${NC}${BOLD_GREEN}Início${NC}${BOLD_WHITE} do clipe ${NC}${BOLD_CYAN}(formato HH:MM:SS)${NC}${BOLD_GREEN}:  ▶️  ${NC}")" inicio
  fi

  echo
  read -p "$(echo -e "${BOLD_RED}⏹️  Fim ${BOLD_WHITE}do clipe ${BOLD_CYAN}(formato HH:MM:SS, Enter para final do vídeo): ⏹️  ${NC}")" fim
  if [[ -z "$fim" ]]; then
    echo
    echo -e "  ${BOLD_RED}⏹️  (Fim definido para o final do vídeo)${NC}"
  fi


  echo
  read -p "$(echo -e "${BOLD_YELLOW}💾  Usar o título original do vídeo como nome do arquivo? ${NC}${BOLD_CYAN}(${NC}${BOLD_GREEN}S${NC}${BOLD_CYAN}/${NC}${BOLD_RED}n${NC}${BOLD_CYAN}): ${NC}")" usar_titulo_video

  if [[ -z "$usar_titulo_video" || "$usar_titulo_video" == "s" || "$usar_titulo_video" == "S" ]]; then
    # Obter o título do vídeo do YouTube SOMENTE se o usuário escolher usá-lo
    echo
    echo -e "  ${BOLD_LIGHT_BLUE}ℹ️  Obtendo título do vídeo... ℹ️${NC}"
    video_title=$(yt-dlp --get-title "$video_url")
    sanitized_video_title=$(echo "$video_title" | sed 's/[^a-zA-Z0-9._-]/_/g') # Sanitiza o título para nome de arquivo seguro
    nome_saida="$sanitized_video_title"
    echo
    echo -e "  ${BOLD_GREEN}👍 Nome do arquivo definido como: ${BOLD_WHITE}$nome_saida${NC}"
    # Verifica se o nome_saida ficou vazio (caso yt-dlp falhe em obter o título)
    if [[ -z "$nome_saida" ]]; then
      echo -e "  ${BOLD_RED}⚠️ Não foi possível obter o título do vídeo. Por favor, insira um nome manualmente.${NC}"
      read -p "$(echo -e "  ${BOLD_LIGHT_BLUE}💾  Nome do arquivo de saída: 💾 ${NC}")" nome_saida
    fi
  else
    read -p "$(echo -e "${BOLD_LIGHT_BLUE}💾  Nome do arquivo de saída: 💾 ${NC}")" nome_saida
  fi

  # Define nome do arquivo temporário
  nome_base="clipe_youtube_temp_$$" # Adiciona PID para evitar conflitos se rodar em paralelo (improvável aqui)
  saida="${nome_saida}.mp4"
  saida_completa="${diretorio_saida}/${saida}"

  # Baixa o trecho com codecs compatíveis
  echo

  # Define as mensagens de início e fim para o feedback ao usuário
  inicio_msg_feedback="${inicio:-início do vídeo}" # Usa "início do vídeo" se $inicio estiver vazio
  fim_msg_feedback="${fim:-final do vídeo}"     # Usa "final do vídeo" se $fim estiver vazio

  echo -e "${BOLD_GREEN}🔽  Baixando o trecho de ${BOLD_YELLOW}$inicio_msg_feedback até ${BOLD_YELLOW}$fim_msg_feedback... 🔽 ${NC}"

  # Prepara o argumento --download-sections condicionalmente
  download_sections_opt=() # Inicializa como um array vazio
  if [[ -n "$inicio" && -z "$fim" ]]; then
    # Início especificado, fim é o final do vídeo (Enter no prompt de fim)
    # Formato yt-dlp: *HH:MM:SS
    download_sections_opt=(--download-sections "*$inicio")
  elif [[ -z "$inicio" && -n "$fim" ]]; then
    # Início é o começo do vídeo, fim especificado
    # Formato yt-dlp: *-HH:MM:SS
    download_sections_opt=(--download-sections "*-$fim")
  elif [[ -n "$inicio" && -n "$fim" ]]; then
    # Ambos início e fim especificados
    # Formato yt-dlp: *HH:MM:SS-HH:MM:SS
    download_sections_opt=(--download-sections "*$inicio-$fim")
  # Se ambos $inicio e $fim forem vazios, download_sections_opt permanece vazio.
  # Nesse caso, yt-dlp baixará o vídeo inteiro por padrão, que é o comportamento desejado
  # e corrige o erro "invalid --download-sections time range '*-'".
  fi

  # Constrói a lista de argumentos para yt-dlp
  yt_dlp_cmd_args=()
  yt_dlp_cmd_args+=(--progress)

  # Adiciona a opção de seções de download se ela foi definida
  if [[ ${#download_sections_opt[@]} -gt 0 ]]; then
    yt_dlp_cmd_args+=("${download_sections_opt[@]}")
  fi

  yt_dlp_cmd_args+=(-f "bv*[ext=mp4][vcodec^=avc1]+ba[ext=m4a][acodec^=mp4a]/mp4")
  yt_dlp_cmd_args+=(-o "${diretorio_saida}/${nome_base}.%(ext)s") # Salva diretamente no diretório de saída com nome temporário
  yt_dlp_cmd_args+=("$video_url")

  # Executa o comando yt-dlp
  if ! yt-dlp "${yt_dlp_cmd_args[@]}"; then
    echo -e "  ${BOLD_RED}❌ Erro durante o download com yt-dlp.${NC}"
  fi

  # Localiza o arquivo baixado
  arquivo_temp=$(ls "${diretorio_saida}/${nome_base}."* 2>/dev/null | head -n 1)

  if [[ -z "$arquivo_temp" || ! -f "$arquivo_temp" ]]; then
    echo -e "  ${BOLD_RED}❌ Erro: Arquivo baixado (${diretorio_saida}/${nome_base}.*) não encontrado. O download pode ter falhado ou foi interrompido.${NC}"
  else
    # Renomeia e move para o diretório de destino
    if mv "$arquivo_temp" "$saida_completa"; then
      # Confirmação
      echo -e "--------------------------"
      echo -e "\n${BOLD_GREEN}✅ ${BOLD_GREEN}Clipe ${BOLD_GREEN}salvo como:${BOLD_CYAN} $saida_completa${NC}"
      echo
      echo -e "${BOLD_GREEN}📁  ${BOLD_YELLOW}Diretório onde o clipe foi salvo:${NC}\n  ${BOLD_LIGHT_BLUE}$(realpath "$diretorio_saida")${NC}"

      # Pergunta se deseja abrir no Finder (macOS)
      echo
      read -p "$(echo -e "${BOLD_CYAN}📂 Deseja abrir a pasta no ${BOLD_WHITE}Finder? ${BOLD_CYAN}(${BOLD_GREEN}s${BOLD_CYAN}/${BOLD_RED}n${BOLD_CYAN}): ${NC}")" abrir_finder
      if [[ "$abrir_finder" == "s" || "$abrir_finder" == "S" || -z "$abrir_finder" ]]; then
        open "$diretorio_saida"
      fi
    else
      echo -e "  ${BOLD_RED}❌ Erro ao renomear/mover o arquivo baixado de '$arquivo_temp' para '$saida_completa'. Verifique as permissões.${NC}"
    fi
  fi

  echo
  read -p "$(echo -e "${BOLD_YELLOW}🔄  Deseja baixar outro vídeo? ${NC}${BOLD_CYAN}(${NC}${BOLD_GREEN}s${NC}${BOLD_CYAN}/${NC}${BOLD_RED}n${NC}${BOLD_CYAN}): ${NC}")" continuar
  if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
    break
  fi
  echo -e "${BOLD_RED}-----------------------------------------------------${NC}"
  echo      
done
      # --- Fim do loop de processamento de vídeo original ---
      ;;
    2)
      if ! ensure_output_directory_is_set; then
        echo -e "  ${BOLD_RED}❌ Seleção de diretório cancelada ou falhou. Retornando ao menu principal.${NC}"
        sleep 2
        continue
      fi
      process_multiple_videos
      ;;
    3)
      if ! ensure_output_directory_is_set; then
        echo -e "  ${BOLD_RED}❌ Seleção de diretório cancelada ou falhou. Retornando ao menu principal.${NC}"
        sleep 2
        continue
      fi
      process_playlist
      ;;
    4)
      if ! ensure_output_directory_is_set; then
        echo -e "  ${BOLD_RED}❌ Seleção de diretório cancelada ou falhou. Retornando ao menu principal.${NC}"
        sleep 2
        continue
      fi
      process_music
      ;;
    5)
      echo -e "\n${BOLD_GREEN}👋 Saindo do script...${NC}"
      break # Sai do loop do menu principal
      ;;
    *)
      echo -e "  ${BOLD_RED}❌ Opção inválida. Tente novamente.${NC}"
      sleep 2
      ;;
  esac

  if [[ "$main_choice" != "5" ]]; then
    echo
    read -p "$(echo -e "${BOLD_YELLOW}🔄  Voltar ao menu principal? ${NC}${BOLD_CYAN}(${NC}${BOLD_GREEN}s${NC}${BOLD_CYAN}/${NC}${BOLD_RED}n${NC}${BOLD_CYAN} para sair): ${NC}")" continue_main_menu
    if [[ "$continue_main_menu" == "n" || "$continue_main_menu" == "N" ]]; then
      echo -e "\n${BOLD_GREEN}👋 Saindo do script...${NC}"
      break # Sai do loop do menu principal
    fi
    # Se for 's', 'S' ou Enter, o loop continua automaticamente.
  fi
done

echo -e "\n${BOLD_GREEN}👋 Script finalizado. Obrigado por usar!${NC}\n"
