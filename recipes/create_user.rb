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

reboot 'reboot system to switch users' do 
    delay_mins 2
    reason 'swich users'
    only_if { %w(vagrant lab).include? shell_out("stat -f '%Su' /dev/console").stdout.strip }
    action :reboot_now
    notifies :run, 'ruby_block[stop Chef run before userspace is torn down]', :immediately
end

ruby_block 'stop Chef run before userspace is torn down' do
    block do
      Chef::Application.fatal!('cleanly exiting prior to userspace teardown', 35)
    end
    action :nothing
end


