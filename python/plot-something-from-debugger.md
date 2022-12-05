# Plot something quickly from the debugger


```python
import matplotlib.pyplot as plt
# 2d plot
plt.plot(data)
# image from matrix data
plt.imshow(matrix)

# clears the entire current figure with all its axes, but leaves the window opened, such that it may be reused for other plots.
plt.clf()
# closes a window, which will be the current window, if not specified otherwise.
plt.close()
# clears an axis, i.e. the currently active axis in the current figure. It leaves the other axes untouched.
plt.cla()
```
