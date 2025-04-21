#!/bin/bash
# ---------------------------------------------------------------------------
# Script: configure_seasonder.sh
# Description: Updates server configuration parameters via the /config endpoint
#              and uploads a pattern file via the /upload_pattern endpoint.
#
# Usage: configure_seasonder.sh [-h] [-p port] [-s server_addr] [-f pattern_file] [-o key=value]
#   -h: Display this help message.
#   -p: Specify port (default: 8000).
#   -s: Specify server address (default: http://localhost:PORT).
#   -f: Specify pattern file path (default: ./MeasPattern.txt).
#   -o: Override OPTIONS key with key=value (can be used multiple times).
#
# Example:
#   ./configure_seasonder.sh -p 8080 -s http://myserver.com -f ./my_pattern.txt -o nsm=3 -o fdown=15
# ---------------------------------------------------------------------------

PORT=8000
server_addr=""     # Will set default later if not provided
PATTERN_FILE="./MeasPattern.txt"  # default pattern file
# Inicializar array para opciones del usuario
user_options=()

# Define opciones predeterminadas
declare -A OPTIONS=(
  ["nsm"]="2"
  ["fdown"]="10"
  ["flim"]="100"
  ["noisefact"]="3.981072"
  ["currmax"]="2.0"
  ["reject_distant_bragg"]="TRUE"
  ["reject_noise_ionospheric"]="TRUE"
  ["reject_noise_ionospheric_threshold"]="0"
  ["COMPUTE_FOR"]="FALSE"
  ["PPMIN"]="5"
  ["PPMAX"]="50"
  ["smoothNoiseLevel"]="FALSE"
  ["doppler_interpolation"]="2"
  ["MUSIC_parameters"]="40,20,2,20"
  ["discard_no_solution"]="TRUE"
  ["discard_low_SNR"]="TRUE"
)

# Parse options con flag -o para opciones personalizadas
while getopts "hp:s:f:o:" opt; do
    case $opt in
        h)
            echo "Usage: $0 [-h] [-p port] [-s server_addr] [-f pattern_file] [-o key=value]"
            echo "  -h  : Display this help message."
            echo "  -p  : Port (default: 8000)."
            echo "  -s  : Server address (default: http://localhost:PORT)."
            echo "  -f  : Pattern file path (default: ./MeasPattern.txt)."
            echo "  -o  : Override OPTIONS key with key=value (can be used multiple times)."
            echo ""
            echo "Defaults for OPTIONS:"
            for key in "${!OPTIONS[@]}"; do
                echo "  $key=${OPTIONS[$key]}"
            done
            exit 0
            ;;
        p) PORT="$OPTARG" ;;
        s) server_addr="$OPTARG" ;;
        f) PATTERN_FILE="$OPTARG" ;;
        o) user_options+=("$OPTARG") ;;
        *) ;;
    esac
done
shift $((OPTIND - 1))
if [ -z "$server_addr" ]; then
    server_addr="http://localhost:$PORT"
fi
BASE_URL="${server_addr%/}"

# Aplicar opciones de usuario sobre las predeterminadas
for kv in "${user_options[@]}"; do
    key="${kv%%=*}"
    value="${kv#*=}"
    OPTIONS["$key"]="$value"
done

# Agregar función para URL-encode
urlencode() {
    local string="${1}"
    local length="${#string}"
    local encoded=""
    local pos c
    for (( pos=0; pos<length; pos++ )); do
        c="${string:pos:1}"
        case "$c" in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            ' ') encoded+='%20' ;;
            *) encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    echo "$encoded"
}

# Update each option using the /config endpoint
for key in "${!OPTIONS[@]}"; do
    value="${OPTIONS[$key]}"
    echo "Updating $key to $value"
    encoded_value=$(urlencode "$value")
    curl -X PUT "$BASE_URL/config?key=$key&value=$encoded_value" -s
    echo ""
done

# Check if the pattern file exists
if [ ! -f "$PATTERN_FILE" ]; then
    echo "The file $PATTERN_FILE does not exist."
    exit 1
fi

echo "Uploading pattern file: $PATTERN_FILE"
curl -X POST -F "file=@${PATTERN_FILE}" "$BASE_URL/upload_pattern"
echo ""
