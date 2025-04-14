#!/bin/bash
# ---------------------------------------------------------------------------
# Script: process_files.sh
# Description: Processes .css, .cs4, and .csr files by sending them via HTTP POST
#              to a fixed endpoint (/process_css), changes the file extension to .ruv,
#              and saves the response in the output directory.
#
# Usage: process_files.sh [-h] [-o output_dir] [-i input_dir] [-p port] [-s server_addr]
#   -h: Display this help message.
#   -o: Specify output directory (default: current directory '.').
#   -i: Specify input directory (default: './').
#   -p: Specify port (default: 8000).
#   -s: Specify server address (default: http://localhost:PORT).
#
# Example:
#   ./process_files.sh -o ./output -i ./input -p 8080 -s http://myserver.com
# ---------------------------------------------------------------------------

PORT=8000
input_dir="./"
output_dir="."             # default output directory
server_addr=""  # will set default server address later if not provided with -s

# Parsing options including help option
while getopts "ho:i:p:s:" opt; do
    case $opt in
        h)
            echo "Usage: $0 [-h] [-o output_dir] [-i input_dir] [-p port] [-s server_addr]"
            echo "  -h  : Display this help message."
            echo "  -o  : Output directory (default: .)"
            echo "  -i  : Input directory (default: ./)"
            echo "  -p  : Port (default: 8000)"
            echo "  -s  : Server address (default: http://localhost:PORT)"
            exit 0
            ;;
        o) output_dir="$OPTARG" ;;
        i) input_dir="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        s) server_addr="$OPTARG" ;;
        *) ;; 
    esac
done
shift $((OPTIND - 1))
if [ -z "$server_addr" ]; then
    server_addr="http://localhost:$PORT"
fi
# Construct server URL with fixed endpoint /process_css using the provided server address
server_url="${server_addr%/}/process_css"

# Process files: .css, .cs4, and .csr
for file in "$input_dir"/*.css "$input_dir"/*.cs4 "$input_dir"/*.csr; do
    [ -e "$file" ] || continue
    if [ -f "$file" ]; then
        base=$(basename "$file")
        # Change file extension to .ruv and use the specified output directory
        output="${output_dir}/${base%.*}.ruv"
        echo "Processing $file..."
        # POST the file via curl and save the response
        curl -X POST "$server_url" -F "file=@${file}" -o "$output"
        echo "Saved to $output"
    fi
done