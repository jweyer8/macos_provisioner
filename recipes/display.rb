dock_plist = 'com.apple.dock.plist'
dock_user = 'jweyer'


dock 'add apps to the dock' do
    user dock_user
    item_paths ['/System/Applications/Utilities/Terminal.app', '/Applications/Visual\ Studio\ Code.app', '/Applications/Google\ Chrome.app']
    action :nothing
end

dock 'clear the dock of all apps (Finder and Trash will be left)' do 
    user dock_user
    action :clear
    notifies :add, 'dock[add apps to the dock]', :immediately
end

execute 'put the Dock on the left side' do
    command "defaults write #{dock_plist} orientation right"
    user dock_user
end

execute 'increase the tile size' do
    command "defaults write #{dock_plist} tilesize 100"
    user dock_user
end

set_background 'set background picture' do
    picture_name 'Hello Bl'
    solid_color false
    user 'jweyer'
    action :nothing
end

set_background 'setup environment to allow for background change' do
    user 'jweyer'
    action :setup
    notifies :set, 'set_background[set background picture]', :immediately
end
  
