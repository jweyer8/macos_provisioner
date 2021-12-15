include_recipe 'homebrew'
include_recipe 'homebrew::install_casks'
include_recipe 'homebrew::install_formulas'

homebrew_tap 'chef/chef' do
  action :tap
end
