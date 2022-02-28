cd(experiment_directory)


python_env = pyenv;
%python_env = pyenv("ExecutionMode","OutOfProcess");
if python_env.Status == 'NotLoaded' && python_env.ExecutionMode  == 'InProcess'
    pyenv('ExecutionMode', 'OutOfProcess');
end

if (strcmp(p2p_version, 'stable') && strcmp(python_env.Home, "/home/tfauvel/anaconda3/envs/pulse2percept_latest_env"))
    error('You need to run this code in the environment where the stable version of pulse2percept')
elseif (strcmp(p2p_version, 'latest') && strcmp(python_env.Home, "/home/tfauvel/anaconda3/envs/pulse2percept_stable_env"))
    error('You need to run this code in the environment where the latest version of pulse2percept')
end

if python_env.Status == 'NotLoaded' && isunix
    RTLD_NOW=2;
    RTLD_DEEPBIND=8;
    flag=bitor(RTLD_NOW, RTLD_DEEPBIND);
    py.sys.setdlopenflags(int32(flag));
end

if isempty(pymod)
    if strcmp(experiment.p2p_version, 'stable')
        pymod = py.importlib.import_module('perceptual_model');
    elseif strcmp(experiment.p2p_version, 'latest')
        pymod = py.importlib.import_module('perceptual_model_latest');
    end
end
