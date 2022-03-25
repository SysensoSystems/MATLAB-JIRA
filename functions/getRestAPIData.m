function responseData = getRestAPIData(URL,guiHandles,authenticationFilePath)
% Get the data from JIRA using its RESTful APIs.
%
% guiHandles = {userNameEditField,passwordEditField,URLEditField,preferenceButton,UITable,projectNode}
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%

%% Getting data from jira using rest API's
% Using python command to interact  the JIRA  with JIRA rest API's
% Set authentication details from user entry
responseData = '';
try
    % Option 1: Using cURL command
    jiraUserName = guiHandles{1}.Value;
    jiraAPIKey = guiHandles{2}.UserData;
    curlCommand = ['curl -XGET -sb -H "Content-type: application/json" ' URL ' --user ' jiraUserName ':' jiraAPIKey];
    [status, cmdout] = system(curlCommand);
    if isequal(status,0)
        responseData = jsondecode(cmdout);
    end
    %     % Option 2: Using Python HTTP request
    %     authentication = py.requests.auth.HTTPBasicAuth(jiraUserName,jiraAPIKey);
    %     headers = py.dict(pyargs('Accept','application/json'));
    %     response = py.requests.request('GET',URL,pyargs('headers',headers,'auth',authentication));
    %     if isequal(response.ok,1)
    %         responseData = jsondecode(char(response.text));
    %     end
catch
end
if isempty(responseData)
    errordlg('Error in fetching the data. Username or password or URL is wrong.','JIRA Error','modal');
    return;
end
%% If respone is successfully received, then convert response data into struct
% Get system user name for authentication
[status,tempUser] = dos("whoami");
if status == 0
    tempUser = split(tempUser,"\");
end
% Check preference is enable or not
if guiHandles{4}.UserData
    % Check authentication .mat file
    if isfile(authenticationFilePath)
        auth = load(authenticationFilePath);
        fieldNames = fieldnames(auth);
        % Set the values in variables from auth.mat file
        for ind = 1:length(fieldNames)
            userName = eval(['auth.' fieldNames{ind} '.userName;']);
            whoami = eval(['auth.' fieldNames{ind} '.whoami;']);
            API = eval(['auth.' fieldNames{ind} '.API;']);
            URL = eval(['auth.' fieldNames{ind} '.URL;']);
            index = num2str(ind);
            tempArray =[];
            % Check existing user or not
            if strcmp(userName,guiHandles{1}.Value)
                for ind = 1:length(URL)
                    tempArray(ind) = strcmp(URL{ind},guiHandles{3}.Value);
                end
                newURL = strfind(tempArray,1);
                if isempty(newURL)
                    eval(['auth.user' index '.API{end+1} = guiHandles{2}.UserData;'])
                    eval(['auth.user' index '.URL{end+1} = guiHandles{3}.Value;'])
                    save(authenticationFilePath, '-struct', 'auth');
                else
                    eval(['auth.user' index '.API{newURL} = guiHandles{2}.UserData;'])
                    eval(['auth.user' index '.URL{newURL} = guiHandles{3}.Value;'])
                    save(authenticationFilePath, '-struct', 'auth');
                end
            else
                % Update new user authentication data
                userCount = length(fieldNames);
                userCount = userCount + 1;
                userCount = num2str(userCount);
                eval(['auth.user' userCount '.whoami = tempUser{2};'])
                eval(['auth.user' userCount '.userName = guiHandles{1}.Value;'])
                eval(['auth.user' userCount '.API = {guiHandles{2}.UserData};'])
                eval(['auth.user' userCount '.URL = {guiHandles{3}.Value};'])
                save(authenticationFilePath, '-struct', 'auth');
            end
        end
    else
        % Save new user authentication data
        auth.user1.whoami = tempUser{2};
        auth.user1.userName = guiHandles{1}.Value;
        auth.user1.API = {guiHandles{2}.UserData};
        auth.user1.URL = {guiHandles{3}.Value};
        save(authenticationFilePath, '-struct', 'auth');
    end
else
    % Do nothing
end

end