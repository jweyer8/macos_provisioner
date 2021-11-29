provides :dock
default_action :add

property :admin_user, String, required: true
property :item_paths, [Array, String]

action_class do
  def perform_dockutil_operation(action_param)
    items = new_resource.item_paths

    execute 'remove all current apps from the doc' do 
        command "/usr/local/bin/dockutil -v --remove all --allhomes "
        user new_resource.admin_user
    end

    items.each do |item|
      execute "#{action_param.capitalize} item #{item} for all users" do
        command "/usr/local/bin/dockutil -v --#{action_param} #{item} --allhomes"
        user new_resource.admin_user
      end
    end
  end
end

action :add do
  perform_dockutil_operation('add')
  # only_if ::File.exists?('Library/Preferences/com.apple.dock.plist')
end

