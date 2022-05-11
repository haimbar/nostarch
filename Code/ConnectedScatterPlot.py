import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Set figure default figure size
plt.rcParams["figure.figsize"] = (10, 6)
# Create a random number generator for reproducibility
rng = np.random.default_rng(1111)

x = np.array(range(10))
y = rng.integers(10, 100, 10)
z = y + rng.integers(5, 20, 10)
plt.plot(x, z, linestyle="-", marker="o", label="Income")
plt.plot(x, y, linestyle="-", marker="x", label="Expenses")
plt.legend()
#plt.savefig('images/conScaPlot.pdf')
plt.show()
