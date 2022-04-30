from core_pkg.core_functions import launch, electrodes_class, plot_inputs, plot_percept
import numpy as np
import matplotlib.pyplot as plt
import pulse2percept as p2p
import skimage.io as sio
import skimage.transform as sit
import matplotlib
from core_pkg.define_ArgusII import amplitude, stim_duration, interphase_duration, t_sample, s_sample, implant_name, \
    freq, pulse_duration, invert

recompute_p2p_output = True

# Define the implant and the simulation framework
implant, sim, electrodes_names, n_width, n_height = lasunch(implant_name, s_sample, t_sample)

# The implant size is the size of the eletrode array (in number of electrodes on each axis)
implant_size = (n_height, n_width)

# Define the electrodes activity parameters: current pulses amplitude, frequency and duration
amplitudes = amplitude * np.ones(len(electrodes_names))
frequencies = freq * np.ones(len(electrodes_names))
durations = pulse_duration * np.ones(len(electrodes_names))

# Define the electrode array object
electrodes = electrodes_class(electrodes_names, implant_name, amplitudes, frequencies, durations, n_width, n_height,
                              sim, t_sample, stim_duration)

stimuli = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
           'W', 'X', 'Y', 'Z']

M = np.load(".//Data//" + implant_name + "//M.npy")
W = np.linalg.pinv(M)

percept_size = (41, 57)
scaling_factor = 0.38011609996615436

matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'
matplotlib.pyplot.title(r'ABC123 vs $\mathrm{ABC123}^{123}$')

for stimulus in stimuli:

    # Define the stimulus and the input
    datafile = './/stimuli//' + str(stimulus) + '.jpg'

    img_in = sio.imread(datafile, as_gray=True)
    img_in = img_in[50:150, 40:200]

    stim = p2p.stimuli.image2pulsetrain(img_in, implant, coding='amplitude', valrange=[0, amplitude],
                                        max_contrast=False, const_val=freq, invert=invert, tsample=t_sample,
                                        dur=stim_duration, pulsedur=pulse_duration, interphasedur=interphase_duration,
                                        pulsetype='cathodicfirst')

    naive_amplitudes = np.array([pulse.max()[1] for pulse in stim])  # = 1.0 - sit.resize(img_in, implant_size)

    model_input = sit.resize(img_in, percept_size)
    if invert:
        model_input = 1.0 - model_input

    percept = sim.pulse2percept(stim, t_percept=t_sample, tol=0.1, layers=['GCL', 'OFL'])
    p2p_frame = p2p.get_brightest_frame(percept)
    amplitudes = np.dot(W, model_input.flatten())

    filename = './/Data//' + str(implant_name) + '//coding_optimization//' + 'optimized_amplitudes_map' + str(
        stimulus) + '.png'
    plot_inputs(img_in, amplitudes.reshape(implant_size), 'Optimized amplitudes map', filename)

    amplitudes = amplitudes.reshape(1, -1)
    np.save('.//Data//' + str(implant_name) + '//coding_optimization//optimal_amplitudes_' + str(stimulus) + '.npy',
            amplitudes)
    np.save('.//Data//' + str(implant_name) + '//coding_optimization//optimal_amplitudes_' + str(stimulus) + '.npy',
            amplitudes)

    amplitudes = amplitudes.reshape(-1)

    # Compute p2p output for these optimized amplitudes
    electrodes.update_amplitudes(amplitudes)
    p2p_prediction_optimized_coding = electrodes.p2p_prediction(sim, t_sample, stim_duration,
                                                                pulse_type='cathodicfirst')
    p2p_prediction_optimized_coding_frame = p2p.get_brightest_frame(p2p_prediction_optimized_coding)
    filename = './/Data//' + str(implant_name) + '//coding_optimization//' + 'p2p_output_optimized_coding_' + str(
        stimulus) + '.png'
    plot_percept(p2p_prediction_optimized_coding_frame.data, 'p2p output with optimized code', filename)

    plt.figure(figsize=(9, 9))
    plt.subplot(331)
    plt.imshow(img_in, cmap='gray')
    plt.title('Input image')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.subplot(332)
    plt.imshow(naive_amplitudes.reshape(6, 10), cmap='gray')
    plt.title('Stim. amplitude with \n naive code ($\mu$A)')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)
    cbar = plt.colorbar()

    plt.subplot(333)
    plt.imshow(amplitudes.reshape(implant_size), cmap='gray')
    plt.title('Stim. amplitude with \n optimized code ($\mu$A)')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)
    plt.colorbar()

    plt.subplot(334)
    plt.imshow(model_input, cmap='gray')
    plt.title('Target percept')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.subplot(335)
    plt.imshow(p2p_frame.data, cmap='gray')
    plt.title('p2p output with naive code')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.subplot(336)
    plt.imshow(p2p_prediction_optimized_coding_frame.data, cmap='gray')
    plt.title('p2p output with optimized code')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.subplot(338)
    plt.imshow(scaling_factor * abs(np.dot(M, naive_amplitudes)).reshape(percept_size), cmap='gray')
    plt.title('LN model output with naive code')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.subplot(339)
    plt.imshow(scaling_factor * abs(np.dot(M, amplitudes)).reshape(percept_size), cmap='gray')
    plt.title('LN model output with optimized code')
    ax = plt.gca()
    ax.axes.xaxis.set_visible(False)
    ax.axes.yaxis.set_visible(False)

    plt.tight_layout()

    plt.savefig('.//Data//' + str(implant_name) + '//coding_optimization//' + str(stimulus) + '.png')

    plt.close('all')
