plist 'set mouse scroll direction' do 
    path '/Users/jweyer/Library/Preferences/.GlobalPreferences.plist'
    entry 'com.apple.swipescrolldirection'
    value 1
    owner 'jweyer'
end

execute 'clear preexisitng shortcuts' do
    command 'defaults remove .GlobalPreferences NSUserKeyEquivalents'
    user 'jweyer'
    only_if 'defaults read .GlobalPreferences NSUserKeyEquivalents'
end

keyboard_shortcut 'set keyboard shortcuts' do
    shortcut_description 'Move Window to Left Side of Screen'
    shortcut ['command', 'shift', 'left']
    user 'jweyer'
end

keyboard_shortcut 'set keyboard shortcuts' do
    shortcut_description 'Move Window to Right Side of Screen'
    shortcut ['command', 'shift', 'right']
    user 'jweyer'
end

execute 'restart to alow changes to take effect' do
    command 'killall cfprefsd Finder'
    user 'jweyer'
end



