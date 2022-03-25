function preferenceDialog(preferenceButton,guiHandles,authenticationFilePath)
% Launches preference dialog to enable/disable/clear the username details.
%
% guiHandles = {userNameEditField,passwordEditField,URLEditField,preferenceButton,UITable,projectNode}
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%

% Create UI components
screenSize = get(0,'screensize');
preferenceUIFigure = uifigure('Visible', 'on');
preferenceUIFigure.Position = [screenSize(3)/2-200 screenSize(4)/2-60 400 120];
preferenceUIFigure.Name = 'Remember Login';

% Create grid layout
preferenceGridLayout = uigridlayout(preferenceUIFigure);
preferenceGridLayout.ColumnWidth = {'1x', '1x', '1x'};
preferenceGridLayout.RowHeight = {'1x', '1x', '1x'};

% Enable Button
enableButton = uibutton(preferenceGridLayout, 'push');
enableButton.Layout.Row = 2;
enableButton.Layout.Column = 1;
enableButton.Text = 'Enable';

% Disable Button
disableButton = uibutton(preferenceGridLayout, 'push');
disableButton.Layout.Row = 2;
disableButton.Layout.Column = 2;
disableButton.Text = 'Disable';

% Clear Button
clearEntryButton = uibutton(preferenceGridLayout, 'push');
clearEntryButton.Layout.Row = 2;
clearEntryButton.Layout.Column = 3;
clearEntryButton.Text = 'Clear Entries';

% Check preference enable button enabled or not
if preferenceButton.UserData
    enableButton.Enable = 'off';
    disableButton.Enable = 'on';
    clearEntryButton.Enable = 'on';
else
    enableButton.Enable = 'on';
    disableButton.Enable = 'off';
    clearEntryButton.Enable = 'on';
end

% Setting Callbacks
enableButton.ButtonPushedFcn = @(enableButton,event) enableButtonCallback(enableButton,preferenceButton);
disableButton.ButtonPushedFcn = @(disableButton,event) disableButtonCallback(disableButton);
clearEntryButton.ButtonPushedFcn = @(clearEntryButton,event) clearButtonCallback(clearEntryButton);

%--------------------------------------------------------------------------
    function enableButtonCallback(enableButton,preferenceButton)
        % Enables saving login details.
        
        preferenceButton.UserData = true;
        disableButton.Enable = 'on';
        enableButton.Enable = 'off';
        clearEntryButton.Enable = 'on';
    end
%--------------------------------------------------------------------------
    function disableButtonCallback(disableButton)
        % Disables saving login details.
        
        preferenceButton.UserData = false;
        disableButton.Enable = 'off';
        enableButton.Enable = 'on';
        clearEntryButton.Enable = 'on';
    end
%--------------------------------------------------------------------------
    function clearButtonCallback(clearEntryButton)
        % Clears exisiting login details, if any.
        
        disableButton.Enable = 'off';
        enableButton.Enable = 'on';
        clearEntryButton.Enable = 'on';
        % Check authentication  .mat file
        if isfile(authenticationFilePath)
            auth = load(authenticationFilePath);
            fieldNames = fieldnames(auth);
            
            % Loop the mat file users data
            for i = 1:length(fieldNames)
                % Get and store the  mat file user data in variables
                userName = eval(['auth.' fieldNames{i} '.userName;']);
                whoami = eval(['auth.' fieldNames{i} '.whoami;']);
                API = eval(['auth.' fieldNames{i} '.API;']);
                URL = eval(['auth.' fieldNames{i} '.URL;']);
                
                % Compare mat file username, whoami data , user entry username data
                if strcmp(userName,guiHandles{1}.Value)
                    % Set the data editfield correspondingly
                    auth = rmfield(auth,fieldNames{i});
                    fieldNames = fieldnames(auth);
                    if isempty(fieldNames)
                        delete(authenticationFilePath);
                        preferenceButton.UserData = false;
                    else
                        save(authenticationFilePath, '-struct', 'auth');
                    end
                end
            end
        end
    end
end
