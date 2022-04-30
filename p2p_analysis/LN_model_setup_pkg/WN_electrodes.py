# -*- coding: utf-8 -*-
"""
Created on Fri Dec 14 11:49:28 2018

@author: Tristan
"""

import os 
import shutil
from LN_model_setup_pkg.initialize_p2p import initialize_p2p
import numpy as np
import pulse2percept as p2p
import matplotlib.pyplot as plt
implant, sim, electrodes_names, n_width, n_height, electrodes, amplitude_range, t_sample,stim_duration, pulse_type= initialize_p2p()


from core_pkg.core_functions import launch, electrodes_class
import numpy as np


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
pulse_type = 'cathodicfirst'

# Define the implant and the simulation framework
#implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample)

#x_center=-800, y_center=-400,
implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample, x_center=-1761,
                                                       y_center=-212, rot=0, x_range=[-2800, 2800],
                                                       y_range=[-1700, 1700])

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

#downsampling
time_resolution=60
new_t_sample= 1/time_resolution #time is resampled in order to have 60 frames/s

#factor=round(new_t_sample/t_sample)      
dwnspl_factor=round(new_t_sample/t_sample)

percept_size=(electrodes.height, electrodes.width)
mean = 0 
std = 600
num_samples = 100 #number of patterns to generate
n_electrodes=len(electrodes.electrodes_list)
samples = np.random.normal(mean, std, size=(n_electrodes, num_samples))
s=30000

for i in np.arange(s,s+num_samples):
    amplitudes=samples[:,i-s]
    electrodes.update_amplitudes(amplitudes)
    percept=electrodes.p2p_prediction(sim, t_sample,stim_duration, pulse_type)
    frame = p2p.get_brightest_frame(percept)
    np.save('.//Data//'+str(electrodes.implant_name)+'//white_noise//input//input_'+str(i)+'.npy', amplitudes.data)
    np.save('.//Data//'+str(electrodes.implant_name)+'//white_noise//output//output_'+str(i)+'.npy', frame.data)
    del frame, percept

data = os.listdir('.//Data//'+str(electrodes.implant_name)+'//white_noise//output')
imax=int(len(data))
amplitudes_data=np.zeros((n_electrodes, imax))
data=np.zeros((electrodes.height*electrodes.width, imax))
LN_data=np.zeros((electrodes.height*electrodes.width, imax))

M2 = np.load(".//Data//" + implant_name + "//M2.npy")

for i in np.arange(1,imax):
    amplitudes_data[:,i] = np.load('.//Data//'+str(electrodes.implant_name)+'//white_noise//input//input_'+str(i+s)+'.npy')
    data[:,i]=np.load('.//Data//'+str(electrodes.implant_name)+'//white_noise//output//output_'+str(i+s)+'.npy').reshape(-1)
    data[:, i] = data[:,i]/max(data[:,i])
    LN_data[:,i] = abs(np.dot(M2, amplitudes_data[:,i]))
    LN_data[:, i] =  LN_data[:,i]/ max(LN_data[:,i])

MSE = np.square(np.subtract(LN_data,data)).mean()
print(MSE)

