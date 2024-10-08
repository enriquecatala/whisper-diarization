<h1 align="center">Speaker Diarization Using OpenAI Whisper</h1>
<p align="center">
  <a href="https://github.com/MahmoudAshraf97/whisper-diarization/stargazers">
    <img src="https://img.shields.io/github/stars/MahmoudAshraf97/whisper-diarization.svg?colorA=orange&colorB=orange&logo=github"
         alt="GitHub stars">
  </a>
  <a href="https://github.com/MahmoudAshraf97/whisper-diarization/issues">
        <img src="https://img.shields.io/github/issues/MahmoudAshraf97/whisper-diarization.svg"
             alt="GitHub issues">
  </a>
  <a href="https://github.com/MahmoudAshraf97/whisper-diarization/blob/master/LICENSE">
        <img src="https://img.shields.io/github/license/MahmoudAshraf97/whisper-diarization.svg"
             alt="GitHub license">
  </a>
  <a href="https://twitter.com/intent/tweet?text=&url=https%3A%2F%2Fgithub.com%2FMahmoudAshraf97%2Fwhisper-diarization">
  <img src="https://img.shields.io/twitter/url/https/github.com/MahmoudAshraf97/whisper-diarization.svg?style=social" alt="Twitter">
  </a> 
  </a>
  <a href="https://colab.research.google.com/github/MahmoudAshraf97/whisper-diarization/blob/main/Whisper_Transcription_%2B_NeMo_Diarization.ipynb">
  <img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open in Colab">
  </a>
 
</p>


# 
Speaker Diarization pipeline based on OpenAI Whisper
I'd like to thank [@m-bain](https://github.com/m-bain) for Batched Whisper Inference, [@mu4farooqi](https://github.com/mu4farooqi) for punctuation realignment algorithm

<img src="https://github.blog/wp-content/uploads/2020/09/github-stars-logo_Color.png" alt="drawing" width="25"/> **Please, star the project on github (see top-right corner) if you appreciate my contribution to the community!**

## What is it
This repository combines Whisper ASR capabilities with Voice Activity Detection (VAD) and Speaker Embedding to identify the speaker for each sentence in the transcription generated by Whisper. First, the vocals are extracted from the audio to increase the speaker embedding accuracy, then the transcription is generated using Whisper, then the timestamps are corrected and aligned using WhisperX to help minimize diarization error due to time shift. The audio is then passed into MarbleNet for VAD and segmentation to exclude silences, TitaNet is then used to extract speaker embeddings to identify the speaker for each segment, the result is then associated with the timestamps generated by WhisperX to detect the speaker for each word based on timestamps and then realigned using punctuation models to compensate for minor time shifts.


WhisperX and NeMo parameters are coded into diarize.py and helpers.py, I will add the CLI arguments to change them later
## Installation
`FFMPEG` and `miniconda` are needed as prerequisites to install the requirements
```
# on Ubuntu or Debian
sudo apt update && sudo apt install ffmpeg

# on Arch Linux
sudo pacman -S ffmpeg

# on MacOS using Homebrew (https://brew.sh/)
brew install ffmpeg

# on Windows using Chocolatey (https://chocolatey.org/)
choco install ffmpeg

# on Windows using Scoop (https://scoop.sh/)
scoop install ffmpeg

# on Windows using WinGet (https://github.com/microsoft/winget-cli)
winget install ffmpeg
```

### Installation using conda

```
conda env create -f environment.yml
```
## Usage 
Available models: tiny.en, tiny, base.en, base, small.en, small, medium.en, medium, large-v1, large-v2, large-v3, large
```
python diarize.py -a AUDIO_FILE_NAME 
python diarize.py --whisper-model medium --language es -a AUDIO_FILE_NAME # for spanish
python diarize.py --whisper-model small.en -a AUDIO_FILE_NAME                 # english works well with base
```

## Command Line Options

- `-a AUDIO_FILE_NAME`: The name of the audio file to be processed
- `--no-stem`: Disables source separation
- `--whisper-model`: The model to be used for ASR, default is `medium.en`
- `--suppress_numerals`: Transcribes numbers in their pronounced letters instead of digits, improves alignment accuracy
- `--device`: Choose which device to use, defaults to "cuda" if available
- `--language`: Manually select language, useful if language detection failed
- `--batch-size`: Batch size for batched inference, reduce if you run out of memory, set to 0 for non-batched inference

### Export audio from video

```bash
ffmpeg -i video.mp4 -vn -acodec pcm_s16le -ar 44100 -ac 2 audio/audio.wav
ffmpeg -i video.mp4 -vn -acodec aac -ar 44100 -ac 2 audio/audio.m4a

```

If you want to convert multiple .mp4 inside a folder you can use the following script
```bash
./convert_mp4_to_mp3.sh /path/to/video /path/to/audio
```

## Prompts to get summary from the output

### Prompt for Summary to Save in Your Notes

---Please provide a comprehensive summary of the meeting, including the main points discussed, key decisions made, action items assigned, and any important deadlines. Highlight any critical insights or strategic directions mentioned during the meeting. Additionally, include any follow-up actions required and the responsible parties. Write it like if it was me writing the notes, I´m Enrique.

### Prompt for Summary to Share with Participants

---Please provide a concise summary of our meeting for distribution to all participants. Include the main topics covered, key decisions made, action items assigned, and respective deadlines. Highlight any important insights or agreements reached. Ensure that the summary is clear and actionable for all attendees. Write it like if it was me writing the notes, , I´m Enrique.

## Known Limitations
- Overlapping speakers are yet to be addressed, a possible approach would be to separate the audio file and isolate only one speaker, then feed it into the pipeline but this will need much more computation
- There might be some errors, please raise an issue if you encounter any.

## Future Improvements
- Implement a maximum length per sentence for SRT

## Acknowledgements
Special Thanks for [@adamjonas](https://github.com/adamjonas) for supporting this project
This work is based on [OpenAI's Whisper](https://github.com/openai/whisper) , [Faster Whisper](https://github.com/guillaumekln/faster-whisper) , [Nvidia NeMo](https://github.com/NVIDIA/NeMo) , and [Facebook's Demucs](https://github.com/facebookresearch/demucs)
