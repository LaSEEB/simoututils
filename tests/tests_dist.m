%
% Unit tests for SimOutUtils dist functions
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
%
% To run the tests: 
% 1 - Make sure MOxUnit is on the MATLAB/Octave path
% 2 - Make sure SimOutUtils is on the MATLAB/Octave path by running
%     startup.m
% 3 - cd into the tests folder
% 4 - Invoke the moxunit_runtests script
%
% Copyright (c) 2016-2017 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%
function test_suite = tests_dist
    try
        % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions();
    catch
        % no problem; early Matlab versions can use initTestSuite fine
    end;
    initTestSuite

% Test stats_table_per_setup function
function test_stats_table_per_setup
    
    % Set RNG to a specific reproducible state
    if is_octave()
        rand('seed', 2222);
    else
        rng(2222, 'twister');
    end;

    %
    % Setup test cases
    %
    nobs = [5 25 50];
    nouts = [1 5 10];
    nss = [1 5];
    alphas = [0.001 0.05];
    formats = [0 1];
    
    % Create template outputs and statistical summary vectors
    outs = cell(1, max(nouts));
    for i = 1:numel(outs), outs{i} = ['o' int2str(i)]; end;
    sss = cell(1, max(nss));
    for i = 1:numel(sss), sss{i} = ['ss' int2str(i)]; end;
    
    % Perform tests for all test cases
    for i = nobs
        for j = nouts
            for k = nss
                for l = alphas
                    for m = formats
                        
                        % Artificially create stats_gather data
                        sg =  struct('name', 'sg', ...
                            'sdata', randn(i, j * k), ...
                            'outputs', {outs(1:j)}, ...
                            'ssnames', ...
                            struct('text', {sss(1:k)}, ...
                            'latex', {sss(1:k)}));
                        
                        % Generate table
                        t = stats_table_per_setup(sg, l, m);
                        
                        % Check if table is char
                        assertEqual(class(t), 'char');
                        
                        % Uncomment the lines below to see the generated
                        % text tables
%                         if m == 0 % Or m == 1 to see LaTeX tables
%                             fprintf('nobs=%d, nouts=%d, nss=%d, alpha=%f\n%s\n', ...
%                                 i, j, k, l, t);
%                         end;

                    end;
                end;
            end;
        end;
    end;

% Test dist_table_per_setup function
function test_dist_table_per_setup
    
    % Set RNG to a specific reproducible state
    if is_octave()
        rand('seed', 2345);
    else
        rng(2345, 'twister');
    end;

    %
    % Setup test cases
    %
    nobs = [5 25 50];
    nouts = [1 4 8];
    nss = [1 5];
    
    % Create template outputs and statistical summary vectors
    outs = cell(1, max(nouts));
    for i = 1:numel(outs), outs{i} = ['o' int2str(i)]; end;
    sss = cell(1, max(nss));
    for i = 1:numel(sss), sss{i} = ['ss' int2str(i)]; end;
    
    % Perform tests for all test cases
    for i = nobs
        for j = nouts
            for k = nss
                
                % Artificially create stats_gather data
                sg =  struct('name', 'sg', ...
                    'sdata', randg(3, i, j * k), ...
                    'outputs', {outs(1:j)}, ...
                    'ssnames', ...
                    struct('text', {sss(1:k)}, ...
                    'latex', {sss(1:k)}));
                
                % Generate table
                t = dist_table_per_setup(sg);
                
                % Check if table is char
                assertEqual(class(t), 'char');
                
            end;
        end;
    end;
