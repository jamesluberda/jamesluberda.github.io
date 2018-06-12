#!/usr/bin/bash

# alternative to specifying user, could just use viewer {
# however, this will make the data structure incompatible
# with the liquid loop in index.html
QUERY=$(cat <<-EOS
{ \
  "query":  "query { \
    viewer { \
      gists (first: 100) { \
        edges { \
          node { \
            name \
            description \
          } \
        } \
      }\
    } \
  }" \
} 
EOS
)

QUERY=$(cat <<-EOS
{ \
  "query":  "query { \
    user (login: jamesluberda) { \
      gists (first: 100) { \
        edges { \
          node { \
            name \
            description \
          } \
        } \
      }\
    } \
  }" \
} 
EOS
)

curl -H "Authorization: bearer $JEKYLL_GITHUB_TOKEN" -X POST -d "$QUERY" https://api.github.com/graphql | tee _data/gists-data.json

# v3 API call
#curl https://api.github.com/users/jamesluberda/gists _data/gists.json
