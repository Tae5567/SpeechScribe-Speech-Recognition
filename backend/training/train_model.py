import torch
import torch.optim as optim
import torch.nn as nn
from torch.utils.data import DataLoader
from dataset import AudioDataset
from rnn_model import SpeechRecognitionRNN
import os

# Parameters
input_size = 126  # number of MFCC coefficients (13 frames * 126 features)
hidden_size = 128
vocab_size = 30  # Number of characters or phonemes in your transcription labels
num_epochs = 20
batch_size = 16
learning_rate = 0.001

# Directories
features_dir = '../features'  # Directory containing .npy files for audio features (MFCCs, etc.)
labels_file = '../aligned_data.csv'  # CSV file with filenames and transcription labels

# Load dataset
dataset = AudioDataset(features_dir, labels_file)
dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

# Model, Loss, Optimizer
model = SpeechRecognitionRNN(input_size, hidden_size, vocab_size)
criterion = nn.CTCLoss(blank=0)  # Blank token is for padding
optimizer = optim.Adam(model.parameters(), lr=learning_rate)

# Training Loop
for epoch in range(num_epochs):
    model.train()
    epoch_loss = 0.0

    for mfccs, label_seq in dataloader:
        optimizer.zero_grad()

        # Forward pass
        logits = model(mfccs)  # (batch_size, sequence_length, vocab_size)
        
        # Prepare for CTC Loss: Flatten and reshape sequences
        log_probs = nn.functional.log_softmax(logits, dim=2)
        input_lengths = torch.full(size=(log_probs.size(0),), fill_value=log_probs.size(1), dtype=torch.long)  # All input sequences are the same length
        target_lengths = torch.tensor([len(seq) for seq in label_seq], dtype=torch.long)  # Lengths of each transcription sequence
        
        # Compute loss
        loss = criterion(log_probs.permute(1, 0, 2), label_seq, input_lengths, target_lengths)
        loss.backward()
        optimizer.step()

        epoch_loss += loss.item()

    print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {epoch_loss/len(dataloader)}')

print('Training complete.')
