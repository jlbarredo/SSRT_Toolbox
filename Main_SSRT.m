% To run an experiment session, enter "Main_SSRT" into the MATLAB console, 
% or press the "Run" betton in the menu above under the "EDITOR" tab. 

% Clear the workspace and the screen, close all plot windows
close all;
clear;
sca;

% Make sure the code files in /code_backend are accessible to MATLAB
addpath('./code_backend/');

% Contains the pre-generated "trials" struct array
load('CURRENTTRIALS.mat', 'trials');

% Set user-defined variables to configure experiment. creates a workspace
% struct variable called 'settings'. Settings variables should NEVER change
% during the experiment session. 
ExperimentSettings;

% Set up running values that change during the experiment session (live 
% performance metrics, two changing stop-signal delays associated with the 
% two staircases) 
InitRunningVals;   

% Timestamps for beginning of experiment
sessionStartDateTime = datevec(now);
runningVals.GetSecsStart = GetSecs;

% Use dialog boxes to get subject number, session number, etc. from the experimenter
[subjectNumber, sessionNumber, subjectHandedness, cancelled] = GetSessionConfig();
if (cancelled)
    disp('Session cancelled by experimenter');
    return; % Stops this script from running to end the experiment session
end
clear cancelled;

% Initialize the user interface (ui) and PsychToolbox
ui = UserInterface(settings);

% Use the ui to show experiment instructions
ui.ShowInstructions();

% Use the ui to show the "ready" screen with a timer
ui.ShowReadyTimer();

% Use the ui to show a fixation cross for the specified amount of time in
% seconds
ui.ShowFixation(0.5, runningVals);

% Loop through the trials structure (note - runningVals.currentTrial keeps
% track of which trial you are on)
while (runningVals.currentTrial <= length(trials))
    % Show the fixation cross
    ui.ShowFixation(settings.FixationDur, runningVals);
    
    % Run the go or stop trial (depending on what is in this row of the
    % trial struct)
    [trials, runningVals] = ui.RunNextTrial(trials, settings, runningVals);
    
    % Update the live performance metrics that are optionally displayed on
    % the screen (see ExperimentSettings.m to disable/enable)
    runningVals = UpdateLivePerfMetrics(runningVals);
    
    % Show a blank screen
    ui.ShowBlank(settings.BlankDur, runningVals);
    
    % Autosave data in case the experiment is interrupted partway through
    save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness');
end

% Clear the screen
sca;

% Save the data to a .mat, delete autosaved version
save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness');
delete(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat']);

% Clear unneeded variables. Experiment session ends after these lines. 
sca;
PsychPortAudio('Close');
clear ui filename;