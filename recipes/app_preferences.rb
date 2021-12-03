terminal_plist = '/Users/jweyer/Library/Preferences/com.apple.terminal.plist'
default_browser = {name: 'Google', id: 'com.google.www'}

plist 'change terminal default settings' do 
    path terminal_plist
    entry 'Startup Window Settings'
    value 'Pro'
    owner 'jweyer'
end

execute 'set chrome as default browser' do
    command "defaults write .GlobalPreferences NSPreferredWebServices \"NSWebSercicesProviderWebSearch = {NSDefaultDisplayName = #{default_browser[:name]}; NSProviderIdentifier = #{default_browser[:id]};};\" "
    user 'jweyer'
end
