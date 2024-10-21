import os
import numpy as np
import librosa

DATA_DIR = 'processed_clips'  # folder with preprocessed audio files in .wav format
OUTPUT_DIR = 'features'        # folder for saving extracted features

# Create output folder if it doesn't exist
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Extract MFCC features from an audio file
def extract_mfcc(wav_file, sample_rate=16000, n_mfcc=13):
    y, sr = librosa.load(wav_file, sr=sample_rate)
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=n_mfcc)
    return mfccs

# Main function to extract features and save them as .npy files
def process_and_save_features():
    for root, dirs, files in os.walk(DATA_DIR):
        for file in files:
            if file.endswith('.wav'):
                file_path = os.path.join(root, file)
                # Here you keep the base name without extension for .npy file
                file_name = os.path.splitext(file)[0]  

                try:
                    # Extract MFCC features
                    mfccs = extract_mfcc(file_path)

                    # Save features as a .npy file with the same base name
                    np.save(os.path.join(OUTPUT_DIR, f'{file_name}.npy'), mfccs)

                    print(f"Features extracted and saved for {file}")

                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

if __name__ == "__main__":
    print("Starting feature extraction...")
    process_and_save_features()
    print("Feature extraction completed.")
