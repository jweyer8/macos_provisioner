default_browser = {name: 'Google', id: 'com.google.www'}

terminal 'Setup terminal preferecnes' do
    user 'jweyer'
    aliases Hash['opengc' => 'open -a "Google Chrome"', 'celar' => 'clear']
end

execute 'set chrome as default browser' do
    command "defaults write .GlobalPreferences NSPreferredWebServices \"NSWebSercicesProviderWebSearch = {NSDefaultDisplayName = #{default_browser[:name]}; NSProviderIdentifier = #{default_browser[:id]};};\" "
    user 'jweyer'
end
