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
