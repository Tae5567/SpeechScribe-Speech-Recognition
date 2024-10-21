import os
import pandas as pd

# Define paths
TSV_FILE = 'train.tsv'  # Use train.tsv for supervised learning
FEATURES_DIR = 'features'
OUTPUT_CSV = 'aligned_data.csv'  # Output file with aligned audio paths and transcriptions

# Load the .tsv file
def load_tsv(tsv_file):
    df = pd.read_csv(tsv_file, sep='\t')
    return df

# Filter and match the audio file paths with transcriptions
def match_npy_with_transcriptions(df, features_dir):
    aligned_data = []
    
    # Get a list of all .npy files in the features directory
    npy_files = set(os.listdir(features_dir))
    
    for index, row in df.iterrows():
        # Extract base filename (e.g., common_voice_en_123456 from 'path' column in .tsv)
        base_filename = row['path'].replace('.mp3', '.wav')  # Handle .mp3 to .wav conversion
        npy_file = f"{base_filename}.npy"  # Expected .npy feature file
        full_npy_path = os.path.join(features_dir, npy_file)
        
        print(f"Checking for feature file: {full_npy_path}")  # Debugging line
        
        if npy_file in npy_files:  # Check if the .npy file exists
            aligned_data.append([npy_file, row['sentence']])
        else:
            print(f"Feature file {npy_file} not found, skipping.")

    return pd.DataFrame(aligned_data, columns=['filename', 'transcription'])

# Main function to process and save the aligned data
def process_and_save_aligned_data(tsv_file, features_dir, output_csv):
    # Load the .tsv file
    df = load_tsv(tsv_file)
    
    # Match the .npy feature files with transcriptions
    aligned_data = match_npy_with_transcriptions(df, features_dir)
    
    # Save aligned data as .csv
    aligned_data.to_csv(output_csv, index=False)
    print(f"Aligned data saved to {output_csv}")

if __name__ == "__main__":
    process_and_save_aligned_data(TSV_FILE, FEATURES_DIR, OUTPUT_CSV)
