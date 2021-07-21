# Preferential Bayesian Optimization of retinal prosthetic stimulation

## Requirements:
This software accompanies the paper : Fauvel T. and Chalk M, 2021, Human-in-the-loop optimization of retinal prostheses encoders.
If you use this software, please reference it by citing this paper.

## Requirements:

* MATLAB
* Psychtoolbox (Optional) http://psychtoolbox.org/download.html
* Python 3
* Pulse2percept :
	* You can either choose to work with the stable version of pulse2percept or the latest one.
	* To use the stable release, use `pip3 install pulse2percept`
	* To install the latest release, use pip3 install git+https://github.com/pulse2percept/pulse2percept
	* You can alternate between the two versions by installing them in different virtual environments.

* Run `install.m` to install the GPML toolbox
* In the pulse2percept package installation folder, replace beyeler2019.py by the file beyeler2019 in Code_Optim_Retina.
* Edit the file 'add_modules' according to the locations of the different folders on your computer.
* To run an experiment : `open('to_run_BO_p2p')`
	* If you want to use Psychtoolbox : set use_ptb3 = 1
	* If you do not want to use Psychtoolbox : set use_ptb3 = 0

* Remark :
## Run and analyze experiments:
* Activate the Python environment in which pulse2percept is installed: `conda activate pulse2percept_env`
* Launch Matlab with Psychtoolbox : `ptb3-matlab`
* To analyze an experiment:
	`to_analyze_BO_preference_experiment.m`
* To plot the results of an experiment :
	`plot_BO_p2p_results.m` and `acuity_plot.m`

## Code organization:
* BO_toolbox : Bayesian Optimization toolbox based on the GP_toolbox.   
* GP_toolbox : Gaussian Process regression and classification.
* Preference_Based_BO_toolbox contains : Preferential Bayesian Optimization baysed on BO_toolbox and GP_toolbox.
* Rasmussen_Williams: GPML toolbox http://www.gaussianprocess.org/gpml/code/matlab/doc/
* Stimuli : Folder containing all the stimuli used in the experiments.
* Experiment_p2p_preference : code to run, analyze and plot the experiments.
* modified_p2p : a few function to call the pulse2percept package.
* tools : various functions used in the experiments and analysis.
