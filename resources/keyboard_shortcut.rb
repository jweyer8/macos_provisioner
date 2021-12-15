provides :keyboard_shortcut
unified_mode true
default_action :add

property :shortcut, Array, required: true
property :shortcut_description, String, required: true
property :user, String, required: true

action_class do
  # map key words to there sybol representation so that the can be used later with defaults write
  def get_new_shortcut
    key_map = {
        'left' => '\\\U2190',
        'right' =>  '\\\U2192',
        'down' => '\\\U2193',
        'up' => '\\\U2191',
        'control' => '^',
        'option' => '~',
        'command' => '@',
        'shift' => '$',
    }

    new_resource.shortcut.each_with_index { |key, i| if key_map.include?(key) then new_resource.shortcut[i] = key_map[key] end }
    converted_shortcut = new_resource.shortcut.join('')
    "'#{new_resource.shortcut_description}' = '#{converted_shortcut}'"
  end

  # get prexisting shortcuts
  def get_existing_shortcuts
    existing_shortcuts = Mixlib::ShellOut.new('defaults read .GlobalPreferences NSUserKeyEquivalents', user: new_resource.user)
    existing_shortcuts.run_command
    existing_shortcuts = existing_shortcuts.stdout.gsub(/[{}"]/, '{' => '', '}' => '', '"' => '\'').strip
    existing_shortcuts || ''
  end

  def merged_shortcuts
    "{#{get_existing_shortcuts + get_new_shortcut};}"
  end
end

# write the set of new and prexisting shortcuts to the .GlobalPreferences plist if that shortcut doesn't exist already
action :add do
  execute 'add shortcut to entry' do
    command "defaults write .GlobalPreferences NSUserKeyEquivalents \"#{merged_shortcuts}\""
    user new_resource.user
  end
end
