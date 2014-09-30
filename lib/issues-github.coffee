issuesPath = atom.packages.getLoadedPackage("issues").path
IssuesProvider = require "#{issuesPath}/lib/issues-provider"
marked = require 'marked'

GITHUB_REGEX = /^(https:\/\/|git@)github\.com(\/|:)([-\w]+)\/([-\w]+)(\.git)?$/

module.exports =
class IssuesGithub extends IssuesProvider

  @active: -> GITHUB_REGEX.test @repoUrl()

  @repoUrl: ->
    repo = atom.project.getRepo()
    repo.getOriginUrl() if repo

  issuesUrl: ->
    m = IssuesGithub.repoUrl().match GITHUB_REGEX
    "https://api.github.com/repos/#{m[3]}/#{m[4]}/issues" if m

  formatResponse: (body) ->
    JSON.parse(body)
      .map (issue) ->
        title: "\##{issue.number} #{issue.title}"
        body: marked issue.body
        url: issue.html_url




# module.exports = require './github-issues-provider'
