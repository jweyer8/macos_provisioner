new_user = node['trial_cook']['user']

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

reboot 'reboot system to switch users' do 
    delay_mins 2
    reason 'switch users'
    only_if {shell_out("stat -f '%Su' /dev/console").stdout.strip == 'vagrant' }
    action :reboot_now
end


