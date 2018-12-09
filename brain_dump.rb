github = Octokit::Client.new(access_token: token)

github.auto_paginate = true

users_repos_to_watch = github.list_repositories('petems')

users_repos_to_watch.each do |repo|
  result = github.update_subscription("petems/#{repo.name}", subscribed: true)

  if result[:subscribed]
    puts "Subscribed to petems/#{repo.name} successfully"
  else
    puts 'Failed for some reason! :('
  end

end
