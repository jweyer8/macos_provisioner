terminal_plist = '/Users/jweyer/Library/Preferences/com.apple.terminal.plist'
global_plist = '/Users/jweyer/Library/Preferences/.GlobalPreferences.plist'

plist 'change terminal default settings' do 
    path terminal_plist
    entry 'Startup Window Settings'
    value 'Pro'
    owner 'jweyer'
end

plist 'set mouse scroll direction' do 
    path global_plist
    entry 'com.apple.swipescrolldirection'
    value  0
    owner 'jweyer'
end
  