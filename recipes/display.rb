dock_plist = 'Users/vagrant/Library/Preferences/com.apple.dock.plist'
dock_user = 'jweyer'

dock 'add apps to the dock that are commonly used' do
    admin_user dock_user
    item_paths ['/System/Applications/Utilities/Terminal.app', '/Applications/Visual\ Studio\ Code.app', '/Applications/Google\ Chrome.app']
end

execute 'put the Dock on the left side' do
    command 'defaults write com.apple.dock.plist orientation right'
    user dock_user
end

execute 'increase the tile size' do
    command 'defaults write com.apple.dock.plist tilesize 100'
    user dock_user
end

# execute 'change the background picture' do 
#     command 'osascript -e 'tell application "System Events" set picture to "/Library/Desktop" '
# end

  
