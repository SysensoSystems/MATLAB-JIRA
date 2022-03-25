function connectJiraAccount(~,guiHandles,authenticationFilePath)
% Callback for the Connect button. Helps to connect to the JIRA site with
% the given credential.
%
% guiHandles = {userNameEditField,passwordEditField,URLEditField,preferenceButton,UITable,projectNode}
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%

% Validate the user inputs
if (isempty(guiHandles{1}.Value) || isempty(guiHandles{2}.UserData) || isempty(guiHandles{3}.Value))
    % If user inputs is empty display the dialogBox
    warndlg('Please fill the complete login details.','Warning','modal');
else
    % Delete the all children from the guiHandles{6} avoiding redundant data
    guiHandles{6}.Children.delete;
    guiHandles{5}.Data = [];
    
    % Set the projectData URL from user URL different format inputs
    if strfind(guiHandles{3}.Value,"https")
        projectDataURL = [guiHandles{3}.Value '/rest/api/2/project'];
    elseif strfind(guiHandles{3}.Value,"atlassian.net")
        projectDataURL = ['https://' guiHandles{3}.Value '/rest/api/2/project'];
    else
        projectDataURL = ['https://' guiHandles{3}.Value '.atlassian.net/rest/api/2/project'];
    end
    
    dialogBox = msgbox('Loading..... Please wait','Status','modal');
    % Get projectData calling the function getRestAPIData
    projectData = getRestAPIData(projectDataURL,guiHandles,authenticationFilePath);
    tempPreferenceUserdata = guiHandles{4}.UserData;
    guiHandles{4}.UserData = false;
    if isempty(projectData)
        if isvalid(dialogBox)
            delete(dialogBox);
        end
    else
        % Set the User issue data URL from user inputs
        if strfind(guiHandles{3}.Value,"https")
            projectIssueURL = [guiHandles{3}.Value '/rest/api/2/search?jql=assignee=currentuser()'];
        elseif strfind(guiHandles{3}.Value,"atlassian.net")
            projectIssueURL = ['https://' guiHandles{3}.Value '/rest/api/2/search?jql=assignee=currentuser()'];
        else
            projectIssueURL = ['https://' guiHandles{3}.Value '.atlassian.net/rest/api/2/search?jql=assignee=currentuser()'];
        end
        
        % Get User issue data calling the function getRestAPIData
        projectIssuesFullData = getRestAPIData(projectIssueURL,guiHandles,authenticationFilePath);
        if isvalid(dialogBox)
            delete(dialogBox);
        end
        guiHandles{4}.UserData = tempPreferenceUserdata;
        projectIssuesData = {projectIssuesFullData.issues.fields}';
        issueKeys = {projectIssuesFullData.issues.key}';
        
        % Set project data in UItreeNode
        for projectDataCount = 1:length(projectData)
            nodeData = projectData{projectDataCount}.name;
            nodeData = nodeData(~isspace(nodeData));
            % Create node according to project name
            eval([nodeData '= uitreenode(guiHandles{6});']);
            charData = char(nodeData);
            eval([nodeData '.Text = ' 'charData;']);
            eval([nodeData '.NodeData = ' 'projectData{projectDataCount};']);
        end
        
        % Set project issue data in UItreeNode
        for projectIssueCount = 1:length(projectIssuesData)
            nodeData = projectIssuesData{projectIssueCount}.project.name;
            issueKey = issueKeys{projectIssueCount};
            nodeData = nodeData(~isspace(nodeData));
            dummyMatch = ["-"];
            issueKey = erase(issueKey,dummyMatch);
            issueCount = eval(['length(' nodeData '.Children)']);
            % Create issue node according to issue count
            eval([issueKey ' = uitreenode(' nodeData ');']);
            issueCount = issueCount+1;
            issueCount = num2str(issueCount);
            issue = ['issue' issueCount];
            eval([issueKey '.Text = issue;']);
            eval([issueKey '.NodeData = projectIssuesData{projectIssueCount};']);            
        end
        expand(guiHandles{6});
    end
end

end
