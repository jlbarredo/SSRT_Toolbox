function subjectSSRTs = QuantileMethodSSRT(go_GoRT, go_Correct, stop_SSD_actual, stop_Correct, stop_TrialComplete)
% QUANTILEMETHODSSRT - Calculate the SSRT for each subject using the
% quantile method, as described in "Measurement and Reliability of Response 
% Inhibition" by Congdon et al. (2012), Frontiers in Psychology. 

% Example usage: subjectSSRTs = QuantileMethodSSRT(go_GoRT, go_Correct, stop_SSD_actual, stop_Correct, stop_IsTrial);
%   such that go_GoRT, go_Correct, stop_SSD_actual, stop_Correct, and
%   stop_IsTrial are generated by the MergeSessions script. 
    
    numSubjectSlots = size(stop_SSD_actual, 1);
    subjectSSRTs = nan(numSubjectSlots, 1); % Initialize empty vector of NaN (not a number)
    
    for p = 1:numSubjectSlots % For each participant of subjectNumber p
        
        if nnz((stop_TrialComplete(p, :, :))) > 0 % If there is any data for this subject
        
            % Compute average stop signal delay for this subject. Nanmean is
            % like mean, but it ignores NaN values. 
            averageSSD = nanmean(reshape(stop_SSD_actual(p, :, :), 1, []));
            
            % Select trials for just this participant
            p_go_GoRT = go_GoRT(p, :, :);
            p_go_Correct = go_Correct(p, :, :);

            % Get all go reaction times where the response was correct, and
            % use data only from this participant
            p_correctGoRT = p_go_GoRT(p_go_Correct);

            % Sort selected GoRTs in ascending order
            p_correctGoRT = sort(p_correctGoRT);

            % Get proportion of failed inhibition (proportion of stop trials
            % where the participant failed to stop).
            propStopFail = 1 - ( nnz(stop_Correct(p, :, :)) / nnz(stop_TrialComplete(p, :, :)) );

            % Get the index of the correct GoRT corresponding to the proportion
            % of failed stop trials
            quantileInd = round(propStopFail*numel(p_correctGoRT));
            
            if quantileInd < 1
                fprintf(['Warning - index of correct GoRT corresponding to proportion of failed stop trials is zero, setting to 1 for subject # ' num2str(p) '\n']);
                quantileInd = 1;
            end
            
            if numel(p_correctGoRT) == 0
                fprintf(['No correct go trials for subject #' num2str(p) '. No SSRT calculated for this subject \n']);
            else
                
                % Choose the quantileRT, the go RT at the percentile
                % (quantile) corresponding to the proportion of failed stop
                % trials
                quantileRT = p_correctGoRT(quantileInd);
                
                % Estimate this subject's SSRT
                subjectSSRTs(p) = quantileRT - averageSSD;
            end
        
        end
        
    end
end