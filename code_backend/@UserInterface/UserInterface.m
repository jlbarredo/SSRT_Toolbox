classdef UserInterface < handle
% USERINTERFACE - Wrapper class that contains PsychToolbox functions. Main
% script 'Main_SSRT.m' works by using functions in this class.
    
    properties (GetAccess=private)
        % Settings (initialized once by main script, never change during
        % experiment)
        settings;
        
        % Screen properties
        window;
        windowRect;
        screenXpixels;
        screenYpixels;
        xCenter;
        yCenter;
        
        % Images
        arrow_tex_left;
        arrow_tex_right;
        arrow_rect;
        
        % Sound parameters
        snd_stopBeep;
        snd_pahandle;
        snd_repetitions;
        snd_startCue;
        snd_waitForDeviceStart;
        snd_latency;
    end
    
    properties(Constant)
        %---COLOR DEFINITIONS---%
        c_black = [0 0 0]; % formerly BlackIndex(screenNumber);
        c_white = [1 1 1]; % formerly WhiteIndex(screenNumber);
        c_yellow = [1 1 0];
    end
    
    methods
        function obj = UserInterface(settings_init)
            
            obj.settings = settings_init;
            
            % Call some default settings for setting up Psychtoolbox
            PsychDefaultSetup(2);
            
            %---KEYBOARD SETUP---%
            
            % Needed for the experiment to run on different operating systems with
            % different key code systems
            KbName('UnifyKeyNames');
            
            % Enable all keyboard keys for key presses
            RestrictKeysForKbCheck([]);

            %---SCREEN SETUP---%

            % Get the screen numbers
            screens = Screen('Screens');

            % Select the external screen if it is present, else revert to the native
            % screen
            screenNumber = max(screens);

            % Open an on screen window and color it grey
            [obj.window, obj.windowRect] = PsychImaging('OpenWindow', screenNumber, obj.c_black);

            % Set the blend function for the screen
            Screen('BlendFunction', obj.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

            % Get the size of the on screen window in pixels
            % For help see: Screen WindowSize?
            [obj.screenXpixels, obj.screenYpixels] = Screen('WindowSize', obj.window);

            % Get the centre coordinate of the window in pixels
            % For help see: help RectCenter
            [obj.xCenter, obj.yCenter] = RectCenter(obj.windowRect);

            %---SOUND SETUP---%

            % Initialize snd driver
            InitializePsychSound(1);

            % Number of channels and Frequency of the sound
            snd_nrchannels = 2;
            snd_playbackFreq = 48000;

            % How many times to we wish to play the sound
            obj.snd_repetitions = 1;

            % Start immediately (0 = immediately)
            obj.snd_startCue = 0;

            % Should we wait for the device to really start (1 = yes)
            % INFO: See help PsychPortAudio
            obj.snd_waitForDeviceStart = 1;
            
            % Adding a small sound latency makes the beginning of the sound
            % cleaner. if this is set to 0, sound card will attempt to
            % start playing the sound before everything is actually ready.
            % This delay should be accounted for when playing the sound in
            % the experiment. 
            obj.snd_latency = 0.045;

            % Open Psych-Audio port, with the follow arguements
            % (1) [] = default snd device
            % (2) 1 = snd playback only
            % (3) [] = default level of latency
            % (4) Requested frequency in samples per second
            % (5) 2 = stereo output
            % (6) Set latency
            obj.snd_pahandle = PsychPortAudio('Open', [], 1, [], snd_playbackFreq, snd_nrchannels, [], obj.snd_latency);

            % Set the volume to full (change 1 to eg. 0.5 for half volume)
            PsychPortAudio('Volume', obj.snd_pahandle, 1);

            % Make a beep which we will play back to the user
            obj.snd_stopBeep = MakeBeep(obj.settings.BeepFreq, obj.settings.InhDur, snd_playbackFreq);
            
            % Fill the audio playback buffer with the audio data, doubled for stereo
            % presentation
            PsychPortAudio('FillBuffer', obj.snd_pahandle, [obj.snd_stopBeep; obj.snd_stopBeep]);
            
            %---IMAGE SETUP---%

            arrow_img_left = double(imread('media/Left_Arrow.bmp'));
            arrow_img_right = double(imread('media/Right_Arrow.bmp'));

            obj.arrow_tex_left = Screen('MakeTexture', obj.window, arrow_img_left);
            obj.arrow_tex_right = Screen('MakeTexture', obj.window, arrow_img_right);
            
            [s1, s2, ~] = size(arrow_img_left); % arrow_img_right is same size
            
            % Get the aspect ratio of the image. We need this to maintain the aspect
            % ratio of the image. Otherwise, if we don't match the aspect 
            % ratio the image will appear warped / stretched
            aspectRatio = s2 / s1;
            
            arrow_height = 0.01*obj.settings.ArrowSize*obj.screenXpixels;
            
            arrow_width = arrow_height * aspectRatio;
            
            obj.arrow_rect = [0 0 arrow_width arrow_height];
            
            obj.arrow_rect = CenterRectOnPointd(obj.arrow_rect, obj.screenXpixels / 2, obj.screenYpixels / 2);
        end
        
        ShowInstructions(obj);
        
        ShowReadyTimer(obj);
        
        ShowFixation(obj, duration, runningVals);
        
        ShowBlank(obj, duration, runningVals);
        
        RunTrial(obj, StopGo, arrowDirection, trialLength, varargin);
        
        [trials, runningVals] = RunNextTrial(obj, trials, settings, runningVals);
        
    end
    
    methods (Access = private)
        DrawPerformanceMetrics(obj, runningVals);
    end
end