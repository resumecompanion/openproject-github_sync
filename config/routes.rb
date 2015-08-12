OpenProject::Application.routes.draw do
  match 'projects/:project_id/issue_event' => 'GithubIssue#issue_event'
end
