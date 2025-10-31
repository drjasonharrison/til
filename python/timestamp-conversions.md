# Timestamp conversions



## time.time() to numpy.datetime64

```python
import time
import numpy as np

# Get the current time as a float (seconds since the epoch)
current_timestamp_float = time.time()

current_timestamp_seconds = int(current_timestamp_float)

# Create the numpy datetime64 object using the integer and specifying the unit
current_datetime = np.array(current_timestamp_seconds, dtype='datetime64[s]')

print(f"Float timestamp: {current_timestamp_float}")
print(f"Int timestamp: {current_timestamp_seconds}")
print(f"NumPy datetime: {current_datetime}")
```

Output

```
Float timestamp: 1761928843.6522005
Int timestamp: 1761928843
NumPy datetime: 2025-10-31T16:40:43
```
