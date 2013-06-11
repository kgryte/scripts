function data2json(filename, data)
%FUNCTION DATA2JSON(FILENAME,DATA)
%
%   Desc: 
%       Convert a data array to JSON.
%
%   Parameters:
%       filename: file name to which to save the data in JSON format.
%       data: an array where data is arranged by column. e.g., for M time
%       series of length N, data is NxM.
%
%   Output:
%       data saved to file in JSON format. JSON will be of the following
%       form:
%
%       - if 2 columns:
%           [
%               {
%                   "x": data(1,1),
%                   "y": data(1,2)
%               },
%               {
%                   "x": data(2,1),
%                   "y": data(2,2)
%               },...
%           ]
%
%       - if >2 columns:
%           [
%               {
%                   "x": data(1,1),
%                   "y": [data(1,2), data(1,3),...,data(1,M)]
%               },
%               {
%                   "x": data(2,1),
%                   "y": [data(2,2), data(2,3),...,data(2,M)]
%               },...
%           ]
%
%
%
%
%
%   Dependencies:
%       (none)
%
%   History:
%       2013/06/11 - KGryte. Created.
%
%   Author:
%       Kristofer Gryte
%       Research Scientist
%       University of Oxford
%
%   Copyright (c) 2013.
%
%
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSERTIONS

if ~isnumeric(data)
    % Throw an exception
    error('ERROR:invalid input argument. Argument should be a numeric array.');
end % end IF



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DATA 2 JSON

% Initialize the string:
json = '[';

% Loop through the array and build the json string:
for i = 1 : size(data,1)
    
    % Get the y-values:
    str = num2str(data(i,2:end));
        
    if size(data,2) == 2
        
        json = [json, '{"x":', num2str(data(i,1)), ',"y":[', str, ']}' ];
        
    else
        % Make the y-value entries comma delimited:
        yVals = regexprep(strtrim(str), '  +', ',');
        
        % Append to our JSON:
        json = [json, '{"x":', num2str(data(i,1)), ',"y":[', yVals, ']}' ];
        
    end % end IF/ELSE
    
end % end FOR i

% Finalize the string:
json = [json, ']'];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WRITE 2 FILE

% Write the JSON to file:
fid = fopen(filename, 'wt');
fwrite(fid, json, 'char');

fclose(fid);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EOF
