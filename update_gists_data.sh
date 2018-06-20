#!/usr/bin/bash

# for reference, v3 API call:
# curl https://api.github.com/users/jamesluberda/gists _data/gists-data.json

# setup and make GraphQL (v4 API) call
# define the user whose gists to pull
USER="user (login: jamesluberda)"

# alernatively, can ref current auth user 
# however, this will make the data structure incompatible
# with the liquid loop in index.html
#USER="viewer"

QUERY=$(cat <<-EOS
{ \
  "query":  "query { \
    $USER { \
      gists (first: 100, orderBy: {field: CREATED_AT, direction: DESC} ) { \
        edges { \
          node { \
            createdAt \
            description \
            name \
            pushedAt \
            stargazers (first: 100) { \
              totalCount \
              edges { \
                node { \
                  id \
                } \
              } \
            } \
            updatedAt \
          } \
        } \
      }\
    } \
  }" \
} 
EOS
)

curl -H "Authorization: bearer $JEKYLL_GITHUB_TOKEN" -X POST -d "$QUERY" https://api.github.com/graphql | tee _data/gists-data.json
