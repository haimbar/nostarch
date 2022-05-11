import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0, 4*np.pi, 0.01)
y = 1.6*x + 2*np.sin(3*x) + np.random.normal(loc=0.0, scale=1.0, size=len(x))
plt.plot(x, y, linestyle="", marker=".")
plt.xlabel('x')
plt.ylabel('y')
plt.savefig('images/ScaPlot.pdf')
#plt.show()
