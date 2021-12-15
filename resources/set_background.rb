provides :set_background
unified_mode true

property :user, String, required: true
property :picture_name, String
property :solid_color, [true, false], default: false

action_class do
  # check the given name picture name aginst the existing built in pictures and set path to the picture with closest name
  def picture
    base_directory = ::File.join('/', 'System', 'Library', 'Desktop\ Pictures')
    path = new_resource.solid_color ? ::File.join(base_directory, 'Solid\ Colors') : base_directory
    existing_pictures = Mixlib::ShellOut.new("ls #{path}")
    existing_pictures.run_command
    existing_pictures = existing_pictures.stdout.split("\n")
    ::File.join(path, closest_match(existing_pictures)).gsub('\\', '')
  end

  # loop through all the built in pictures and return the one that is closest to the input name
  def closest_match(existing_pictures)
    max_match = { score: 0, name: nil }
    existing_pictures.each do |existing_picture|
      score = match_score(existing_picture.split('.').first)
      if score > max_match[:score]
        max_match[:score] = score
        max_match[:name] = existing_picture
      end
    end
    max_match[:name]
  end

  # return a percentage match based on characters in the input picure name and the built in picture being compared
  # This algorithm could definatley be improved... does not work well if a letter in the name is ommited especally if that letter is near the begining of the name
  def match_score(picture)
    matches = new_resource.picture_name.each_char.zip(picture.each_char).select { |input_name, existing_name| input_name == existing_name }.size
    1 - (new_resource.picture_name.size - matches) / new_resource.picture_name.size.to_f
  end
end

action :setup do
  directory "#{::File.join('/', 'Users', new_resource.user, 'Library', 'Application Support', 'com.apple.TCC')}" do
    mode '0700'
  end

  parent_processes = ['com.apple.Terminal', '/bin/bash', '/usr/libexec/sshd-keygen-wrapper']
  sqlite_path = ::File.join('/', 'usr', 'bin', 'sqlite3')
  db_path = ::File.join('/', 'Users', new_resource.user, 'Library', 'Application\ Support', 'com.apple.TCC', 'TCC.db')
  parent_processes.each do |process|
    db_edit = "INSERT OR REPLACE INTO access VALUES('kTCCServiceAppleEvents','#{process}', 1, 2, 3, 1, NULL, NULL, NULL, 'com.apple.finder', NULL, 0, NULL);"
    execute "allow #{process} to modify Finder" do
      command "#{sqlite_path} #{db_path} \"#{db_edit}\""
    end
  end
end
action :set do
  execute 'set the wallpaper with osascript' do
    command <<-EOH
            osascript -e '
                tell application "Finder"
                    set desktop picture to POSIX file "#{picture}"
                end tell#{' '}
            '
        EOH
    user 'jweyer'
  end
end
