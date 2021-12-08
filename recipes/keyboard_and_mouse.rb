driver_user = node['trial_cook']['user']

plist 'set mouse scroll direction' do 
    path '/Users/jweyer/Library/Preferences/.GlobalPreferences.plist'
    entry 'com.apple.swipescrolldirection'
    value 1
    owner driver_user
end

execute 'clear preexisitng shortcuts' do
    command 'defaults remove .GlobalPreferences NSUserKeyEquivalents'
    user driver_user
    only_if 'defaults read .GlobalPreferences NSUserKeyEquivalents'
end

keyboard_shortcut 'set keyboard shortcuts' do
    shortcut_description 'Move Window to Left Side of Screen'
    shortcut ['command', 'shift', 'left']
    user driver_user
end

keyboard_shortcut 'set keyboard shortcuts' do
    shortcut_description 'Move Window to Right Side of Screen'
    shortcut ['command', 'shift', 'right']
    user driver_user
end

execute 'restart to alow changes to take effect' do
    command 'killall cfprefsd Finder'
    user driver_user
end



