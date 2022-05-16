# Preferential Bayesian Optimization of retinal prosthetic stimulation

## Requirements:
This software accompanies the paper : Fauvel T. and Chalk M, 2021, Human-in-the-loop optimization of retinal prostheses encoders.
If you use this software, please reference it by citing this paper.


* MATLAB
* Psychtoolbox (Optional) http://psychtoolbox.org/download.html
* Python 3
* Pulse2percept, by Beyeler et al (2017):
	* You can either choose to work with the stable version (0.7.1) of pulse2percept or the latest one (0.8.0).
	* To use the stable release, use `pip3 install pulse2percept`
	* To install the latest release, use `pip3 install git+https://github.com/pulse2percept/pulse2percept`
* BO_toolbox : Bayesian Optimization toolbox based on the GP_toolbox, https://github.com/TristanFauvel/BO_toolbox   
* GP_toolbox : Gaussian Process regression, classification, and preference learning, https://github.com/TristanFauvel/GP_toolbox


* In the pulse2percept package installation folder, replace beyeler2019.py in /envs/pulse2percept-env/lib/python3.8/site-packages/pulse2percept/models with the file beyeler2019 in /p2p_modifications (if you use the stable p2p release)
or by beyeler2019_modified_for_latest_p2p (if you use the latest release, and rename the file in beyeler2019).
* Edit the file 'add_modules' according to the locations of the different folders on your computer.
* To run an experiment : `open('to_run_BO_experiment')`
	* If you want to use Psychtoolbox : set use_ptb3 = 1
	* If you do not want to use Psychtoolbox : set use_ptb3 = 0


## Run and analyze experiments:
* Activate the Python environment in which pulse2percept is installed: `conda activate pulse2percept_env`
* Launch Matlab with Psychtoolbox : `ptb3-matlab`
* To launch experiments: `to_run_BO_experiment.m`
* To analyze experiments:
	`analysis_pipeline.m`
* Note that the first time you run vision tests, likelihoods used in the QUEST+ procedure will be computed, which can take a while (`QPlikelihoods_E_VA.mat` and `QPlikelihoods_Snellen_VA.mat`).

## Organization :

	* `Experiment`: scripts and functions to run the experiment described in the paper.
	* `p2p_modifications` : contains modified p2p files required in order to run the experiment.
	* `p2p_analysis`: code to perform the p2p analysis leading to the LN approximation described in the paper. Note that this analysis was performed on pulse2percept 0.5.0.
	* `QuestPlus-master` : a Matlab implementation of the QUEST+ adaptive psychometric method, by Pete R Jones.
  * `Stimuli` : stimuli images used in the experiment

## pulse2percept analysis:
* The first thing to do is to compute M, the matrix of electrodes' projective fields: to do so, run `to_compute_M.py`.
* To compare the output of the LN approximation and the original p2p model with random currents, use `WN_electrodes.py`.
* To perform a visua comparison between the output of p2p and the LN approximation (in particular, for optimized stimuli) use `optimized_code_stimuli.py`.
