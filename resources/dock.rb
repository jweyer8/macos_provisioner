provides :dock

property :user, String, required: true
property :item_paths, [Array, String]

action :clear do
  execute 'remove all current apps from the doc' do 
      command "/usr/local/bin/dockutil -v --remove all --allhomes "
      user new_resource.user
  end
end

action :add do
  new_resource.item_paths.each_with_index do |item, i|
    execute "add item #{item} for all users" do
      command "/usr/local/bin/dockutil -v --add #{item} --allhomes #{unless i == new_resource.item_paths.length - 1 then '--no-restart' end}"
      user new_resource.user
    end
    sleep 1
  end
end

