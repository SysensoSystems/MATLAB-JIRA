%% *|MATLAB-JIRA Connection|*
%
%%
% "MATLAB-JIRA Connection" is a MATLAB utility to access Jira projects.
%
% Developed by: Sysenso Systems, https://sysenso.com/
%
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%
%
% *Introduction*
%
% Jira is a proprietary software development tool developed by Atlassian that allows issue tracking and software project management.
% It is built for every member of the software team to plan, track, and release great software.
%
% Apart from using Jira development environment, it provides REST API to build apps for Jira,
% develop integrations between Jira and other applications, or script interactions with Jira.
%
% Reference:
% <https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/>
%
% This "MATLAB-JIRA Connection" is an utility to developed in MATLAB to get Jira project and
% issue details using its APIs.
%
%
% *Authentication*
%
% The most important part to establish the MATLAB-JIRA Connection is Authentication.
% The preferred authentication methods for the Jira REST APIs are OAuth and HTTP basic authentication.
% This utility uses HTTP based basic authentication method for Jira connection which basically uses API tokens for enabling the login.
%
% Jra users can generate an API token for their Atlassian account and use it to authenticate anywhere where they would have used a password.
% This enhances security because the users are not saving their primary account password outside of where they authenticate.
% They can quickly revoke individual API tokens on a per-use basis.
%
% Reference:
% <https://developer.atlassian.com/server/jira/platform/basic-authentication/>
%
% *Launching the tool*
%
% Before launching the tool, add the JIRALink folder to the MATLAB path.
%
% Then execute the command "JiraTool" in the MATLAB command window. to launch the tool.
%
% <<images\JiraToolLaunch.png>>
%
% *Creating the API Token*
%
% API token can be generated by following the information provided in the
% below link.
%
% <https://confluence.atlassian.com/cloud/api-tokens-938839638.html>
%
% Alternatively, press the API Link Button in MATLAB-JIRA Connection GUI to
% launch the security settings page for the Jira account. APITokenButton
%
% <<images\APITokenButton.png>>
%
% Then select "Create and manage API tokens" under "API token".
%
% <<images\SettingsPage.png>>
%
% From API Tokens pages, use "Create API Token" button to create new API
% token with a custom label.
%
% <<images\APITokenPage.png>>
%
% Copy the API key that is generated. This can be used to connect to the
% Jira account using APIs.
%
% <<images\NewAPIToken.png>>
%
%
% *Using the credentials*
%
% # Enter the JIRA account username in the UserName editfield
% # Enter the Generated API token in the APIKEY editfield
% # Enter the JIRA Project URL link in the URL editfield
% # Press the Connect Button for making connection with JIRA
%
% *Accessing Projects*
%
% MATLAB-JIRA Connection shows the projects and issues in a tree view.
% Click the projects or issues in tree to show the details in a tabular form.
%
% <<images\JiraConnectData.png>>
%
% *Preference Settings*
%
% To get the user preference to Enable/Disable storing user credentials
% which helps the user avoid remembering the API tokens.
%
% Click the preference button, it will show the three buttons.
%
% # Enable -> it enables the utility to store and retrieve credentials in a
% mat file.
% # Disable -> it disables the utility in recording the user credentials.
% # Clear entries -> it clears the existing credentials recorded.
%
% <<images\PreferenceDialog.png>>
%
% *Note: This tool is a prototype to study MATLAB-JIRA Connection capabilities.
% It has features only to fetch Jira project and issue details. It does not have support to update the Jira projects/issues.
% Please share your comments and contact us if you are interested in updating the features further.*
%