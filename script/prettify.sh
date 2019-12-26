#!/bin/sh
set -euf

cd "$(dirname "$0")"/..

prettier --write ./*.html
# prettier --write ./*.js
prettier --write ./*.css
prettier --write .github/workflows/*.yml

