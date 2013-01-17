set :output, "log/cron.log"

every 1.day do
  runner "User.find(:all).each { |user| user.send_reminder }"
end
