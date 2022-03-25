function treeClickCallback(src,event,uiTable)
% For the given node, it generates the property table. If additional
% properties that have to be listed then this function have to be updated
% to include it.
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%

% Get the selected tree node
node = event.SelectedNodes;
% Check node data is empty or not
if (~isempty(node.NodeData))
    % Check node data have style field
    if isfield(node.NodeData,'style')
        % Set project details in cell array
        tableData = {'ProjectID',node.NodeData.id;'Name',node.NodeData.name};
        tableData(3,1)={'ProjectTypeKey'};
        tableData(3,2)={node.NodeData.projectTypeKey};
        tableData(4,1)={'Style'};
        tableData(4,2)={node.NodeData.style};
        
        % Set cell array to UI table data
        uiTable.Data = tableData;
    else
        % Set project issue details in cell array
        tableData = {'IssueType',node.NodeData.issuetype.name;'summary',node.NodeData.summary};
        tableData(3,1)={'Description'};
        tableData(3,2)={node.NodeData.description};
        tableData(4,1)={'Status'};
        tableData(4,2)={node.NodeData.status.name};
        tableData(5,1)={'Creator'};
        tableData(5,2)={node.NodeData.creator.displayName};
        tableData(6,1)={'IssueCreated'};
        dummy = node.NodeData.created;
        tableData(6,2)={datestr(dummy(1:10))};
        tableData(7,1)={'IssueUpdated'};
        dummy = node.NodeData.updated;
        tableData(7,2)={datestr(dummy(1:10))};
        tableData(8,1)={'Priority'};
        tableData(8,2)={node.NodeData.priority.name};
        
        % Set cell array to UI table data
        uiTable.Data = tableData;
    end
end

end
