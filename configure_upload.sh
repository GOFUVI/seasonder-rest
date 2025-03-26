#!/bin/bash

# Base endpoint configuration
BASE_URL="http://localhost:8001"

# Define options (except pattern_path)
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
  ["discard"]="low_SNR,no_solution"
  ["doppler_interpolation"]="2"
  ["MUSIC_parameters"]="40,20,2,20"
)

# Update each option using the /config endpoint
for key in "${!OPTIONS[@]}"; do
    value="${OPTIONS[$key]}"
    echo "Updating $key to $value"
    curl -X PUT "$BASE_URL/config?key=$key&value=$value" -s
    echo ""
done

# Remove argument validation and assign placeholder for the pattern file
PATTERN_FILE="/path/to/your_pattern.txt"

if [ ! -f "$PATTERN_FILE" ]; then
    echo "The file $PATTERN_FILE does not exist."
    exit 1
fi

echo "Uploading pattern file: $PATTERN_FILE"
curl -X POST -F "file=@${PATTERN_FILE}" "$BASE_URL/upload_pattern"
echo ""