#!/bin/bash

#  Enrique Catalá:
#    Web:      https://www.clouddataninjas.com
#    Linkedin: https://www.linkedin.com/in/enriquecatala/
#    Support:  https://github.com/sponsors/enriquecatala
#
# ./convert_mp4_to_mp3.sh /path/to/videos /path/to/audio
#

# Check if at least one parameter is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <video_directory> [audio_directory]"
    exit 1
fi

# Directory containing the .mp4 files, provided as the first parameter
video_dir="$1"

# Optional audio directory as the second parameter, default is './audio'
audio_dir="${2:-./audio}"

# Create the audio directory if it doesn't exist
mkdir -p "$audio_dir"

# Loop through each .mp4 file in the video directory
for video_file in "$video_dir"/*.mp4; do
    # Extract the filename without the extension
    base_name=$(basename "$video_file" .mp4)
    
    # Replace spaces with underscores in the filename
    output_name="${base_name// /_}.wav"

    # Run ffmpeg to convert the video file to audio
    # using 16000 since its the best Hz to input into whisper ai
    ffmpeg -i "$video_file" -vn -acodec pcm_s16le -ar 16000 -ac 2 "$audio_dir/$output_name"
done
