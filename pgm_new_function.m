function pgm_new_function(varargin)
% BBZ_NEW_FUNCTION Opens a new function in the editor with template header
%  
% DESCRIPTION 
% 
%  
% SYNTAX 
% PGM_NEW_FUNCTION; 
%  
% EXAMPLES 
%  
%  
% REFERENCES 
%  
% ......................................................................... 
% Bram Zandbelt, bramzandbelt@gmail.com 
% $Created : Tue 09 Jul 2013 09:17:22 CDT by bram 
% $Modified: Tue 09 Jul 2013 09:32:52 CDT by bram

if nargin == 0
   funName = 'untitled_function';
elseif nargin == 1
    funName = varargin{1};
end

% 1.1. Identify user
% =========================================================================
if ismac | isunix
    user = getenv('USER');
elseif ispc
    user = getenv('name');
end
   
% 1.2. Define a time string containing date, time, and timezone
% =========================================================================
[~,timeStr] = unix(['python ',which('now.py')]);

% 1.3. Define header text
% =========================================================================
text = sprintf(['function %s\n',...
                '%% %s <Synopsis of what this function does> \n', ...
                '%%  \n', ...
                '%% DESCRIPTION \n', ...
                '%% <Describe more extensively what this function does> \n', ...
                '%%  \n', ...
                '%% SYNTAX \n', ...
                '%% %s; \n', ...
                '%%  \n', ...
                '%% EXAMPLES \n', ...
                '%%  \n', ...
                '%%  \n', ...
                '%% REFERENCES \n', ...
                '%%  \n', ...
                '%% %s \n', ...
                '%% Bram Zandbelt, bramzandbelt@gmail.com \n', ...
                '%% $Created : %s by %s \n', ...
                '%% $Modified: %s by %s \n', ...
                '\n \n', ...
                '%% CONTENTS \n', ...
                '%% 1. FIRST LEVEL HEADER \n', ...
                '%%    1.1 Second level header \n', ...
                '%%        1.1.1 Third level header \n', ...
                '\n \n', ...
                '%% %s \n', ...
                '%% 1. FIRST LEVEL HEADER \n', ...
                '%% %s \n', ...
                '\n \n', ...
                '%% 1.1. Second level header\n', ...
                '%% %s \n', ...
                '\n \n', ...
                '%% 1.1.1. Third level header\n', ...
                '%% %s \n'], ...
                funName,upper(funName),upper(funName),repmat('.',1,73), ...
                deblank(timeStr),user,deblank(timeStr),user,...
                repmat('%',1,73),repmat('%',1,73),repmat('=',1,73),...
                repmat('-',1,73));

% 1.4. Open new document in MATLAB editor
% =========================================================================
newDoc = matlab.desktop.editor.newDocument(text);