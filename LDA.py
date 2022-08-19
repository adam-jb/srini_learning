

# https://towardsdatascience.com/topic-modelling-in-python-with-nltk-and-gensim-4ef03213cd21


from nltk.tokenize import word_tokenize
from nltk.corpus import wordnet as wn
from gensim import corpora
import pickle
import gensim
import os
import json


## Read in our studies
pathway = '/Users/adambricknell/Downloads/AllAPIJSON/NCT0001xxxx' # folder of 675 studies: subset of overall download
some_studies_files_list = os.listdir(pathway)


def read_in_file_text(input_path):
	study = json.load(open(pathway + '/' + input_path))
	study = study['FullStudy']['Study']['ProtocolSection']
	try:
		study_brief = study['DescriptionModule']['BriefSummary']
	except:
		study_brief = ''
	try:
		study_detailed = study['DescriptionModule']['DetailedDescription']
	except:
		study_detailed = ''
	return study_brief + ' ' + study_detailed



# read in files
text_data = [read_in_file_text(input_path) for input_path in some_studies_files_list]
text_data = [study for study in text_data if len(study) > 10]



def get_lemma(word):
    lemma = wn.morphy(word)
    if lemma is None:
        return word
    else:
        return lemma


nltk.download('stopwords')
en_stop = set(nltk.corpus.stopwords.words('english'))


def prepare_text_for_lda(text):
    tokens = word_tokenize(text)
    tokens = [token for token in tokens if len(token) > 4]        # filtering out short words
    tokens = [token for token in tokens if token not in en_stop]
    tokens = [get_lemma(token) for token in tokens]
    return tokens



# process and encode our text
text_data = [prepare_text_for_lda(study) for study in text_data]




### example
# text_data = list of lists
#text_data = [['excellent', 'helpful', 'study'], ['tea', 'breakfast', 'rampant', 'microscope', 'excellent']]


# Making 'dictionary' which is a corpus in the format LDA wants
dictionary = corpora.Dictionary(text_data)     # log of unique token
corpus = [dictionary.doc2bow(text) for text in text_data]   # our corpus in a format the algorithm likes



### Main topic model
NUM_TOPICS = 4
ldamodel = gensim.models.ldamodel.LdaModel(corpus, num_topics = NUM_TOPICS, id2word=dictionary, passes=15)
ldamodel.save('model5.gensim')
topics = ldamodel.print_topics(num_words=4)
for topic in topics:
    print(topic)


# Put new doc into model
new_doc = 'Practical Bayesian Optimization of Machine Learning Algorithms breakfast microscope a study about diabetes or something'
new_doc = prepare_text_for_lda(new_doc)
new_doc_bow = dictionary.doc2bow(new_doc)
print(new_doc_bow)
print(ldamodel.get_document_topics(new_doc_bow))





