
actions :add

def initialize(*args)
  super
  @action = :add
end

attribute :label, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String, :required => true

attribute :gh_token, :kind_of => String, :required => true
attribute :gh_repo, :kind_of => String, :required => true

attribute :owner , :kind_of => String, :default => "root"
attribute :group, :kind_of => String, :default => "root"

