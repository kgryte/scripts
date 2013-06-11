classdef dirMapper
%CLASS DIRMAPPER
%
%   Desc:
%       Map a set of conditions to a unique key and perform the inverse
%       function.
%
%
%
%   Instantiation:
%
%       dirMapper(model): 
%           input parameter is the model to use for mapping; this should be
%           a cellular array.
%
%
%
%   Methods:
%
%       getKey(map): 
%           input parameter is the map to be converted into its
%           corresponding key; this should be a string. Output is the
%           corresponding key. 'map' should be a space delimited string.
%
%       getMap(key): 
%           input parameter is the key to be converted into its
%           corresponding map; this should be a string. Output is the
%           corresponding map.
%
%       test(map, key): 
%           test whether the map and key are equivalent. Output
%           is logical: True/False.
%               
%
%
%   Usage:
%
%       map = 'WT RPo WT C37 Antibody None ms20 zero';
%
%       mapper = dirMapper(model);
%       key = mapper.getKey(map)
%       map_ = mapper.getMap(key)
%       test = mapper.test(map, key)
%
%
%
%   Dependencies:
%       (none)
%
%
%   History:
%       2013/06/11 - KGryte. Created.
%
%
%   Author:
%       Kristofer Gryte
%       Research Scientist
%       University of Oxford
%       k.gryte1(at)physics.ox.ac.uk
%
%   Copyright (c) 2013.
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROPERTIES

% Public Properties:
properties(GetAccess = 'public', SetAccess = 'public')
    
    model; % Used similar to a hash table for lookup.
    
end % end PROPERTIES



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% METHODS

% Public Methods:
methods(Access = 'public')
    
    %% Constructor:
    function obj = dirMapper(model)
        % Class constructor.
        %
        %   Automatically called upon instantiation.
        %
        %   Parameters:
        %       model: the model which allows a map to be converted to a
        %       unique key. This should be a cellular array.
        %
        %
        
        if nargin > 0   
            if ~iscell(model)
                % Throw an exception:
                error('ERROR:inputmodel - model should be a cellular array.');
            end % end IF
            obj.model = model;            
        else
            % Throw an exception:
            error('ERROR:inputmodel - input model needed to instantiate the class.');           
        end % end IF
        
    end % end FUNCTION dirMapper( )
    
    
    
    %% METHOD: getKey
    function key = getKey(obj, map)
        %FUNCTION GETKEY(MAP)
        %
        %   Desc:
        %       Convert a map to its corresponding key.
        %
        %   Parameters:
        %       map: the map to be converted into its corresponding key.
        %       This parameter should be a space delimited string.
        %
        %   Output:
        %       Output is the corresponding key. 
        % 
        %
        
        % Check:
        if ~ischar(map)
            % Throw an exception:
            error('ERROR:invalid input argument. Argument should be a character array.');
        end % end IF
        
        % Parse the input map:
        units = regexp(map, ' ', 'split'); % split based on whitespace

        % For each conditions, get the mapping:
        key = '';
        for i = 1 : numel(units)
            
            % Find the unit in our model:
            logical_array = strcmpi(units{i}, obj.model{i});
            
            % Check that we found the unit:
            if sum(logical_array) < 1
                disp(sprintf('WARNING: unable to find %s in the given model. Defaulting to _ .', units{i}));
                val = '_';
            else
                val = find(logical_array == 1, 1, 'first') - 1; % 0 index
                val = int2str(val);
            end % end IF/ELSE
            
            % Append to our key:
            key = cat(2, key, val);

        end % end FOR i
        
        
    end % end FUNCTION getKey( )
    
    
    %% METHOD: getMap
    function map = getMap(obj, key)
        %FUNCTION GETMAP(KEY)
        %
        %   Desc:
        %       Convert a key to its corresponding map.
        %
        %   Parameters:
        %       key: the key to be converted into its corresponding map.
        %       This parameter should be a string.
        %
        %   Output:
        %       Output is the corresponding map. 
        % 
        %
        
        % Check:
        if ~ischar(key)
            % Throw an exception:
            error('ERROR:invalid input argument. Argument should be a character array.');
        end % end IF
        
        % Look up each key element in the model:
        map = '';
        for i = 1 : length(key)
                      
            if i == 1
                map = obj.model{i}{str2double(key(i))+1}; % 0 index
            else
                map = [map, ' ', obj.model{i}{str2double(key(i))+1} ]; % 0 index
            end % end IF/ELSE
            
        end % end FOR i
        
        
        
    end % end FUNCTION getMap( )
    
    
    
    
    %% METHOD: test
    function result = test(obj, map, key)
        %FUNCTION TEST(MAP,KEY)
        %
        %   Desc:
        %       Test the equivalence of a map and a key.
        %
        %   Parameters:
        %       map: the map to be tested.
        %       key: the mkey to be tested.
        % 
        %   Output:
        %       Output is a logical: True/False. True: map and key are
        %       equivalent. False: map and key are not equivalent.
        %
        %
        
        % Check:
        if ~ischar(map)
            % Throw an exception:
            error('ERROR:invalid input argument. Argument should be a character array.');
        end % end IF
        % Check:
        if ~ischar(key)
            % Throw an exception:
            error('ERROR:invalid input argument. Argument should be a character array.');
        end % end IF
        
        % Get the key:
        key_ = obj.getKey(map);
        
        % Test:
        result = strcmpi(key_, key);
        
    end % end TEST
    
    
end % end METHODS





    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EOC
end 




