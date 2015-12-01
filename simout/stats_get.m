function sdata = stats_get(file, num_outputs, ss_idx)
% STATS_GET Get statistical summaries (max, argmax, min, argmin, mean,
% std) taken from simulation outputs from one file.
%
%   stats = STATS_GET(file, num_outputs, ss_idx)
%
% Parameters:
%       file  - file containing simulation outputs, columns correspond to 
%               outputs, rows correspond to iterations.
% num_outputs - number of outputs in file
%      ss_idx - iteration after which outputs are in steady-state (for mean
%               and std statistical summaries).
%
% Returns:
%       sdata - a 6 x num_outputs matrix, with 6 statistical summaries and
%               num_outputs outputs.
%
% Details:
%   The format of the data in each file is the following: columns 
%   correspond to outputs, while rows correspond to iterations.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Read stats file
data = dlmread(file);
dataLen = size(data, 1);

% Initialize stats matrix
sdata = zeros(6, num_outputs);

% Determine stats for each of the outputs
for i=1:num_outputs
    
    % Iterations start at zero, but Matlab starts indexing at 1, so we have
    % to subtract index by one.
    
    % Get current output
    curOutput = data(:, i);
    % Get maximum
    curMax = max(curOutput);
    % Get iteration where maximum occurs
    curArgMax = find(curOutput == curMax, 1) - 1;
    % Get minimum
    curMin = min(curOutput);
    % Get iteration where minimum occurs
    curArgMin = find(curOutput == curMin, 1) - 1;
    % Get steady-state mean
    curMean = mean(curOutput((ss_idx + 1):dataLen));
    % Get steady-state standard deviation
    curStd = std(curOutput((ss_idx + 1):dataLen));
 
    % Place current output statistics in output variable
    sdata(:, i) = [curMax; curArgMax; curMin; curArgMin; curMean; curStd];
    
end;