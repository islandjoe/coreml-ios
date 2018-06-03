import pandas as pd
import numpy as np
from sklearn.utils import shuffle
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier
from sklearn.pipeline import Pipeline
import coremltools

names = pd.read_csv('namesDataset.csv')
names = names.as_matrix()[:, 1:]

# 80% reserved for training
TRAIN_SPLIT = 0.8

def features(name):
    name = name.lower()
    return {
        'firstLetter1': name[0],
        'firstLetter2': name[0:2],
        'firstLetter3': name[0:3],
        'lastLetter1': name[-1],
        'lastLetter2': name[-2:],
        'lastLetter3': name[-3:],
    }


features = np.vectorize(features)

# X contains the features
X = features(names[:, 0]) 

# y contains the targets
y = names[:, 1] 

# Shuffle sorted names for better training
X, y = shuffle(X, y)
X_train, X_test = X[:int(TRAIN_SPLIT * len(X))], X[int(TRAIN_SPLIT * len(X)):]
y_train, y_test = y[:int(TRAIN_SPLIT * len(y))], y[int(TRAIN_SPLIT * len(y)):]

vectorizer = DictVectorizer()
dtc = DecisionTreeClassifier()

pipeline = Pipeline([('dict', vectorizer), ('dtc', dtc)])
pipeline.fit(X_train, y_train)

# Testing
# ['M' 'F']
print( pipeline.predict(features(["Arthur", "Annika"])) )
print( pipeline.score(X_train, y_train) )
print( pipeline.score(X_test, y_test) )

# Convert to CoreML model
coreml_model = coremltools.converters.sklearn.convert(pipeline)
coreml_model.author = 'Arthur Kho'
coreml_model.license = 'MIT'
coreml_model.short_description = 'Classify gender based on the first name'
coreml_model.input_description['input'] = 'First name features seperated by first 3 and last 3 letters as Dictionary [String: Double]'
coreml_model.output_description['classLabel'] = 'The most likely gender, for the given input. (F|M)'
coreml_model.output_description['classProbability'] = 'The probabilities gender, based on input.'
coreml_model.save('GenderFromName.mlmodel')
