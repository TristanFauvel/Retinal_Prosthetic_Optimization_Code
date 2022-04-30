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

from sklearn.metrics import mean_squared_error
from core_pkg.core_functions import launch, electrodes_class
import numpy as np
import matplotlib.pyplot as plt
import os

t_sample = 0.00001
s_sample = 100
implant_name = 'ArgusII'
if implant_name == 'ArgusII':
    amplitude_range = np.arange(0, 200, 50)
    amplitude = 50
elif implant_name == 'ArgusI':
    amplitude_range = np.arange(0, 200, 20)
    amplitude = 20
freq = 50
pulse_duration = 0.00045
stim_duration = 0.5
interphase_duration = 0.00045
invert = False
recompute_p2p_output = True
pulse_type = 'cathodicfirst'

# Define the implant and the simulation framework
implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample)

# The implant size is the size of the eletrode array (in number of electrodes on each axis)
implant_size = (n_height, n_width)

# Define the electrodes activity parameters: current pulses amplitude, frequency and duration
amplitudes = amplitude * np.ones(len(electrodes_names))
frequencies = freq * np.ones(len(electrodes_names))
durations = pulse_duration * np.ones(len(electrodes_names))

# Define the electrode array object
electrodes = electrodes_class(electrodes_names, implant_name, amplitudes, frequencies, durations, n_width, n_height,
                              sim, t_sample, stim_duration)

electrodes.coeff_electrodes(amplitude_range)
# downsampling
time_resolution = 60
new_t_sample = 1 / time_resolution  # time is resampled in order to have 60 frames/s

# factor=round(new_t_sample/t_sample)
dwnspl_factor = round(new_t_sample / t_sample)

percept_size = (electrodes.height, electrodes.width)
mean = 0
std = 600
num_samples = 10000  # number of patterns to generate
n_electrodes = len(electrodes.electrodes_list)

M = np.load(".//Data//" + implant_name + "//M.npy")
M = M / 0.2194942003224534

W = np.linalg.pinv(M)

data = os.listdir('..//Data//' + str(electrodes.implant_name) + '//white_noise//output')
imax = int(len(data))
amplitudes_data = np.zeros((n_electrodes, imax))
s = 0
data = np.zeros((electrodes.height * electrodes.width, imax))
predictions = np.zeros((electrodes.height * electrodes.width, imax))
mean_amp = np.zeros(imax)
for i in np.arange(1, imax):
    amplitudes_data[:, i] = np.load(
        './/Data//' + str(electrodes.implant_name) + '//white_noise//input//input_' + str(i + s) + '.npy')
    linear_model_prediction = np.dot(M, amplitudes_data[:, i])

    # linear_model_prediction[linear_model_prediction<0]=0
    linear_model_prediction = abs(linear_model_prediction)
    predictions[:, i] = linear_model_prediction
    #    np.save('.//'+str(electrodes.implant_name)+'//white_noise_comparison//linear_model_output_'+str(i+s)+'.npy', linear_model_prediction)
    data[:, i] = np.load(
        './/Data//' + str(electrodes.implant_name) + '//white_noise//output//output_' + str(i + s) + '.npy').reshape(-1)

RMSE = mean_squared_error(data, predictions)
nRMSE = mean_squared_error(data / np.max(data), predictions / np.max(predictions))

ind = np.argmax(predictions)
index = np.unravel_index(ind, predictions.shape)
test = predictions[index]
plt.figure()
plt.imshow(predictions[:, index[1]].reshape(percept_size))

plt.figure()
plt.imshow(data[:, index[1]].reshape(percept_size))

plt.imshow(np.divide(predictions[:, index[1]], data[:, index[1]]).reshape(percept_size))
