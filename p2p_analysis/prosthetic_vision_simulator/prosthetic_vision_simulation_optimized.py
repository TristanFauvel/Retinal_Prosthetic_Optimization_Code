# -*- coding: utf-8 -*-
"""
Created on Wed Nov 21 09:12:08 2018

"""
from core_pkg.core_functions import launch, electrodes_class, pulse_pattern
import numpy as np
import pulse2percept as p2p
import scipy
import skimage.transform as sit


def prosthetic_vision_simulation_optimized(t_sample=0.01 / 1000, s_sample=100, implant_name='ArgusII',
                                           amplitude_range=np.arange(0, 200, 20), amplitude=20, freq=50,
                                           pulse_duration=0.00045):
    # Create the simulation framework
    implant, sim, electrodes_names, n_width, n_height = launch(implant_name, s_sample, t_sample)

    if implant_name == 'ArgusII':
        amplitude_range = np.arange(0, 200, 50)
        amplitude = 50

    amplitudes = amplitude * np.ones(len(electrodes_names))
    frequencies = freq * np.ones(len(electrodes_names))
    durations = pulse_duration * np.ones(len(electrodes_names))
    stimulus_duration = 0.5
    electrodes = electrodes_class(electrodes_names, implant_name, amplitudes, frequencies, durations, n_width, n_height,
                                  sim, t_sample, stimulus_duration)
    electrodes.coeff_electrodes(amplitude_range)

    if implant_name == 'ArgusI':
        electrodes.height = 41
        electrodes.width = 36
    elif implant_name == 'ArgusII':
        electrodes.height = 41
        electrodes.width = 61

    import cv2
    import collections
    fps = 60
    dur_seconds = 1
    input_deque = collections.deque(maxlen=int(fps * dur_seconds * 60))
    cap = cv2.VideoCapture(0)
    frame_rate = 60
    stim_duration = 1 / frame_rate
    time_resolution = 200
    interphase_duration = 0.00045
    new_t_sample = 1 / time_resolution  # time is resampled in order to have time_resolution frames/s
    dwnspl_factor = round(new_t_sample / t_sample)

    max_amp = amplitude

    normalization_factor = 0

    M = np.load("..//Data//" + implant_name + "//M.npy")

    W = np.linalg.pinv(M)
    invert = True
    while (True):
        # Capture frame-by-frame
        ret, frame = cap.read()
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        input_deque.append({
            'time': time.time(),
            'frame_raw': frame})
        video_stim = p2p.stimuli.image2pulsetrain(frame, implant, coding='amplitude', valrange=[0, max_amp],
                                                  max_contrast=True, const_val=freq, invert=False, tsample=t_sample,
                                                  dur=stim_duration, pulsedur=pulse_duration,
                                                  interphasedur=interphase_duration, pulsetype='cathodicfirst')
        # downsampling

        pp = pulse_pattern(electrodes, stim_duration, t_sample)
        pp.video2pulsetrain(video_stim, implant, t_sample)

        pp.pattern_downsampling(electrodes, dwnspl_factor)
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)

        model_input = sit.resize(gray_frame, (electrodes.height, electrodes.width))
        if invert:
            model_input = 1.0 - model_input
        model_input_reshaped = model_input.reshape(-1)
        amplitudes = np.dot(W, model_input_reshaped)

        pattern = pp.pattern > 0
        pp.pattern = np.multiply(pattern, amplitudes.reshape(-1, 1))

        if implant_name == 'ArgusI':
            pp.impulse_response = scipy.signal.resample_poly(pp.impulse_response, up=1,
                                                             down=dwnspl_factor) * dwnspl_factor
        # ATTENTION : une fois que j'aurai recalculé les filtres temporels IL FAUDRA RETIRER LE DOWNSAMPLING A CETTE ETAPE!!

        predicted_percept = pp.predicted_response_to_pulses(electrodes)
        normalization_factor = max(normalization_factor, np.max(predicted_percept))
        predicted_percept = predicted_percept[:, :, -1] * 255 / normalization_factor
        resized = cv2.resize(predicted_percept, frame.shape[0:2][::-1])
        rgb_img = np.zeros(frame.shape)
        rgb_img[:, :, 0] = resized
        rgb_img[:, :, 1] = resized
        rgb_img[:, :, 2] = resized
        rgb_img = rgb_img.astype(np.uint8)
        p2p_frame = cv2.cvtColor(rgb_img, cv2.COLOR_RGB2GRAY)

        gray = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
        final = cv2.hconcat([gray, p2p_frame])
        # Display the resulting frame
        cv2.imshow('frame', final)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # When everything done, release the capture
    cap.release()
    cv2.destroyAllWindows()


prosthetic_vision_simulation_optimized()
