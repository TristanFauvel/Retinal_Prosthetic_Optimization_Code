# -*- coding: utf-8 -*-
"""
Created on Mon Dec  3 14:25:20 2018

@author: Tristan*
"""

from pulse2percept import utils
import scipy.special as ss

class TemporalModel:
    """Latest edition of the temporal sensitivity model (experimental)

    This class implements the latest version of the temporal sensitivity
    model(experimental). As such, the model might still change from version
    to version. For more stable implementations, please refer to other,
    published models(see `p2p.retina.SUPPORTED_TEMPORAL_MODELS`).

    Parameters
    ----------
    tsample: float, optional, default: 0.005 / 1000 seconds
        Sampling time step(seconds).
    tau_gcl: float, optional, default: 45.25 / 1000 seconds
        Time decay constant for the fast leaky integrater of the ganglion
        cell layer(GCL).
        This is only important in combination with epiretinal electrode
        arrays.
    tau_inl: float, optional, default: 18.0 / 1000 seconds
        Time decay constant for the fast leaky integrater of the inner
        nuclear layer(INL); i.e., bipolar cell layer.
        This is only important in combination with subretinal electrode
        arrays.
    tau_ca: float, optional, default: 45.25 / 1000 seconds
        Time decay constant for the charge accumulation, has values
        between 38 - 57 ms.
    scale_ca: float, optional, default: 42.1
        Scaling factor applied to charge accumulation(used to be called
        epsilon).
    tau_slow: float, optional, default: 26.25 / 1000 seconds
        Time decay constant for the slow leaky integrator.
    scale_slow: float, optional, default: 1150.0
        Scaling factor applied to the output of the cascade, to make
        output values interpretable brightness values >= 0.
    lweight: float, optional, default: 0.636
        Relative weight applied to responses from bipolar cells(weight
        of ganglion cells is 1).
    aweight: float, optional, default: 0.5
        Relative weight applied to anodic charges(weight of cathodic
        charges is 1).
    slope: float, optional, default: 3.0
        Slope of the logistic function in the stationary nonlinearity
        stage.
    shift: float, optional, default: 15.0
        Shift of the logistic function in the stationary nonlinearity
        stage.
    """

    def __init__(self, t_sample):
        # Set default values of keyword arguments
        self.tau_gcl = 0.42 / 1000
        self.tau_inl = 18.0 / 1000
        self.tau_ca = 45.25 / 1000
        self.tau_slow = 26.25 / 1000
        self.scale_ca = 42.1
        self.scale_slow = 1150.0
        self.lweight = 0.636
        self.aweight = 0.5
        self.slope = 3.0
        self.shift = 15.0
        self.tsample=t_sample
#        # perform one-time setup calculations
#        _, self.gamma_inl = utils.gamma(1, self.tau_inl, self.tsample)
#        _, self.gamma_gcl = utils.gamma(1, self.tau_gcl, self.tsample)
#
#        # gamma_ca is used to calculate charge accumulation
#        _, self.gamma_ca = utils.gamma(1, self.tau_ca, self.tsample)

        # gamma_slow is used to calculate the slow response
        _, self.gamma_slow = utils.gamma(3, self.tau_slow, self.tsample)

    def stationary_nonlinearity(self, stim):
        """Stationary nonlinearity

        Nonlinearly rescale a temporal signal `stim` across space and time,
        based on a sigmoidal function dependent on the maximum value of `stim`.
        This is Box 4 in Nanduri et al. (2012).
        The parameter values of the asymptote, slope, and shift of the logistic
        function are given by self.asymptote, self.slope, and self.shift,
        respectively.

        Parameters
        ----------
        stim: array
           Temporal signal to process, stim(r, t) in Nanduri et al. (2012).

        Returns
        -------
        Rescaled signal, b4(r, t) in Nanduri et al. (2012).

        Notes
        -----
        Conversion to TimeSeries is avoided for the sake of speedup.
        """
        # use expit (logistic) function for speedup
        sigmoid = ss.expit((stim.max() - self.shift) / self.slope)
        return stim * sigmoid
    

    def fast_response(self, stim, gamma, method, use_jit=True):
            """Fast response function
    
            Convolve a stimulus `stim` with a temporal low - pass filter `gamma`.
    
            Parameters
            ----------
            stim: array
               Temporal signal to process, stim(r, t) in Nanduri et al. (2012).
            use_jit: bool, optional
               If True (default), use numba just - in-time compilation.
            usefft: bool, optional
               If False (default), use sparseconv, else fftconvolve.
    
            Returns
            -------
            Fast response, b2(r, t) in Nanduri et al. (2012).
    
            Notes
            -----
            The function utils.sparseconv can be much faster than np.convolve and
            signal.fftconvolve if `stim` is sparse and much longer than the
            convolution kernel.
            The output is not converted to a TimeSeries object for speedup.
            """
            conv = utils.conv(stim, gamma, mode='full', method=method,
                              use_jit=use_jit)
    
            # Cut off the tail of the convolution to make the output signal
            # match the dimensions of the input signal.
            return self.tsample * conv[:stim.shape[-1]]
        
        
    def slow_response(self, stim):
            """Slow response function
    
            Convolve a stimulus `stim` with a low - pass filter(3 - stage gamma)
            with time constant self.tau_slow.
            This is Box 5 in Nanduri et al. (2012).
    
            Parameters
            ----------
            stim: array
               Temporal signal to process, stim(r, t) in Nanduri et al. (2012)
    
            Returns
            -------
            Slow response, b5(r, t) in Nanduri et al. (2012).
    
            Notes
            -----
            This is by far the most computationally involved part of the perceptual
            sensitivity model.
            Conversion to TimeSeries is avoided for the sake of speedup.
            """
            # No need to zero-pad: fftconvolve already takes care of optimal
            # kernel/data size
            conv = utils.conv(stim, self.gamma_slow, method='fft', mode='full')
    
            # Cut off the tail of the convolution to make the output signal match
            # the dimensions of the input signal.
            return self.scale_slow * self.tsample * conv[:stim.shape[-1]]
        
        
        
    def model_cascade(self, brightness):
            """The Temporal Sensitivity model
    
            This function applies the model of temporal sensitivity to a single
            retinal cell(i.e., a pixel). The model is inspired by Nanduri
            et al. (2012), with some extended functionality.
    
            Parameters
            ----------
            ecs_item: array - like
                A 2D array specifying the effective current values at a particular
                spatial location(pixel); one value per retinal layer and
                electrode.
                Dimensions: <  # layers x #electrodes>
            pt_list: list
                A list of PulseTrain `data` containers.
                Dimensions: <  # electrodes x #time points>
            layers: list
                List of retinal layers to simulate. Choose from:
                - 'OFL': optic fiber layer
                - 'GCL': ganglion cell layer
                - 'INL': inner nuclear layer
            use_jit: bool
                If True, applies just - in-time(JIT) compilation to expensive
                computations for additional speed - up(requires Numba).
    
            Returns
            -------
            Brightness response over time. In Nanduri et al. (2012), the
            maximum value of this signal was used to represent the perceptual
            brightness of a particular location in space, B(r).
            """
#            resp=brightness
#            #resp = self.stationary_nonlinearity(brightness)
#            output = self.slow_response(resp)
            output=brightness
            return output
