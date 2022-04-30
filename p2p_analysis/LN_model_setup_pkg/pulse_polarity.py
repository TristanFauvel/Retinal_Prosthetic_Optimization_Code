# -*- coding: utf-8 -*-
"""
Created on Mon Dec 10 18:03:34 2018

@author: Tristan
"""

from core_pkg.core_functions import launch, electrodes_class
import numpy as np
import matplotlib.pyplot as plt
import pulse2percept as p2p

implant_name = 'ArgusII'
if implant_name == 'ArgusII':
    from core_pkg.define_ArgusII import *

# Define the implant and the simulation framework
implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample)

# The implant size is the size of the eletrode array (in number of electrodes on each axis)
implant_size = (n_height, n_width)

# Define the electrodes activity parameters: current pulses amplitude, frequency and duration
amplitudes = np.zeros(len(electrodes_names))
amplitudes[10] = amplitude

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

pulsetype = 'anodicfirst'
p2p_prediction_optimized_coding = electrodes.p2p_prediction(sim, t_sample, stim_duration, pulsetype)
p2p_prediction_optimized_coding_frame = p2p.get_brightest_frame(p2p_prediction_optimized_coding)
plt.figure(figsize=(12, 4))
plt.imshow(p2p_prediction_optimized_coding_frame.data, cmap='gray')
plt.colorbar()
plt.title('Response to anodic-first pulse')
plt.savefig('.//' + str(implant_name) + '//polarity_percept//' + 'anodic_first' + '.png')

pulsetype = 'cathodicfirst'
p2p_prediction_optimized_coding = electrodes.p2p_prediction(sim, t_sample, stim_duration, pulsetype)
p2p_prediction_optimized_coding_frame = p2p.get_brightest_frame(p2p_prediction_optimized_coding)
plt.figure(figsize=(12, 4))
plt.imshow(p2p_prediction_optimized_coding_frame.data, cmap='gray')
plt.colorbar()
plt.title('Response to cathodic-first pulse')
plt.savefig('.//' + str(implant_name) + '//polarity_percept//' + 'cathodic_first' + '.png')
