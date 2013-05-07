# Description

Generates and uploads SSH Deploy Keys to GitHub for your applications. This is
helpful so if any one server is compromised, that one SSH key can be revoked
and replaced.

# Requirements

- Will install httparty as a chef gem
- Requires Chef 0.11+ and supports Why-Run
- A client_id and client_secret from GitHub which are exchanged into client
  tokens. see later on this page on how to exchange them.

# Resources / Providers

## github_deploy_key

This is actually what does the work.

### Actions
 - :add - Add the key to GitHub.

### Attribute Parameters
 - `path` The target for the secret key. The public key will be at path.pub
 - `owner` The user who owns the files, default: root
 - `group` The group that owns the files, default: root
 - `gh_token` The OAuth2 token, exchanged like below.
 - `gh_repo` The repo to add the key to, ie: `company/repo`

# Exchanging Client ID and Secret for a Token

curl -i -X POST -d '{"scopes": ["repo"], "note": "deployments from chef"}' \
  -u "githubuser:githubpassword"
  https://api.github.com/authorizations?client_id=GHCLIENTID&client_secret=GHCLIENTSECRET

Then look for: "token": "...". This is what you want to use for 'gh_token'.

# Usage

``` ruby
github_deploy_key "my-secret-app" do
  path "/opt/my-secret-app/deploy"

  owner "root"
  group "root"

  gh_token "..."
  gh_repo "mycompany/my-secret-app
end
```
