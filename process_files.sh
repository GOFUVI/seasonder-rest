#!/bin/bash


input_dir="./"
server_url="http://localhost:8001/process_css"

for file in "$input_dir"/*; do
    if [ -f "$file" ]; then
        base=$(basename "$file")
        # Cambiar la extensión a .ruv
        output="${file%.*}.ruv"
        echo "Procesando $file..."
        # Realiza el POST con curl, enviando el fichero y guardando la respuesta
        curl -X POST "$server_url" -F "file=@${file}" -o "$output"
        echo "Guardado en $output"
    fi
done