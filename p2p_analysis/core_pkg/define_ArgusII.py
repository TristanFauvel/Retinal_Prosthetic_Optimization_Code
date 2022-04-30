# -*- coding: utf-8 -*-
"""
Created on Thu Jan 17 16:24:19 2019

@author: Tristan
"""
import numpy as np
amplitude_range=np.arange(0,200,50)
amplitude=50
fps=30
mins=0.05
frame_rate=60    
stim_duration=1/frame_rate
time_resolution=200
interphase_duration=0.00045
new_t_sample= 1/time_resolution #time is resampled in order to have time_resolution frames/s
max_amp=60
normalization_factor=1
t_sample = 0.01 / 1000
s_sample = 100
implant_name='ArgusII'
freq=50
pulse_duration=0.00045
dwnspl_factor=round(new_t_sample/t_sample)      
stimulus_duration=0.5
if implant_name== 'ArgusI':    
    percept_size=(41, 36)
elif implant_name=='ArgusII':
    percept_size=(41, 61)
invert = True
win_size=(600,800)
n_height=6
n_width=10
implant_size=(n_height,n_width)
percept_size=(41, 61)
n_electrodes=60