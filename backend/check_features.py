import numpy as np

# Path to one of your .npy files (MFCC features)
npy_file_path = 'features/0a0a9eea54ae8f4492807a41c1acd0d51d81917fde4ade578e82988f842c4bf09917250f51ef84ec90b9b9ee8d328ef94994239b8387e07d694eeb19cb2114b1.npy'

# Load the .npy file
mfcc_features = np.load(npy_file_path)

# Inspect the shape
print("Shape of the MFCC array:", mfcc_features.shape)

# Extract input_dim (number of MFCCs per frame)
input_dim = mfcc_features.shape[1]
print("Input dimension (number of MFCCs per frame):", input_dim)
