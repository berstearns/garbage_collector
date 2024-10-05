import torch
import torch.nn as nn
from transformers import BertModel

class BERTWithNationalityEmbeddings(nn.Module):
    def __init__(self, model_name="bert-base-uncased", num_nationalities=3, emb_size=768):
        super(BERTWithNationalityEmbeddings, self).__init__()
        # Load the BERT model
        self.bert = BertModel.from_pretrained(model_name)
        # Nationality embedding layer
        self.nationality_embeddings = nn.Embedding(num_embeddings=num_nationalities, embedding_dim=emb_size)
        # Final classifier layer (for MLM task, should match the vocab size)
        self.vocab_size = self.bert.config.vocab_size
        self.classifier = nn.Linear(emb_size * 2, self.vocab_size)

    def forward(self, input_ids, attention_mask=None, token_type_ids=None, nationality_ids=None):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask, token_type_ids=token_type_ids)
        sequence_output = outputs.last_hidden_state  # (batch_size, sequence_length, hidden_size)
        nationality_embeds = self.nationality_embeddings(nationality_ids)
        nationality_embeds = nationality_embeds.unsqueeze(1).repeat(1, sequence_output.size(1), 1)
        concat_output = torch.cat((sequence_output, nationality_embeds), dim=-1)
        logits = self.classifier(concat_output)  # (batch_size, sequence_length, vocab_size)
        return logits
