'''import os
import torch
import librosa
from transformers import Wav2Vec2ForCTC, Wav2Vec2Tokenizer
import soundfile as sf
import pandas as pd

#path to audio folder
audio_folder = 'processed_clips'
output_file = 'transcriptions.csv'

#load Wav2Vec2 pre-trained model and tokenizer
model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-large-960h")
tokenizer = Wav2Vec2Tokenizer.from_pretrained("facebook/wav2vec2-large-960h")

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model.to(device)


#helper function to transcribe audio
def transcribe_audio(file_path):
    #load the audiofile
    speech_array, sampling_rate = sf.read(file_path)

    #resample audio if not 16kHz
    if sampling_rate != 16000:
        speech_array = librosa.resample(speech_array, orig_sr=sampling_rate,target_sr=16000)

    #tokenize input
    input_values = tokenizer(speech_array, return_tensors='pt', padding="longest").input_values
    #set input to the correct device
    input_values = input_values.to(device)

    #perfom transcription
    with torch.no_grad():
        logits = model(input_values).logits

    predicted_ids = torch.argmax(logits, dim=-1)

    transcription = tokenizer.decode(predicted_ids[0])

    return transcription

#initialize a list to store transcriptions
transcriptions = []

#process each audio file in the processed_clips folder
for root, dirs, files in os.walk(audio_folder):
    for filename in files:
        if filename.endswith(".wav"):
            file_path = os.path.join(root, filename)
            print(f"Processing {filename}...")
            transcription = transcribe_audio(file_path)
            transcriptions.append({'file': filename, 'transcription': transcription})

#save transcriptions to a .csv file
df = pd.DataFrame(transcriptions)
df.to_csv(output_file, index=False)

print(f"Transcriptions of audio files saved to {output_file}")
'''
import os
import torch
from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor
import librosa
from multiprocessing import Pool, cpu_count

# Load optimized model and processor
model_name = "facebook/wav2vec2-large-960h-lv60-self"
model = Wav2Vec2ForCTC.from_pretrained(model_name)
processor = Wav2Vec2Processor.from_pretrained(model_name)
model.to("cuda" if torch.cuda.is_available() else "cpu")

def transcribe_audio_file(file_path):
    # Check if transcription already exists
    transcription_path = f"transcriptions/{os.path.basename(file_path)}.txt"
    if os.path.exists(transcription_path):
        return None  # Skip processing this file

    audio, rate = librosa.load(file_path, sr=16000)
    inputs = processor(audio, sampling_rate=rate, return_tensors="pt", padding=True)
    input_values = inputs.input_values.to(model.device)

    with torch.no_grad():
        logits = model(input_values).logits
    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0]
    return file_path, transcription

def save_transcription(result):
    if result is None:  # Skip saving if already processed
        return
    file_path, transcription = result
    transcription_path = f"transcriptions/{os.path.basename(file_path)}.txt"
    with open(transcription_path, "w") as f:
        f.write(transcription)

if __name__ == "__main__":
    audio_folder = "processed_clips"
    files = [os.path.join(audio_folder, f) for f in os.listdir(audio_folder) if f.endswith(".wav")]

    os.makedirs("transcriptions", exist_ok=True)

    with Pool(cpu_count()) as pool:
        for result in pool.imap_unordered(transcribe_audio_file, files):
            save_transcription(result)