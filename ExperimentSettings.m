% INVESTIGATOR: Edit this file to customize the parameters of your SSRT
% experiment. Note that these values should not change during the entire
% experiment session (the running ssd values are stored in runningVals). 

% Set the name of the experiment, which will be added to the name of saved
% data files:
settings.ExperimentName = 'SSRT_exp';

% Set to "true" to display live performance metrics at the bottom of the 
% "Blank" screen during the experiment. To hide metrics, set to "false"
settings.DisplayPerfMetrics = true;

% Initial stop signal delay (SSD) times for staircases 1 and 2. Naming
% convention from E-Prime experiment used. Note that these are temporary
% variables that will NOT change during the experiment (runningVals.ssd1
% and runningVals.ssd2 are used instead). 
settings.g_nGoDur_initial = 0.140; % seconds. Typically 0.200
settings.g_nGoDur2_initial = 0.175; % seconds. Typically 0.300

% The stop signal delay (SSD) changes +/- between trials by this amount of
% time (staircase procedure)
settings.delta_t_initial = 0.010; % seconds

% This allows the delta_t values to decay exponentially over the course of
% the experiment. Because two interleaved staircases are used,
% delta_t_decay is actually split into runningVals.delta_t_decay1 and
% runningVals.delta_t_decay2 - one distinct value for each staircase. 
% Set the value to 1 to keep delta_t constant throughout the experiment
% session. For an experiment session with 32 stop trials and 
% delta_t_initial, of 0.10s, a value of 0.8 seems to work well. Try running 
% the "visualize_staircase_decay" script in the misc_tools folder to see 
% what happens to delta_t with different starting values and decay values. 
settings.delta_t_decay = 0.8;

% Duration of stop signal beep. g_nInhDur in E-Prime.
settings.InhDur = 0.250; % seconds

% Frequency of the stop signal beep tone
settings.BeepFreq = 500; %Hz

% Total trial duration. g_TrialDur in E-Prime.
settings.TrialDur = 1.0; % seconds

% Duration of fixation before each trial
settings.FixationDuration = 0.5; % seconds

% Duration of blank screen after each trial
settings.BlankDuration = 1.0; % seconds

% Size of arrow graphics (arbitrary units). Make larger/smaller to change
% size of the arrows displayed during trials. 
settings.ArrowSize = 10; % 10 is a good starting point