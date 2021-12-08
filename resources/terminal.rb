provides :terminal
default_action :setup

property :user, String, required: true
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
        if ::File.exist?(get_paths('bash'))
            existing_shortcuts = Mixlib::ShellOut.new(get_paths('bash'))
            existing_shortcuts.run_command.stdout
        else 
            "#Aliases\n"
        end
    end

    #provide the paths 
    #should probably raise an error if argument is incorrect 
    def get_paths(name)
        case name
        when 'bash'
            ::File.join('/','Users',new_resource.user,'.bash_profile')
        when 'terminal'
            ::File.join('/','Users',new_resource.user,'Library','Preferences','com.apple.Terminal.plist')
        end
    end
end

action :setup do
    execute 'make bash the default shell' do
        command 'chsh -s /bin/bash'
        user new_resource.user
        input 'password'
    end

    #set bg and fg preferences in terminal plist
    plist 'change terminal default settings' do 
        path get_paths('terminal')
        entry 'Startup Window Settings'
        value 'Silver Aerogel'
        owner new_resource.user
    end
    
    file 'Create a .bash_profile' do
        path "#{get_paths('bash')}"
        owner new_resource.user
        mode '0755'
        content create_contents
        action :create
    end
end

