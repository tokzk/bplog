Amazon::Ecs.configure do |options|
  options[:associate_tag] = 'bplog-22'
  options[:AWS_access_key_id] = ENV['AWS_ACCESS_KEY']
  options[:AWS_secret_key] = ENV['AWS_SECRET_KEY']
end
