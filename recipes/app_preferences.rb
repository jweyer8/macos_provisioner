default_browser = {name: 'Google', id: 'com.google.www'}
app_user = node['trial_cook']['user']

terminal 'Setup terminal preferecnes' do
    user app_user
    aliases Hash['opengc' => 'open -a "Google Chrome"', 'celar' => 'clear']
end

execute 'set chrome as default browser' do
    command "defaults write .GlobalPreferences NSPreferredWebServices \"NSWebSercicesProviderWebSearch = {NSDefaultDisplayName = #{default_browser[:name]}; NSProviderIdentifier = #{default_browser[:id]};};\" "
    user app_user
end
