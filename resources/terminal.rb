provides :terminal
default_action :setup

property :user, String
property :aliases, Hash

action_class do
    #create file content
    def create_contents
        bash_profile_contents = existing_profile
        new_resource.aliases.each do |key, value|
            alias_pattern = /alias #{key}/
            unless alias_pattern.match(existing_profile)
                alias_addition = "alias #{key}=\'#{value}\'\n"
                bash_profile_contents << alias_addition
            end
        end
        bash_profile_contents
    end

    #get existing aliases from bash 
    def existing_profile
        existing_shortcuts = Mixlib::ShellOut.new("/bin/cat /Users/jweyer/.bash_profile", :user => new_resource.user)
        existing_shortcuts.run_command.stdout
    end
end


action :setup do
    bash_profile_path = ::File.join('/','Users',new_resource.user,'.bash_profile')
    terminal_plist_path = ::File.join('/','Users',new_resource.user,'Library','Preferences','com.apple.Terminal.plist')

    execute 'make bash the default shell' do
        command 'sudo chsh -s /bin/bash'
        user new_resource.user
    end

    #set bg and fg preferences in terminal plist
    plist 'change terminal default settings' do 
        path terminal_plist_path
        entry 'Startup Window Settings'
        value 'Silver Aerogel'
        owner new_resource.user
    end
    
    file 'Create a .bash_profile' do
        path "#{bash_profile_path}"
        owner new_resource.user
        mode '0755'
        content create_contents
        action :create
    end
end

