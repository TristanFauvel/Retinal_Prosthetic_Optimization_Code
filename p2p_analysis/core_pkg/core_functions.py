# -*- coding: utf-8 -*-
"""
Created on Mon Nov 12 10:38:51 2018

"""

import pylab
import timeit
import numpy as np
import matplotlib.pyplot as plt
import pulse2percept as p2p
import scipy
import os


def launch(implant_name, s_sample=100, t_sample=0.01 / 1000, x_center=-800, y_center=-400, rot=0, x_range=[-2800, 2800],
           y_range=[-1700, 1700]):
    # t_sample: Set the temporal sampling step (seconds)

    # Load an Argus array
    if implant_name == 'ArgusII':
        implant = p2p.implants.ArgusII(x_center=x_center, y_center=y_center, h=0, rot=rot, eye='RE')
    elif implant_name == 'ArgusI':
        implant = p2p.implants.ArgusI(x_center=x_center, y_center=y_center, h=0, rot=rot, eye='RE')  # rot is in grad

    t_gcl = t_sample  # Sampling step (s) for the GCL computation
    t_percept = t_gcl  # Sampling step (s) for the perceptual output

    # Start the simulation framework
    sim = p2p.Simulation(implant, engine='joblib', n_jobs=-1)

    # Set parameters of the optic fiber layer (OFL)
    # In previous versions of the model, this used to be called the `Retina`
    # object, which created a spatial grid and generated the axtron streak map.

    sim.set_optic_fiber_layer(sampling=s_sample, x_range=x_range,
                              n_axons=501, n_rho=801, rho_range=(4, 45),
                              sensitivity_rule='decay', decay_const=5.0,
                              contribution_rule='max')

    # Set parameters of the ganglion cell layer (GCL)

    sim.set_ganglion_cell_layer('Nanduri2012', tsample=t_gcl)
    # Define all the electrodes in a list
    if implant_name == 'ArgusII':
        eletters = ['A', 'B', 'C', 'D', 'E', 'F']
        enumbers = [str(i) for i in np.arange(1, 11, 1)]
        electrodes_names = [l + n for l in eletters for n in enumbers]
        n_height = len(eletters)
        n_width = len(enumbers)
    elif implant_name == 'ArgusI':
        eletters = ['A', 'B', 'C', 'D']
        enumbers = ['1', '2', '3', '4']
        electrodes_names = [l + n for n in enumbers for l in eletters]
        n_height = len(enumbers)
        n_width = len(eletters)
    return implant, sim, electrodes_names, n_width, n_height


class electrode:
    def __init__(self, name, amplitude, frequency, duration, pulse_type):
        self.name = name
        self.amplitude = amplitude
        self.frequency = frequency
        self.duration = duration
        self.amplitude_coeff = 0
        self.interphase_duration = 0.00045
        self.pulse_type = pulse_type

    def retrieve_data(self, values_range, parameter_name, implant_name):
        # Retrieve the current/intensity data for a given electrode
        for value in values_range:
            if parameter_name == 'amplitudes':
                X = np.load('.//Data//' + str(implant_name) + '//' + str(
                    parameter_name) + '_percept//' + self.name + '_amp' + str(value) + '.npy')
            elif parameter_name == 'durations':
                X = np.load('.//Data//' + str(implant_name) + '//' + str(
                    parameter_name) + '_percept//' + self.name + '_duration' + str(value) + '.npy')

            if 'data' not in locals():
                data = X.reshape((-1, 1))
            data = np.concatenate((data, X.reshape((-1, 1))), axis=1)
        data = np.delete(data, 0, axis=1)
        return data

    def linear_regression_electrode(self, values_range, parameter_name, implant_name):
        data = self.retrieve_data(values_range, parameter_name, implant_name)
        # Perform a linear regression on those data    
        from sklearn import linear_model
        length = data.shape[0]
        coef = np.zeros((length, 1))
        score = np.zeros((length, 1))
        for px in np.arange(length):
            # Create linear regression object
            regr = linear_model.LinearRegression()
            # Train the model using the training sets
            regr.fit(values_range.reshape(-1, 1), data[px,])
            score[px, 0] = regr.score(values_range.reshape(-1, 1), data[px,])
            coef[px, 0] = regr.coef_
        if parameter_name == 'amplitudes':
            self.amplitude_coeff = coef
            self.regression_score = score


def electrode_duration(electrodes, s_sample, t_sample, durations_range, sim, pulse_type):
    # os.mkdir('.//durations_percept')
    stimulus_duration = 1
    n_electrodes = len(electrodes.electrodes_list)
    durations = np.zeros(n_electrodes)
    electrodes.update_durations(durations)
    for electrode in electrodes.electrodes_list:
        # Compute the phosphene elicited for a range of current intensities for a given electrode
        i = 0
        for duration in durations_range:
            electrode.duration = duration
            frequency = 1 /stimulus_duration
            frequencies = frequency * np.ones(len(electrodes.electrodes_names))
            electrodes.update_frequencies(frequencies)
            percept = electrodes.p2p_prediction(sim, t_sample, stimulus_duration, pulse_type)
            frame = p2p.get_brightest_frame(percept)
            plt.figure(figsize=(8, 5))
            plt.imshow(frame.data, vmin=0, vmax=1, cmap='gray')
            plt.colorbar()
            pylab.savefig('..//Data//' + str(
                electrodes.implant_name) + '//durations_percept//' + electrode.name + '_duration' + str(
                duration) + '.png')
            np.save('.//Data//' + str(
                electrodes.implant_name) + '//durations_percept//' + electrode.name + '_duration' + str(duration),
                    frame.data)
            plt.close("all")
            i = i + 1
        electrode.duration = 0


def electrode_response_to_single_pulse(electrodes, sim, t_sample, amplitude=30, pulse_duration=0.00045,
                                       stimulus_duration=0.3, pulse_type='cathodicfirst'):
    frequency = 1 / (stimulus_duration - pulse_duration)
    frequencies = frequency * np.ones(len(electrodes.electrodes_names))
    amplitudes = np.zeros(len(electrodes.electrodes_names))
    durations = pulse_duration * np.ones(len(electrodes.electrodes_names))
    electrodes.update_amplitudes(amplitudes)
    electrodes.update_frequencies(frequencies)
    electrodes.update_durations(durations)
    time_resolution = 60
    new_t_sample = 1 / time_resolution  # time is resampled in order to have time_resolution frames/s
    dwnspl_factor = round(new_t_sample / t_sample)
    for electrode in electrodes.electrodes_list:
        electrode.amplitude = amplitude
        file = './/Data//' + str(
            electrodes.implant_name) + '//pulse_percept//' + electrode.name + '_pulse_response_time_' + 'amp' + str(
            amplitude)
        if not os.path.exists(file):
            percept = electrodes.p2p_prediction(sim, t_sample, stimulus_duration, pulse_type)
            frame = p2p.get_brightest_frame(percept)
            plt.figure(figsize=(8, 5))
            plt.imshow(frame.data, vmin=0, cmap='gray')
            plt.colorbar()
            pylab.savefig(
                './/Data//' + str(electrodes.implant_name) + '//amplitudes_percept//' + electrode.name + '_amp' + str(
                    amplitude) + '.png')
            np.save(
                './/Data//' + str(electrodes.implant_name) + '//amplitudes_percept//' + electrode.name + '_amp' + str(
                    amplitude), frame.data)
            plt.close("all")
            # downsampling the signal
            d = timeit.timeit()
            impulse_response = scipy.signal.resample_poly(percept.data, up=1, down=dwnspl_factor,
                                                          axis=2)  # *dwnspl_factor
            np.save(file, impulse_response)
            f = timeit.timeit()
            print(f - d)
        electrode.amplitude = 0


class electrodes_class:
    def __init__(self, electrodes_names, implant_name, amplitudes, frequencies, durations, n_width, n_height, sim,
                 t_sample, stimulus_duration):
        self.electrodes_names = electrodes_names
        self.electrodes_list = []
        self.interphase_duration = 0.00045
        self.n_height = n_height
        self.n_width = n_width
        self.implant_name = implant_name
        i = 0
        for name in electrodes_names:
            self.electrodes_list.append(
                electrode(name, amplitudes[i], frequencies[i], durations[i], pulse_type='cathodicfirst'))
            i = i + 1
        percept = self.p2p_prediction(sim, t_sample, stimulus_duration, pulse_type='cathodicfirst')
        self.height, self.width = percept.shape[0:2]

    def update_amplitudes(self, amplitudes):
        i = 0
        for electrode in self.electrodes_list:
            electrode.amplitude = amplitudes[i]
            i = i + 1

    def update_frequencies(self, frequencies):
        i = 0
        for electrode in self.electrodes_list:
            electrode.frequency = frequencies[i]
            i = i + 1

    def update_durations(self, durations):
        i = 0
        for electrode in self.electrodes_list:
            electrode.durations = durations[i]
            i = i + 1

    def p2p_prediction(self, sim, t_sample, stim_dur, pulse_type):
        stim = {}
        for electrode in self.electrodes_list:
            stim[electrode.name] = p2p.stimuli.PulseTrain(t_sample, freq=electrode.frequency, amp=electrode.amplitude,
                                                          dur=stim_dur, pulse_dur=electrode.duration,
                                                          interphase_dur=electrode.interphase_duration, delay=0,
                                                          pulsetype=electrode.pulse_type)
            # Run a simulation
        # - tol: ignore pixels whose efficient current is smaller than 10% of the max
        # - layers: simulate ganglion cell layer (GCL) and optic fiber layer (OFL),
        #   but ignore inner nuclear layer (INL) for now
        t_percept = 0.005 / 1000  # Sampling step (s) for the perceptual output
        percept = sim.pulse2percept(stim, t_percept=t_percept, tol=0.1, layers=['GCL', 'OFL'])
        return percept

    def coeff_electrodes(self, amplitude_range):
        for electrode in self.electrodes_list:
            electrode.linear_regression_electrode(amplitude_range, 'amplitudes', self.implant_name)

    def electrode_pulse_temporal_dynamics(self):
        i = 0
        for electrode in self.electrodes_list:

            electrode.amplitude = int(electrode.amplitude)
            file = './/Data//' + str(
                self.implant_name) + '//pulse_percept//' + electrode.name + '_pulse_response_time_amp' + str(
                int(electrode.amplitude)) + '.npy'
            percept = np.load(file)
            height, width = percept.shape[0:2]
            percept = percept.reshape(height * width, -1)

            percept_rescaled = np.divide(percept, electrode.amplitude_coeff)
            percept_rescaled_wo_nan = percept_rescaled[~np.isnan(percept_rescaled)].reshape(-1,
                                                                                            percept_rescaled.shape[1])

            if 'mean_percept' not in locals():
                mean_percept = np.zeros((len(self.electrodes_list), percept.shape[1]))
            mean_percept[i, :] = np.mean(percept_rescaled_wo_nan, axis=0)
            i = i + 1
        plt.figure(figsize=(8, 5))
        plt.plot(mean_percept.T)
        pylab.savefig('.//Data//' + str(self.implant_name) + '//temporal_percept//' + 'mean_' + 'pulse' + '.png')
        mean_percept = np.mean(mean_percept, axis=0)
        np.save('.//Data//' + str(self.implant_name) + '//temporal_percept//' + 'pulse_response', mean_percept)


class pulse_pattern:
    def __init__(self, electrodes, stim_duration, t_sample):
        self.n_time_points = round(stim_duration / t_sample)
        self.pattern = np.zeros((len(electrodes.electrodes_list), self.n_time_points))
        self.impulse_response = np.load(
            './/Data//' + str(electrodes.implant_name) + '//temporal_percept//' + 'pulse_response' + '.npy')
        self.stim_duration = stim_duration
        self.t_sample = t_sample

    def pulse_train(self, electrodes):
        i = 0
        for electrode in electrodes.electrodes_list:
            pulse_train = np.zeros((1, self.n_time_points))
            period = int(1 / (electrode.frequency * self.t_sample))
            number_of_periods = int(self.n_time_points / period)
            pulse_train[0, np.arange(number_of_periods) * period] = 1
            pulse_train = np.reshape(pulse_train, np.size(pulse_train))
            self.pattern[i, :] = pulse_train
            i = i + 1

    def predicted_response_to_pulses(self, electrodes):
        electrode_contribution = np.zeros(
            (len(electrodes.electrodes_list), electrodes.width * electrodes.height, self.n_time_points))
        i = 0
        for electrode in electrodes.electrodes_list:
            pulse_train = self.pattern[i, :]
            electrode_contribution[i, :, :] = np.outer(electrode.amplitude_coeff,
                                                       np.convolve(pulse_train, self.impulse_response)[
                                                       :self.n_time_points])
            i = i + 1
        predicted_response = np.sum(electrode_contribution, axis=0)
        model_output = predicted_response.reshape(electrodes.height, electrodes.width, -1)
        return model_output

    def video2pulsetrain(self, video_stim, implant, t_sample):
        # function to convert a stim object into a pulse_pattern_object
        changes = np.zeros(len(video_stim[0].data))
        for i in np.arange(len(video_stim)):
            peaks = video_stim[i].data < 0
            changes[1:] = peaks[:-1] != peaks[1:]
            if peaks[0]:
                changes[0] = 1
            t = 0
            for j in np.arange(len(changes)):
                if changes[j]:
                    if t % 2 != 0:
                        changes[j] = False
                    t = t + 1
            self.pattern[i, :] = -np.multiply(changes, video_stim[i].data)

    def pattern_downsampling(self, electrodes, dwnspl_factor):
        downsampled_pattern = np.zeros(
            (len(electrodes.electrodes_list), int(np.ceil(self.pattern.shape[1] / dwnspl_factor))))
        pad_size = dwnspl_factor - self.pattern.shape[1] % dwnspl_factor
        if pad_size == dwnspl_factor:
            pad_size = 0
        for j in np.arange(len(electrodes.electrodes_list)):
            dwnsampl_padded = np.append(self.pattern[j, :], np.zeros(pad_size) * np.NaN)
            dwnsampl_padded = dwnsampl_padded.reshape(-1, dwnspl_factor)
            dwnsampl_padded = np.nansum(dwnsampl_padded, axis=1)
            downsampled_pattern[j, :] = dwnsampl_padded
        self.pattern = downsampled_pattern
        self.n_time_points = self.pattern.shape[1]


def plot_inputs(img_in, img_stim, title, filename):
    plt.figure(figsize=(12, 4))
    plt.subplot(121)
    plt.imshow(img_in, cmap='gray')
    plt.title('Original image')
    plt.subplot(122)
    plt.imshow(img_stim, cmap='gray')
    plt.title(title);
    plt.savefig(filename)


def plot_percept(percept, title, filename):
    plt.figure(figsize=(12, 4))
    plt.imshow(percept, cmap='gray')
    plt.colorbar()
    plt.title(title)
    plt.savefig(filename)
