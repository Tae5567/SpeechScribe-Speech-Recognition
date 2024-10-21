#Preprocess audio files by: 
# normalizing volume, 
# removing silence and 
# converting them to a uniform format (WAV)

import os
import librosa
import numpy as np
from pydub import AudioSegment
import soundfile as sf

# Set audio files folder paths
DATA_DIR = 'clips'  # Folder with input audio files
OUTPUT_DIR = 'processed_clips'  # Folder for processed audio files
TARGET_SAMPLE_RATE = 16000 # Target sample rate for consistency

# Create output folder if it doesn't exist
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

#Convert audio files from mp3 to wav
def convert_to_wav(mp3_file, output_file):
    """
    Convert the input audio file to .wav format using pydub
    If the file is already .wav, return the original path.
    """
    audio = AudioSegment.from_mp3(mp3_file)
    audio.export(output_file, format="wav")
    return output_file

def normalize_audio(audio):
    """
    Normalize the audio volume level using pydub
    """
    return audio.apply_gain(-audio.max_dBFS)

def remove_silence(audio_file, sample_rate=TARGET_SAMPLE_RATE):
    """
    Remove silence from the audio using librosa
    """
    y, sr = librosa.load(audio_file, sr=sample_rate)
    yt, index = librosa.effects.trim(y, top_db=20)  # Adjust top_db as needed
    return yt, sr

def preprocess_audio(file_path):
    """
    Main preprocessing pipeline for each audio file
    """
    try:
        # Convert MP3 to WAV
        filename = os.path.basename(file_path)
        wav_file_path = os.path.join(OUTPUT_DIR, filename.replace('.mp3', '.wav'))
        wav_file_path = convert_to_wav(file_path, wav_file_path)

        # Load the audio file and normalize volume
        audio = AudioSegment.from_wav(wav_file_path)
        normalized_audio = normalize_audio(audio)

        # Save normalized audio temporarily
        temp_wav_file = wav_file_path.replace('.wav', '_normalized.wav')
        normalized_audio.export(temp_wav_file, format='wav')

        # Remove silence
        trimmed_audio, sr = remove_silence(temp_wav_file)

        # Resample to target sample rate
        resampled_audio = librosa.resample(trimmed_audio, orig_sr=sr, target_sr=TARGET_SAMPLE_RATE)


        # Save the preprocessed audio
        sf.write(wav_file_path, resampled_audio, TARGET_SAMPLE_RATE)
        print(f"Processed {file_path} -> {wav_file_path}")

        # Clean up temporary files
        os.remove(temp_wav_file)
        
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def batch_preprocess():
    """
    Batch preprocess all files in the data director
    """
    for root, dirs, files in os.walk(DATA_DIR):
        for file in files:
            if file.endswith('.mp3'):
                file_path = os.path.join(root, file)
                preprocess_audio(file_path)

if __name__ == "__main__":
    print("Starting preprocessing...")
    batch_preprocess()
    print("Preprocessing completed.")