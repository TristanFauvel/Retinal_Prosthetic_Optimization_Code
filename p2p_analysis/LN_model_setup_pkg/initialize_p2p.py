
from core_pkg.core_functions import launch, electrodes_class
import numpy as np

def initialize_p2p():
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
    #implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample)

    #x_center=-800, y_center=-400,
    implant, sim, electrodes_names, n_width, n_height =  launch(implant_name, s_sample, t_sample, x_center=-800, y_center=-400, rot=0, x_range=[-2800, 2800], y_range=[-1700, 1700])

    # The implant size is the size of the eletrode array (in number of electrodes on each axis)
    implant_size = (n_height, n_width)

    # Define the electrodes activity parameters: current pulses amplitude, frequency and duration
    amplitudes = amplitude * np.ones(len(electrodes_names))
    frequencies = freq * np.ones(len(electrodes_names))
    durations = pulse_duration * np.ones(len(electrodes_names))

    # Define the electrode array object
    electrodes = electrodes_class(electrodes_names, implant_name, amplitudes, frequencies, durations, n_width, n_height,
                                  sim, t_sample, stim_duration)

    return implant, sim, electrodes_names, n_width, n_height, electrodes, amplitude_range, t_sample, stim_duration, pulse_type
