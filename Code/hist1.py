import matplotlib.pyplot as plt
import seaborn as sns
df = sns.load_dataset('iris')
sns.displot( a=df["sepal_length"], hist=True, kde=False, rug=False )
plt.show()
