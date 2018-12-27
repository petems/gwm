# Gwm
[![Build Status](https://travis-ci.org/petems/gwm.svg?branch=master)](https://travis-ci.org/petems/gwm)
[![Coverage Status](https://coveralls.io/repos/github/petems/gwm/badge.svg?branch=master)](https://coveralls.io/github/petems/gwm?branch=master)

A command line tool for interacting with your [DigitalOcean](https://www.digitalocean.com/) droplets.

## Installation

    gem install gwm

## Configuration

Run the configuration utility, `gwm authorize`.

    $ gwm authorize
    Enter your Github username: gwm-testing
    Enter your Github password: y9tV476EbL2ZtV4
    Config written to .gwm file!

This will create a .gwm file in your home folder (eg. ~/.gwm).

Gwm will look for a .gwm config file first in the current directory you're running it in, then will look for one in the home directory.

An example of a `.gwm` file:

```yaml
---
authentication:
  access_token: f8sazukxeh729ggxh9gjavvzw5cabdpq95txpzhz6ep6jvtquxztfkf2chyejcsg5
```

## Usage

> WIP

## Help

If you're curious about command flags for a specific command, you can
ask gwm about it.

    $ gwm help authorize

For a complete overview of all of the available commands, run:

    $ gwm help

Depending on your local configuration, you may need to install a CA bundle (OS X only) using [homebrew](http://brew.sh/)

    $ brew install curl-ca-bundle

After installation, source the bundle path in your `.bash_profile`/`.bashrc`:

    export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

## Reporting Bugs

Yes, please!

You can create a new issue [here](https://github.com/petems/gwm/issues/new). To help with the investigation of your issue, you can set the environment variable DEBUG to give verbose Faraday logging.

* DEBUG=1 is full unredacted
* DEBUG=2 redacts private keys from the log.

Example:

```bash
DEBUG=2 bundle exec gwm verify
I, [2018-12-27T00:47:00.868157 #15383]  INFO -- : Started GET request to: https://api.github.com/user
D, [2018-12-27T00:47:00.868331 #15383] DEBUG -- : Request Headers:
----------------
Accept        : application/vnd.github.v3+json
User-Agent    : Octokit Ruby Gem 4.13.0
Content-Type  : application/json
Authorization : token [TOKEN REDACTED]

Request Body:
-------------
{
}
I, [2018-12-27T00:47:01.522247 #15383]  INFO -- : Response from https://api.github.com/user; Status: 200; Time: 654.0ms
D, [2018-12-27T00:47:01.522810 #15383] DEBUG -- : Response Headers:
----------------
server                        : GitHub.com
date                          : Thu, 27 Dec 2018 00:47:01 GMT
content-type                  : application/json; charset=utf-8
transfer-encoding             : chunked
connection                    : close
status                        : 200 OK
x-ratelimit-limit             : 5000
x-ratelimit-remaining         : 4987
x-ratelimit-reset             : 1545872591
cache-control                 : private, max-age=60, s-maxage=60
vary                          : Accept, Authorization, Cookie, X-GitHub-OTP
etag                          : W/"08efcbfe1ddef4832f90eb1793844a9a"
last-modified                 : Thu, 27 Dec 2018 00:01:03 GMT
x-oauth-scopes                : user, repo
x-accepted-oauth-scopes       :
x-github-media-type           : github.v3; format=json
access-control-expose-headers : ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type
access-control-allow-origin   : *
strict-transport-security     : max-age=31536000; includeSubdomains; preload
x-frame-options               : deny
x-content-type-options        : nosniff
x-xss-protection              : 1; mode=block
referrer-policy               : origin-when-cross-origin, strict-origin-when-cross-origin
content-security-policy       : default-src 'none'
x-github-request-id           : CE5E:3FEA:5C6E64C:C968115:5C242105

Response Body:
-------------
{
  "login": "gwm-testing",
  "id": 46171773,
  "node_id": "MDQ6VXNlcjQ2MTcxNzcz",
  "avatar_url": "https://avatars3.githubusercontent.com/u/46171773?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/gwm-testing",
  "html_url": "https://github.com/gwm-testing",
  "followers_url": "https://api.github.com/users/gwm-testing/followers",
  "following_url": "https://api.github.com/users/gwm-testing/following{/other_user}",
  "gists_url": "https://api.github.com/users/gwm-testing/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/gwm-testing/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/gwm-testing/subscriptions",
  "organizations_url": "https://api.github.com/users/gwm-testing/orgs",
  "repos_url": "https://api.github.com/users/gwm-testing/repos",
  "events_url": "https://api.github.com/users/gwm-testing/events{/privacy}",
  "received_events_url": "https://api.github.com/users/gwm-testing/received_events",
  "type": "User",
  "site_admin": false,
  "name": null,
  "company": null,
  "blog": "",
  "location": null,
  "email": null,
  "hireable": null,
  "bio": null,
  "public_repos": 0,
  "public_gists": 0,
  "followers": 0,
  "following": 0,
  "created_at": "2018-12-27T00:01:02Z",
  "updated_at": "2018-12-27T00:01:03Z",
  "private_gists": 0,
  "total_private_repos": 0,
  "owned_private_repos": 0,
  "disk_usage": 0,
  "collaborators": 0,
  "two_factor_authentication": false,
  "plan": {
    "name": "free",
    "space": 976562499,
    "collaborators": 0,
    "private_repos": 0
  }
}
Authentication with Github was successful.
```

## Contributing

See the [contributing guide](CONTRIBUTING.md).
