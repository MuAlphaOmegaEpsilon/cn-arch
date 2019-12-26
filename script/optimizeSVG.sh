#!/bin/sh
set -euf

cd "$(dirname "$0")"/..

svgo --multipass -f img/
