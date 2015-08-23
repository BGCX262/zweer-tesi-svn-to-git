classdef Test < handle
    %TEST Does the whole testing of a recommendation algorithm, eventually
    %exporting the results.
    %
    %   Public properties:
    %       - URM
    %       - URMProbe
    %       - Algorithm
    %       - Method
    %
    %   Readonly properties:
    %       - Path
    %       - Result
    %
    %   Methods:
    %       - Test (constructor)
    %       - fire
    
    properties
        URM % The name of the URM matrix.
        URMProbe % The name of the Probe matrix, which is taken from the URM one.
        Algorithm % The algorithm used for the test.
        Method % The method used for the test.
    end
    properties (SetAccess = private)
        Path % The path to this file. Used to find the algorithm classes.
        Result = [] % An array of struct of results from each test.
    end
    
    methods
        function T = Test(URM, URMProbe, Algorithm, Method)
            %TEST(URM, URMPROBE, ALGORITHM, METHOD)
            %   The constructor.
            %   No optional parameter.
            %   URM is the name of the variable with the matrix. It must be
            %   in the workspace or in a .mat/.mm file in the path.
            %   URMPROBE is the name of the variable with the Probe matrix.
            %   It must be in the workspace or in a .mat/.mm file in the
            %   path.
            %   ALGORITHM is the algorithm used to compute the Model and
            %   then the Result of the Recommendation.
            %   METHOD is the method used to formulate the Test.
            if(nargin ~= 4)
                help Test.Test;
                return;
            end
            
            [T.Path, ~, ~] = fileparts(which('Test.m'));
            
            T.URM = URM;
            T.URMProbe = URMProbe;
            T.Algorithm = Algorithm;
            T.Method = Method;
        end % Test
        
        function Result = fire(T, MethodParameters, ModelParameters, OnLineParameters)
            %FIRE(METHOD_PARAMETERS, MODEL_PARAMETERS, ONLINE_PARAMETERS) 
            %executes the test in the given method using the given
            %parameters.
            %   All parameters are optional.
            %   METHOD_PARAMETERS is a struct with the parameters of the
            %   test method.
            %   METHOD_PARAMETERS.PositiveTestSize is the percentage of the
            %   Probe matrix to be considered as a positive test.
            %   METHOD_PARAMETERS.NegativeTestSize is the percentage of the
            %   Probe matrix to be considered as a negative test.
            %   For the MODEL_PARAMETERS and the ONLINE_PARAMETERS please
            %   refer to the documentation of the createModel and
            %   onLineRecom functions.
            if(isempty(T.URM))
                error('The test has not a URM matrix. Please specify it first!');
            end
            
            if(isempty(T.URMProbe))
                error('The test has not a URMProbe matrix. Please specify it first!');
            end
            
            if(isempty(T.Algorithm))
                error('The test has not an algorithm. Please specify it first!');
            end
            
            if(isempty(T.Method))
                error('The test has not a method. Please specify it first!');
            end
            
            if(~exist('MethodParameters', 'var'))
                MethodParameters.Path = T.Path;
            end
            
            if(~exist('ModelParameters', 'var'))
                ModelParameters.Path = T.Path;
            end
            
            if(~exist('OnLineParameters', 'var'))
                OnLineParameters.Path = T.Path;
            end
            
            PathMethods = [T.Path filesep 'Methods' filesep T.Method];
            addpath(PathMethods);
            
            Result = initializeMethod(T.URM, T.URMProbe, T.Algorithm, MethodParameters, ModelParameters, OnLineParameters);
            T.Result = [T.Result; Result];
            
            rmpath(PathMethods);
        end
        
        function set.URM(T, URM)
            if(evalin('base', ['exist(''' URM ''', ''var'')']) == 1)
                T.URM = URM;
            elseif(exist(URM, 'file') == 2)
                T.URM = ['URM' num2str(floor(rand() * 1000))];
                evalin('base', [T.URM ' = importdata(''' URM ''');']);
            end
        end % set.URM
        
        function set.URMProbe(T, URMProbe)
            if(evalin('base', ['exist(''' URMProbe ''', ''var'')']) == 1)
                T.URMProbe = URMProbe;
            elseif(exist(URMProbe, 'file') == 2)
                T.URMProbe = ['URMProbe' num2str(floor(rand() * 1000))];
                evalin('base', [T.URMProbe ' = importdata(''' URMProbe ''');']);
            end
        end % set.URMProbe
        
        function set.Algorithm(T, Algorithm)
            if(isdir([T.Path filesep 'Algorithms' filesep Algorithm]))
                T.Algorithm = Algorithm;
            else
                disp('The selected algorithm doesn''t exist. Please try with another one:');
                DIR = dir([T.Path filesep 'Algorithms']);
                for i = 1:length(DIR)
                    if(~strcmp('.', DIR(i).name) && ~strcmp('..', DIR(i).name))
                        disp(['- ' DIR(i).name]);
                    end
                end
            end
        end % set.Algorithm
        
        function set.Method(T, Method)
            if(isdir([T.Path filesep 'Methods' filesep Method]))
                T.Method = Method;
            else
                disp('The selected method doesn''t exist. Please try with another one:');
                DIR = dir([T.Path filesep 'Methods']);
                for i = 1:length(DIR)
                    if(~strcmp('.', DIR(i).name) && ~strcmp('..', DIR(i).name))
                        disp(['- ' DIR(i).name]);
                    end
                end
            end
        end % set.Method
    end
end

