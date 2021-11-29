new_user = 'jweyer'

macos_user 'create user' do
    username new_user
    fullname 'Jared Weyer'
    autologin true
    admin true
end

sudo "give #{new_user} sudo privilges" do
    users new_user
    nopasswd true
    setenv true
end

execute "login into #{new_user}'s account" do 
    command "su - #{new_user}"
end


