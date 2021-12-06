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

execute "reboot system to switch from bootstrap user to #{new_user} " do
    command 'sleep 5 && launchctl reboot system &'
    only_if { %w(vagrant lab).include? shell_out("stat -f '%Su' /dev/console").stdout.strip }
end
