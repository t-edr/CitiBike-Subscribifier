import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix
from sklearn.metrics import f1_score
from sklearn.metrics import accuracy_score

excel_data = pd.read_excel('Citibike January 2021 data.xlsx')
# Read the values of the file in the dataframe
dataset = pd.DataFrame(excel_data, columns=['gender','age', 'distance_miles', 'duration_mins', 'user_type(subscriber = 1, customer = 0)'])

#replace zeroes
zero_not_accepted = ['gender', 'age','distance_miles', 'duration_mins']

for column in zero_not_accepted:
    dataset[column] = dataset[column].replace(0, np.NaN)
    mean = int(dataset[column].mean(skipna=True))
    dataset[column] = dataset[column].replace(np.NaN,mean)

#split dataset
X = dataset.iloc[:, 0:4]
y = dataset.iloc[:, 4]
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=0, test_size=0.2)

#Feature scaling
sc_X = StandardScaler()
X_train = sc_X.fit_transform(X_train)
X_test = sc_X.transform(X_test)

#Define the model: Init K-NN
classifier = KNeighborsClassifier(n_neighbors=25,p=3,metric='euclidean')

#Fit Model
classifier.fit(X_train, y_train)

#predict the test set results
y_pred = classifier.predict(X_test)

# Evaluate Model
cm = confusion_matrix(y_test, y_pred)
print("The confusion matrix is:",cm)
print("The f1 score is:", f1_score(y_test, y_pred))
print("The accuracy score is:", accuracy_score(y_test, y_pred))