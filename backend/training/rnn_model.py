#import torch
#import torch.nn as nn

class SpeechRecognitionRNN(nn.Module):
    def __init__(self, input_size, hidden_size, vocab_size, num_layers=3, dropout=0.3):
        super(SpeechRecognitionRNN, self).__init__()
        #Recurrent layers
        self.rnn = nn.LSTM(input_size, hidden_size, num_layers=num_layers,dropout=dropout, bidirectional=True, batch_first=True)
        #Fully connected layer
        self.fc = nn.Linear(hidden_size * 2, vocab_size)
    
    def forward(self, x):
        # x is the MFCC features [batch_size, sequence_length, input_size]
        rnn_out, _ = self.rnn(x)
        logits = self.fc(rnn_out)
        return logits
