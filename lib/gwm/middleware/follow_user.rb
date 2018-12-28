module Gwm
  module Middleware
    # Check if the droplet in the environment is inactive, or "off"
    class FollowUser < Base
      def call(env)

        user_to_follow = env['user_follow']

        github = env['github']

        say "Fetching all repos for #{user_to_follow}"

        users_repos_to_watch = env['github'].list_repositories(user_to_follow)

        say "Repos found: #{users_repos_to_watch.count}"

        if env['forked_repo_ignore']
          say "Ignoring forked repos from follows"

          users_repos_to_watch.reject! { |r| r[:fork] == true }

          say "Repos after forks removed: #{users_repos_to_watch.count}"
        end

        if env['dry_run']
          say "Dry run enabled: only listing repos that would be followed"
        end

        users_repos_to_watch.each do |repo|
          if env['dry_run']
            say "#{user_to_follow}/#{repo.name} would be followed"
          else
            result = github.update_subscription("#{user_to_follow}/#{repo.name}", subscribed: true)

            if result[:subscribed]
              say "Subscribed to #{user_to_follow}/#{repo.name} successfully"
            else
              say 'Failed for some reason! :('
            end

          end
        end

        @app.call(env)
      end
    end
  end
end
