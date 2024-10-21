import torch
from torch.utils.data import Dataset
import numpy as np
import pandas as pd
import os
import string

class AudioDataset(Dataset):
    def __init__(self, features_dir, labels_file, vocab=None):
        self.features_dir = features_dir
        self.labels_data = pd.read_csv(labels_file)  # aligned_data.csv contains ['filename', 'transcription']

         # Build or use an existing vocabulary
        if vocab:
            self.vocab = vocab
        else:
            self.vocab = self.build_vocab(self.labels_data['transcription'])
        
        self.vocab_size = len(self.vocab)
        
    def __len__(self):
        return len(self.labels_data)
    
    def __getitem__(self, idx):
        # Load the features from .npy file
        audio_filename = self.labels_data.iloc[idx, 0]  # File name (e.g., 'f480b8a93bf84b7f74c141.wav')
        feature_path = os.path.join(self.features_dir, audio_filename.replace('.wav', '.npy'))  # Load .npy feature file
        
        mfccs = np.load(feature_path)  # Load the precomputed MFCCs or spectrogram
        mfccs = torch.tensor(mfccs, dtype=torch.float32)  # Convert to PyTorch tensor

        # Convert transcription to a sequence of character tokens
        transcription = self.labels_data.iloc[idx, 1]  # Get the transcription text
        label_seq = self.text_to_sequence(transcription)

        # Convert to tensor (and handle variable-length sequences)
        label_seq = torch.tensor(label_seq, dtype=torch.long)
        
        return mfccs, label_seq
    
    def build_vocab(self, transcriptions):
        """Creates a character-level vocabulary from all transcriptions."""
        all_text = ''.join(transcriptions).lower()
        vocab = sorted(set(all_text))  # Unique characters
        vocab_dict = {char: idx + 1 for idx, char in enumerate(vocab)}  # Map char to index
        vocab_dict['<pad>'] = 0  # Add padding token
        return vocab_dict
    
    def text_to_sequence(self, text):
        """Converts a transcription to a sequence of token indices."""
        text = text.lower()  # Normalize to lowercase
        return [self.vocab[char] for char in text if char in self.vocab]

