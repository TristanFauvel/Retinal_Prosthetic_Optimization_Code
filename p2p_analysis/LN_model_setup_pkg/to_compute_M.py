# -*- coding: utf-8 -*-
"""
Created on Fri Jan 18 09:35:55 2019

@author: Tristan
"""
from LN_model_setup_pkg.initialize_p2p import initialize_p2p
import numpy as np
from core_pkg.core_functions import electrode_response_to_single_pulse


implant, sim, electrodes_names, n_width, n_height, electrodes, amplitude_range, t_sample, stim_duration, pulse_type = initialize_p2p()

amplitude_range = np.arange(0, 200, 50)

for amp in amplitude_range:
    electrode_response_to_single_pulse(electrodes, sim, t_sample, amplitude=amp,  pulse_duration=0.00045, stimulus_duration=0.3,pulse_type='cathodicfirst')

electrodes.coeff_electrodes(amplitude_range) 
M=np.zeros((electrodes.height*electrodes.width, len(electrodes.electrodes_list)))
j=0
for electrode in electrodes.electrodes_list:
    M[:,j]=electrode.amplitude_coeff.reshape(-1)
    j=j+1
    

np.save(".//Data//"+implant_name+"//M2.npy", M)



## Alternative method, without linear regression :
value = 30
M=np.zeros((electrodes.height*electrodes.width, len(electrodes.electrodes_list)))
for k, electrode in enumerate(electrodes.electrodes_list):
    X = np.load('.//Data//' + 'ArgusII' + '//' + 'amplitudes' + '_percept//' + electrode.name + '_amp' + str(value) + '.npy')
    M[:,k]  =  X.flatten()

np.save(".//Data//ArgusII//M2.npy", M)
