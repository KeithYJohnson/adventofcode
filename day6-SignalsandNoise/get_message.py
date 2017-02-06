import numpy
import pandas as pd
from scipy.stats import mode

df = pd.read_csv('comma_separated.csv', header=None)

thing = mode(df, axis=0)
values = ''.join(thing.mode.tolist()[0])
print(values)
