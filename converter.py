import numpy as np

array_x = np.array([
    [0.4841667, 0.5541667, 0.6516667, 0.5650000, 0.4841667],
    [0.6533333, 0.5691667, 0.4741667, 0.5558333, 0.6533333],
    [0.6641667, 0.4583333, 0.2341667, 0.4600000, 0.6641667],
])

array_y = np.array([
    [0.0985714, 0.2714286, 0.4514286, 0.2557143, 0.0985714],
    [0.4914286, 0.6728571, 0.8242857, 0.6442857, 0.4914286],
    [0.5000000, 0.4857143, 0.5028571, 0.5171429, 0.5000000],
])

array_x = np.round((array_x - array_x.min()) / array_x.max(), 3)
array_y = np.round((array_y - array_y.min()) / array_y.max(), 3)

print("ARRAY X")
for values in array_x:
    print('\n'.join(values.astype(str)), end='\n\n')

print("ARRAY Y")
for values in array_y:
    print('\n'.join(values.astype(str)), end='\n\n')
