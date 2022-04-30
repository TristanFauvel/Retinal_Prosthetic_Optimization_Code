# -*- coding: utf-8 -*-
"""
Created on Wed Jan  9 11:09:25 2019

@author: Tristan
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Dec 14 11:49:28 2018

@author: Tristan
"""
# -*- coding: utf-8 -*-
"""
Created on Tue Jan  8 15:26:29 2019

@author: Tristan
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Dec 14 11:49:28 2018

@author: Tristan
"""

from LN_model_setup_pkg.initialize_p2p import initialize_p2p
import numpy as np
import matplotlib.pyplot as plt
import os

implant, sim, electrodes_names, n_width, n_height, electrodes, amplitude_range, t_sample, implant_name, implant_size = initialize_p2p()

electrodes.coeff_electrodes(amplitude_range)

# downsampling
time_resolution = 60
new_t_sample = 1 / time_resolution  # time is resampled in order to have 60 frames/s

# factor=round(new_t_sample/t_sample)
dwnspl_factor = round(new_t_sample / t_sample)

temporal_sensitivity_model = TemporalModel(new_t_sample)
percept_size = (electrodes.height, electrodes.width)
mean = 0
std = 600
num_samples = 10000  # number of patterns to generate
n_electrodes = len(electrodes.electrodes_list)

# M=np.zeros((electrodes.height*electrodes.width, len(electrodes.electrodes_list)))
# j=0
# for electrode in electrodes.electrodes_list:
#    M[:,j]=electrode.amplitude_coeff.reshape(-1)
#    j=j+1
M = np.load(".//Data//" + implant_name + "//M.npy")

W = np.linalg.pinv(M)

data = os.listdir('.//' + str(electrodes.implant_name) + '//white_noise//output')
imax = int(len(data))
amplitudes_data = np.zeros((n_electrodes, imax))
s = 0

for i in np.arange(1, imax):
    amplitudes_data[:, i] = np.load(
        './/' + str(electrodes.implant_name) + '//white_noise//input//input_' + str(i + s) + '.npy')

linear_model_prediction = np.dot(M, amplitudes_data)
data = linear_model_prediction
sta = np.zeros((n_electrodes, electrodes.height * electrodes.width))
for pixel in np.arange(electrodes.height * electrodes.width):
    amplitudes_data_pix = amplitudes_data[:, data[pixel, :] >= 0]
    data_pix = data[pixel, data[pixel, :] >= 0]
    sta[:, pixel] = np.sum(np.multiply(data_pix, amplitudes_data_pix), axis=1) / np.sum(data_pix)

plt.figure()
i = 0
for x in np.arange(percept_size[1]):
    for y in np.arange(percept_size[0]):
        plt.subplot(percept_size[0], percept_size[1], i + 1)
        plt.imshow(sta[:, i].reshape(implant_size), cmap='gray')
        plt.axis('off')
        i = i + 1

plt.figure()
i = 0
for x in np.arange(implant_size[1]):
    for y in np.arange(implant_size[0]):
        plt.subplot(implant_size[0], implant_size[1], i + 1)
        plt.imshow(sta[i, :].reshape(percept_size), cmap='gray')
        plt.axis('off')
        i = i + 1

# Now we derive the stationary non linearity of our LN model

generator = np.dot(sta.T, amplitudes_data)
plt.figure()
i = 0
for pixel in np.arange(electrodes.height * electrodes.width):
    generator_pixel = generator[pixel, data[pixel, :] >= 0]
    plt.subplot(percept_size[0], percept_size[1], i + 1)
    plt.scatter(generator_pixel, data[pixel, data[pixel, :] >= 0])
    plt.axis('off')
    i = i + 1

generator[np.isnan(generator)] = 0
from sklearn.linear_model import LinearRegression

coeff = np.zeros(electrodes.height * electrodes.width)
for idx in np.arange(electrodes.height * electrodes.width):
    reg = LinearRegression().fit(generator[idx, :].reshape(-1, 1), data[idx, :])
    coeff[idx] = reg.coef_

plt.figure()
for j in np.arange(electrodes.height * electrodes.width):
    plt.scatter(generator[j, :], data[j, :])

generator_hist = plt.hist(generator_pooled, bins=1000)
distribution = generator_hist[0]
values_range = generator_hist[1]
values_range = values_range[0:-1] + np.mean(values_range[1:] - values_range[0:-1]) / 2
plt.figure()
plt.plot(values_range, distribution)

plt.figure()
plt.scatter(generator_pooled, data_pooled)

for j in np.arange(electrodes.height * electrodes.width):
    for value in generator[j, :]:
        averaged = np.mean([val for i, val in enumerate(data_pooled) if generator_pooled[i] == value])

j = 500
for value in generator[j, :]:
    averaged = np.mean([val for i, val in enumerate(data_pooled) if generator_pooled[i] == value])

generator_pooled_values = list(set(generator_pooled))
for value in generator_pooled_values:
    averaged = np.mean([val for i, val in enumerate(data_pooled) if generator_pooled[i] == value])
