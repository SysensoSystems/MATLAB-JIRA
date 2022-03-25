function JiraTool()
% Helps to launch MATLAB-JIRA Connection GUI. This utility helps to fetch
% project and issue details from the JIRA account with the given credentials.
%
% Syntax:
% >> JiraTool
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%
%% Create UI componentes
screenSize = get(0,'screensize');
JIRAUIFigure = uifigure('Visible', 'on');
JIRAUIFigure.Color = [1 1 1];
JIRAUIFigure.Position = [0.2*screenSize(3) 0.2*screenSize(4) 0.6*screenSize(3) 0.6*screenSize(4)];
JIRAUIFigure.Name = 'MATLAB-JIRA Connection';
mainLayout = uigridlayout(JIRAUIFigure,[3 1]);
mainLayout.RowHeight = {120,'1x',50};

% Create GridLayout for login details
gridLayout = uigridlayout(mainLayout);
gridLayout.ColumnWidth = {100, '1x', 100, 100};
gridLayout.RowHeight = {22,22,22};
gridLayout.RowSpacing = 9.25;
gridLayout.Padding = [10 9.25 10 9.25];

% Create ConnectButton
connectButton = uibutton(gridLayout, 'push');
connectButton.FontSize = 18;
connectButton.FontWeight = 'bold';
connectButton.Layout.Row = [1 3];
connectButton.Layout.Column = 3;
connectButton.Text = 'Connect';

% Create UserNameEditFieldLabel
userNameEditFieldLabel = uilabel(gridLayout);
userNameEditFieldLabel.HorizontalAlignment = 'right';
userNameEditFieldLabel.FontWeight = 'bold';
userNameEditFieldLabel.Layout.Row = 1;
userNameEditFieldLabel.Layout.Column = 1;
userNameEditFieldLabel.Text = 'UserName';

% Create UserNameEditField
userNameEditField = uieditfield(gridLayout, 'text');
userNameEditField.Layout.Row = 1;
userNameEditField.Layout.Column = 2;

% Create PasswordEditFieldLabel
passwordEditFieldLabel = uilabel(gridLayout);
passwordEditFieldLabel.HorizontalAlignment = 'right';
passwordEditFieldLabel.FontWeight = 'bold';
passwordEditFieldLabel.Layout.Row = 2;
passwordEditFieldLabel.Layout.Column = 1;
passwordEditFieldLabel.Text = 'APIKey';

% Create PasswordEditField
passwordEditField = uieditfield(gridLayout, 'text');
passwordEditField.Layout.Row = 2;
passwordEditField.Layout.Column = 2;

% Create JiraURLLabel
JiraURLLabel = uilabel(gridLayout);
JiraURLLabel.HorizontalAlignment = 'right';
JiraURLLabel.FontWeight = 'bold';
JiraURLLabel.Layout.Row = 3;
JiraURLLabel.Layout.Column = 1;
JiraURLLabel.Text = 'JiraURL';

% Create EditField
URLEditField = uidropdown(gridLayout);
URLEditField.Layout.Row = 3;
URLEditField.Layout.Column = 2;
URLEditField.Items = {};
URLEditField.Editable = 'on';

% Create APILInkButton
APILInkButton = uibutton(gridLayout, 'push');
APILInkButton.Layout.Row = 1;
APILInkButton.Layout.Column = 4;
APILInkButton.Text = {'API LInk'; ''};

% Create preference button for remember password
preferenceButton = uibutton(gridLayout, 'push');
preferenceButton.Layout.Row = 2;
preferenceButton.Layout.Column = 4;
preferenceButton.Text = 'Preference';
preferenceButton.UserData = false;

% Create JIRA web link button
JIRAWebButton = uibutton(gridLayout, 'push');
JIRAWebButton.Layout.Row = 3;
JIRAWebButton.Layout.Column = 4;
JIRAWebButton.Text = 'JIRA Web';

% Create layout for tree and table components
tableLayout = uigridlayout(mainLayout,[1 2]);
tableLayout.ColumnWidth = {300,'1x'};

% Create project Tree
projectTree = uitree(tableLayout);
projectTree.Layout.Row = 1;
projectTree.Layout.Column = 1;

% Create Tree Node
projectNode = uitreenode(projectTree);
projectNode.Text = 'Projects';

% Create UITable
UITable = uitable(tableLayout);
UITable.Layout.Row = 1;
UITable.Layout.Column = 2;
UITable.ColumnName = {'Parameter'; 'Value'};
UITable.RowName = {};

% Create buttonLayout
buttonLayout = uigridlayout(mainLayout,[1 4]);
buttonLayout.ColumnWidth = {'1x', 100, 100, '1x'};
buttonLayout.RowHeight = {22};

% Create closeButton
closeButton = uibutton(buttonLayout, 'push');
closeButton.Layout.Row = 1;
closeButton.Layout.Column = 2;
closeButton.Text = 'Close';

% Create helpButton
helpButton = uibutton(buttonLayout, 'push');
helpButton.Layout.Row = 1;
helpButton.Layout.Column = 3;
helpButton.Text = 'Help';

JIRAPath = mfilename('fullpath');
[utilsPath,name,ext] = fileparts(JIRAPath);
authenticationFilePath = [utilsPath '\auth.mat'];

% Get and store the user entry fields in a variable
guiHandles = {userNameEditField,passwordEditField,URLEditField,preferenceButton,UITable,projectNode};

% Set initially password empty
password = '';
userIndex = 1;

%% Setting Callbacks
% Set tree click callback
projectTree.SelectionChangedFcn = {@treeClickCallback,UITable};

% set prefernce button callback
preferenceButton.ButtonPushedFcn = @(preferenceButton,event) preferenceDialog(preferenceButton,guiHandles,authenticationFilePath);

% Set username editfield value changing callback
userNameEditField.ValueChangingFcn = {@userNameCallback};

% Set password editfield value changing callback
passwordEditField.ValueChangingFcn = {@passwordCallback};

% Set URL editfield value changing callback
URLEditField.ValueChangedFcn = {@urlCallback};

% Set connection button callback
connectButton.ButtonPushedFcn = @(ConnectButton,event) connectJiraAccount(ConnectButton,guiHandles,authenticationFilePath);

% Set API link button callback
APILInkButton.ButtonPushedFcn = @(APILInkButton,event) launchAPILink(APILInkButton);

% Set JIRA web link button callback
JIRAWebButton.ButtonPushedFcn = @(JIRAWebButton,event) launchJiraSite(JIRAWebButton);

helpButton.ButtonPushedFcn = @(helpButton,event) helpCallback(helpButton);

closeButton.ButtonPushedFcn = @(closeButton,event) closeCallback(closeButton);

%% Setting Functions
%--------------------------------------------------------------------------
    function userNameCallback(src,event)
        % Value changing function: Username EditField
        
        % Check authentication  .mat file
        if isfile(authenticationFilePath)
            auth = load(authenticationFilePath);
            fieldNames = fieldnames(auth);
            
            % Loop the mat file users data
            for ind = 1:length(fieldNames)
                % Get and store the  mat file user data in variables
                userName =  eval(['auth.' fieldNames{ind} '.userName;']);
                whoami = eval(['auth.' fieldNames{ind} '.whoami;']);
                API = eval(['auth.' fieldNames{ind} '.API;']);
                URL = eval(['auth.' fieldNames{ind} '.URL;']);
                [status,tempUser] = dos('whoami');
                if status == 0
                    tempUser = split(tempUser,'\');
                end
                
                % Compare mat file username,whoami data, user entry username data
                if strcmp(userName,event.Value) && strcmp(whoami,tempUser{2})
                    % Set the data editfield correspondingly
                    guiHandles{1}.Value = userName;
                    guiHandles{3}.Items = URL;
                    guiHandles{3}.Value = URL{1};
                    guiHandles{2}.UserData = API{1};
                    password = API{1};
                    guiHandles{2}.Value = repmat('*',1,length(API{1}));
                    guiHandles{4}.UserData = true;
                    userIndex = ind;
                    break
                else
                    % Set the empty data editfield correspondingly
                    guiHandles{2}.UserData = '';
                    password = '';
                    guiHandles{2}.Value ='';
                    guiHandles{3}.Value = '';
                    guiHandles{4}.UserData = false;
                end
            end
        end
    end
%--------------------------------------------------------------------------
    function urlCallback(src,event)
        
        if isfile(authenticationFilePath)
            auth = load(authenticationFilePath);
            fieldNames = fieldnames(auth);
            URL = eval(['auth.' fieldNames{userIndex} '.URL;']);
            API = eval(['auth.' fieldNames{userIndex} '.API;']);
            for ii = 1:length(URL)
                if strcmp(event.Value,URL{ii})
                    guiHandles{2}.UserData = API{ii};
                    password = API{ii};
                    guiHandles{2}.Value = repmat('*',1,length(API{ii}));
                end
            end
        end
        
    end
%--------------------------------------------------------------------------
    function passwordCallback(src,event)
        
        if isempty(password)
            password = event.Value;
            passwordLength = length(password);
            tempPassword = repmat('*',1,passwordLength);
            src.UserData = password;
            src.Value = tempPassword;
        else
            dummy = event.Value;
            % Find '*'(asterisk) index value
            indexAsterisk = strfind(dummy,'*');
            indexAsterisk = length(indexAsterisk);
            dummy = replace(dummy,'*','');
            password = password([1:indexAsterisk]);
            password = [password dummy];
            %disp(password)
            passwordLength = length(password);
            
            src.UserData = password;
            tempPassword = repmat('*',1,passwordLength);
            src.Value = tempPassword;
        end
    end
%--------------------------------------------------------------------------
    function launchAPILink(~)
        % API link view function: APILinkButton
        
        % Set api generation link
        APILinkUrl = 'https://id.atlassian.com/manage/api-tokens';
        web(APILinkUrl)
    end
%--------------------------------------------------------------------------
    function launchJiraSite(~)
        % JIRA web view function: JIRAWebButton
        
        % Set Jira index page link
        JIRALinkUrl = 'https://jira.atlassian.com';
        web(JIRALinkUrl)
    end
%--------------------------------------------------------------------------
    function helpCallback(~)
        open([utilsPath '\doc\doc_JiraTool.pdf'])
    end
%--------------------------------------------------------------------------
    function closeCallback(~)
        delete(JIRAUIFigure)
    end
end
