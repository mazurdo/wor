namespace :wor do
  desc "Sync disqus comments"
  task :sync_disqus => :environment do |t, args|
    Wor::Post.published.each do |post|
      post.sync_disqus
    end
  end
end