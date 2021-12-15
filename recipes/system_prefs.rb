idle_time = 10

system_preference 'set the time zone' do
  preference :timezone
  setting 'US/Pacific'
end

system_preference "set idle time before sleep to #{idle_time}" do
  preference :sleep
  setting idle_time.to_s
end

system_preference 'restart on power failure' do
  preference :restartpowerfailure
  setting 'On'
end

system_preference 'auto restart when the system freezes' do
  preference :restartfreeze
  setting 'On'
end
