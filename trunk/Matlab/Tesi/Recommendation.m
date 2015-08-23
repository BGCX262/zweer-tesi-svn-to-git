classdef Recommendation < handle
    %RECOMMENDATION Does an entire recommendation creating the model and
    %then doing the classification of all the "more confortable" items
    %relative to a user profile.
    %   
    %   Public Properties:
    %       - Algorithm
    %       - URM
    %   
    %   Readonly Properties:
    %       - Path
    %       - Model
    %       - Result
    %   
    %   Methods:
    %       - Recommendation (constructor)
    %       - createModel
    %       - onLineRecom
    %       - antiReshuffling
    %       - export
    
    properties
        Algorithm % The algorithm used to create the Model and then to find the Recommendation.
        URM % The name of the matrix from which the model is generated.
    end % properties
    properties (SetAccess = private)
        Path % The path to this file. Used to find the algorithm classes.
        Model % The model of the recommendation.
        Result = [] % An array of struct of recommendations, each with the profile used (Result[i].UserProfile, Result[i].List, Result[i].Ranking).
    end % properties (SetAccess  private)
    
    methods
        function R = Recommendation(URM, Algorithm)
            %RECCOMENDATION(URM, ALGORITHM)
            %   The constructor.
            %   No optional parameter.
            %   URM is the name of the variable with the matrix. It must be
            %   in the workspace or in a .mat/.mm file in the path.
            %   ALGORITHM is the algorithm used to compute the Model and
            %   then the Result of the Recommendation.
            if(nargin ~= 2)
                help Recommendation.Recommendation;
                return;
            end % if(nargin ~= 2)
            
            [R.Path, ~, ~] = fileparts(which('Recommendation.m'));
            
            R.URM = URM;
            R.Algorithm = Algorithm;
        end % Recommendation
        
        function createModel(R, Parameters)
            %CREATEMODEL(PARAMETERS)
            %   Creates the model of the recommendation. It uses the URM
            %   matrix and the Algorithm bassed before and stores the
            %   result in the Result property.
            %   PARAMETERS is an optional parameter, a struct that contains
            %   all the parameters to be passed to the model function.
            if(isempty(R.Algorithm) == 1)
                disp('The Algorithm property isn''t set. Please set it before creating the Model!');
                return;
            end % if(isempty(R.Algorithm) == 1)
            if(isempty(R.URM) == 1)
                disp('The URM matrix isn''t set. Please set it before creating the Model!');
                return;
            end % if(isempty(R.URM) == 1)
            
            Parameters.Path = R.Path;
            
            Path = [R.Path filesep 'Algorithms' filesep R.Algorithm];
            addpath(Path);
            
            R.Model = createModel(evalin('base', R.URM), Parameters);
            
            rmpath(Path);
        end % createModel
        
        function List = onLineRecom(R, UserProfile, Parameters)
            %ONLINERECOM(USER_PROFILE, PARAMETERS)
            %   Creates the reccomended list from the Model and from the
            %   User Profile. Appends the result in the Result property of
            %   the object.
            %   One optional parameter.
            %   USER_PROFILE is a vector of the same width of the URM
            %   matrix, listing the preferences of a selected user (it can
            %   be a row of the URM matrix).
            %   PARAMETERS is an optional parameter, a struct that contains
            %   all the parameters to be passed to the onLine function.
            if(nargin < 2)
               help Recommendation.onLineRecom
               return;
            end
            
            if(isempty(R.Model) == 1)
                disp('The model hasn''t been created yet. Please create it first!');
                return;
            end % if(isempty(R.Model) == 1)
            
            Parameters.Path = R.Path;
            
            Path = [R.Path filesep 'Algorithms' filesep R.Algorithm];
            addpath(Path);
            
            Result.UserProfile = full(UserProfile);
            List = full(onLineRecom(UserProfile, R.Model, Parameters));
            Result.List = List;
            [~, Result.Ranking] = sort(-Result.List);
            
            R.Result = [R.Result Result];
            
            rmpath(Path);
        end % onLineRecom
        
        function Reshuf = antiReshuffling(R, Index1, Index2, Param)
            %ANTIRESHUFFLING(INDEX1, INDEX2, PARAMETERS) calculates another
            %list from two previous lists, considering the antireshuffling
            %and all the parameters. This list is put in the Result array.
            %   All parameters are optional.
            %   - ANTIRESHUFFLING() calculates the antireshuffling list from
            %   the two last results.
            %   - ANTIRESHUFFLING(X) calculates the antireshuffling list
            %   from the X-th list and the last one (if X is a scalar), or
            %   from the list made with user profile X and the last one (if
            %   X is a vector), or between the two last results with
            %   parameters X (if X is a struct).
            %   - ANTIRESHUFFLING(X, Y) calculates the antireshuffling list
            %   from the X-th list (if X is a scalar) or the list made with
            %   user profile X (if X is a vector) and the Y-th list (if Y
            %   is a scalar) or the list made with user profile Y (if Y is
            %   a vector) or the last result with parameters Y (if Y is a
            %   struct).
            %   - ANTIRESHUFFLING(X, Y, Z) calculates the antireshuffling
            %   list from the X-th list (if X is a scalar) or the list made
            %   with user profile X (if X is a vector) and the Y-th list
            %   (if Y is a scalar) or the list made with user profile Y (if
            %   Y is a vector), with the parameters Z.
            if(isempty(R.Model) == 1)
                disp('The model hasn''t been created yet. Please create if first!');
                return;
            end % if(isempty(R.Model) == 1)
            
            NumResults = length(R.Result);
            
            switch nargin
                case 1 % only have R. I'll take the last two results
                    if(NumResults >= 2)
                        Param.OldList = R.Result(NumResults - 1).List;
                        Param.NewList = R.Result(NumResults).List;
                        Param.Profile = R.Result(NumResults).UserProfile;
                    else
                        disp('There are not enough results to use the Antireshuffling. It needs at least 2 results!');
                        return;
                    end % if(NumResults >= 2)
                case 2 % have R plus Index1 or Param. Index1 could be a scalar or a vector
                    if(isscalar(Index1) == 1) % I'll take the last result for NewList and the one specified by Index1 as OldList
                        if(NumResults >= 2)
                            Param.OldList = R.Result(Index1).List;
                            Param.NewList = R.Result(NumResults).List;
                            Param.Profile = R.Result(NumResults).UserProfile;
                        else
                            disp('There are not enough results to use the Antireshuffling. It needs at least 2 results!');
                            return;
                        end % if(NumResults >= 2)
                    elseif(isvector(Index1) == 1) % I'll take the last result for NewList and a new result made with Index1 as OldList
                        if(NumResults == 0)
                            disp('There are not enough results to use the Antireshuffling. It needs at least 1 result!');
                            return;
                        end
                        
                        SizeArg = length(Index1);
                        SizeUP = length(R.Result(1).UserProfile);
                        if(SizeArg == SizeUP)
                            Param.NewList = R.Result(NumResults).List;
                            Param.Profile = R.Result(NumResults).UserProfile;
                            R.onLineRecom(Index1);
                            Param.OldList = R.Result(NumResults + 1).List;
                        else
                            disp('The user profile provided isn''t of the same size of the URM matrix. Please check it!');
                            return;
                        end % if(SizeArg == SizeUP)
                    elseif(isstruct(Index1) == 1) % Index1 is the Param variable, so i'll take the two last results
                        Param = Index1;
                        Param.OldList = R.Result(NumResults - 1).List;
                        Param.NewList = R.Result(NumResults).List;
                        Param.Profile = R.Result(NumResults).UserProfile;
                    else
                        help Recommendation.antiReshuffling
                        return;
                    end
                case 3 % have R and Index1 plus Index2 or Param. Index1 and Index2 can be scalars or vectors
                    if(isscalar(Index1) == 1)
                        if(NumResults >= 1)
                            Param.OldList = R.Result(Index1).List;
                        else
                            disp('There are not enough results to use the Antireshuffling. It needs at least 1 result!');
                            return;
                        end
                    elseif(isvector(Index1) == 1)
                        SizeArg = length(Index1);
                        SizeUP = length(R.Result(1).UserProfile);
                        if(SizeArg == SizeUP)
                            R.onLineRecom(Index1);
                            Param.OldList = R.Result(NumResults + 1).List;
                        else
                            disp('The user profile provided isn''t of the same size of the URM matrix. Please check it!');
                            return;
                        end
                    else
                        help Recommendation.antiReshuffling
                        return;
                    end % Index1
                    
                    if(isscalar(Index2) == 1)
                        if(NumResults >= 1)
                            Param.NewList = R.Result(Index2).List;
                            Param.Profile = R.Result(Index2).UserProfile;
                        else
                            disp('There are not enough results to use the Antireshuffling. It needs at least 1 result!');
                            return;
                        end
                    elseif(isvector(Index2) == 1)
                        SizeArg = length(Index2);
                        SizeUP = length(R.Result(1).UserProfile);
                        NewNumResults = length(R.Result);
                        if(SizeArg == SizeUP)
                            R.onLineRecom(Index2);
                            Param.NewList = R.Result(NewNumResults + 1).List;
                            Param.Profile = R.Result(NewNumResults + 1).UserProfile;
                        else
                            disp('The user profile provided isn''t of the same size of the URM matrix. Please check it!');
                            return;
                        end
                    elseif(isstruct(Index2) == 1)
                        NewNumResults = length(R.Result);
                        Index2.NewList = R.Result(NewNumResults).List;
                        Index2.Profile = R.Result(NewNumResults).UserProfile;
                        Index2.OldList = Param.OldList;
                        Param = Index2;
                    else
                        help Recommendation.antiReshuffling
                        return;
                    end
                case 4 % have R, Index1 and Index2. Index1 and Index2 can be scalars or vectors
                    if(isscalar(Index1) == 1)
                        if(NumResults >= 1)
                            Param.OldList = R.Result(Index1).List;
                        else
                            disp('There are not enough results to use the Antireshuffling. It needs at least 1 result!');
                            return;
                        end
                    elseif(isvector(Index1) == 1)
                        SizeArg = length(Index1);
                        SizeUP = length(R.Result(1).UserProfile);
                        if(SizeArg == SizeUP)
                            R.onLineRecom(Index1);
                            Param.OldList = R.Result(NumResults + 1).List;
                        else
                            disp('The user profile provided isn''t of the same size of the URM matrix. Please check it!');
                            return;
                        end
                    else
                        help Recommendation.antiReshuffling
                        return;
                    end % Index1
                    
                    if(isscalar(Index2) == 1)
                        if(NumResults >= 1)
                            Param.NewList = R.Result(Index2).List;
                            Param.Profile = R.Result(Index2).UserProfile;
                        else
                            disp('There are not enough results to use the Antireshuffling. It needs at least 1 result!');
                            return;
                        end
                    elseif(isvector(Index2) == 1)
                        SizeArg = length(Index2);
                        SizeUP = length(R.Result(1).UserProfile);
                        NewNumResults = length(R.Result);
                        if(SizeArg == SizeUP)
                            R.onLineRecom(Index2);
                            Param.NewList = R.Result(NewNumResults + 1).List;
                            Param.Profile = R.Result(NewNumResults + 1).UserProfile;
                        else
                            disp('The user profile provided isn''t of the same size of the URM matrix. Please check it!');
                            return;
                        end
                    else
                        help Recommendation.antiReshuffling
                        return;
                    end
            end % switch nargin
            
            Param.Path = R.Path;
            
            Path = [R.Path filesep 'Utility' filesep 'Reshuffling'];
            addpath(Path);
            
            Reshuf = antiReshuffling(Param);
            Result.UserProfile = [Param.OldList; Param.NewList];
            Result.List = Reshuf;
            [~, Result.Ranking] = sort(Reshuf);
            R.Result = [R.Result Result];
            
            rmpath(Path);
        end % antiReshuffling
        
        function export(R, File, Index)
            %EXPORT(FILE) exports all the results in the file specified by
            %FILE.
            %   One optional parameter.
            %   EXPORT(FILE, INDEX) exports only the results specified by
            %   INDEX, where it can be a scalar (1 result) or a vector
            %   (many results).
            if(nargin < 2)
                help Recommendation.export
                return;
            end
            
            if(exist('Index', 'var') == 0)
                Index = length(R.Result);
            end
            
            [FP, Mex] = fopen(File, 'w');
            if(strcmp(Mex, '') == 0)
                disp(Mex);
            else
                for i = Index
                    Res = R.Result(i);
                    [Rows, Cols] = size(Res.UserProfile);
                    
                    if(Rows == 2)
                        fwrite(FP, ['UserProfile1|UserProfile2|List|Ranking' char(10)], 'char');
                    else
                        fwrite(FP, ['UserProfile|List|Ranking' char(10)], 'char');
                    end
                    
                    for k = 1:Rows
                        if(k ~= 1)
                            fwrite(FP, '|', 'char');
                        end
                        for j = 1:Cols
                            if(j ~= 1)
                                fwrite(FP, '#', 'char');
                            end
                            fwrite(FP, num2str(Res.UserProfile(k, j)), 'char');
                        end
                    end
                    
                    for j = 1:Cols
                        if(j ~= 1)
                            fwrite(FP, '#', 'char');
                        else
                            fwrite(FP, '|', 'char');
                        end
                        fwrite(FP, num2str(Res.List(j)), 'char');
                    end
                    
                    for j = 1:Cols
                        if(j ~= 1)
                            fwrite(FP, '#', 'char');
                        else
                            fwrite(FP, '|', 'char');
                        end
                        fwrite(FP, num2str(Res.Ranking(j)), 'char');
                    end
                end % for i = Index
                fclose(FP);
            end % if(strcmp(Mex, '') == 1)
        end % export
        
        function set.URM(R, URM)
            if(isempty(R.Model) == 0)
                disp('The model has already been created. You can''t change the URM matrix after that!');
            else
                if(evalin('base', ['exist(''' URM ''', ''var'')']) == 1)
                    R.URM = URM;
                elseif(exist(URM, 'file') == 2)
                    Name = ['URM' num2str(floor(rand() * 1000))];
                    evalin('base', [Name ' = importdata(''' URM ''');']);
                    R.URM = Name;
                else
                    disp('URM not found');
                end
            end % if(isempty(R.Model) == 0)
        end % set.URM
        
        function set.Algorithm(R, Algorithm)
            if(isempty(R.Model) == 0)
                disp('The model has already been created. You can''t change the Algorithm after that!');
            else
                if(isdir([R.Path filesep 'Algorithms' filesep Algorithm]))
                    R.Algorithm = Algorithm;
                else
                    disp('The selected algorithm doesn''t exist. Please try with another one:');
                    DIR = dir([R.Path filesep 'Algorithms']);
                    for i = 1:length(DIR)
                        if(isempty(strfind(DIR(i).name, '.')))
                            disp(['- ' DIR(i).name]);
                        end
                    end
                end
            end % if(isempty(R.Model) == 0)
        end % set.Algorithm
    end % methods
    
end % classdef Recommendation

