namespace :reception do

  desc "Update torrents from sources" 
  task :update => :environment do
    @remote = Remote.new
    @remote.update
  end

end