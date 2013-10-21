require 'json'

def whyrun_supported?
  true
end

action :add do
  @ssh_key_generated = execute "generate ssh key for #{new_resource.path}" do
    creates new_resource.path
    command "ssh-keygen -t rsa -q -C '' -f '#{new_resource.path}' -P \"\""
  end

  @file_creation = file new_resource.path do
    owner new_resource.owner
    group new_resource.group
  end

  @file_pub_creation = file new_resource.path + ".pub" do
    owner new_resource.owner
    group new_resource.group
  end

  @dep_stats = chef_gem 'httparty' do 
    version "0.11.0"
    action :install
  end

  url = "https://api.github.com/repos/#{new_resource.gh_repo}/keys"
  request_data = {
    :headers => {
      "User-Agent" => "ZippyKid Deploy Keys",
      "Authorization" => "token #{new_resource.gh_token}"
    },
  }

  @upload_status = ruby_block "store SSH key for #{new_resource.path}" do
    # Upload our new and shiny SSH key with the repository
    block do
      require 'json'
      require 'httparty'

      post_data = request_data.clone
      post_data[:body] = {
        :title => "#{new_resource.label} - #{node.name}",
        :key => ::File.read(new_resource.path + ".pub")
      }.to_json

      response = HTTParty.post(url, post_data)
      unless response.code == 201
        raise "Could not add SSH key to GitHub: #{response.body}"
      end
    end

    # Do not run if the SSH key is already registered with GitHub
    not_if do
      require 'json'
      require 'httparty'

      response = HTTParty.get(url, request_data)
      unless response.code == 200
        throw "Could not retrieve key list: #{response.body}"
      end

      keys = response.parsed_response.map { |x| x['key'] }
      keys.include? ::File.read(new_resource.path + ".pub").strip
    end
  end

  new_resource.updated_by_last_action(
    @ssh_key_generated.updated? ||
    @file_creation.updated? ||
    @file_pub_creation.updated? ||
    @dep_stats.updated? ||
    @upload_status.updated?
  )
end

