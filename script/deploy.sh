#!/bin/sh
set -euf

cd "$(dirname $0)"/..

find docs/ -name "*.html" -exec rm {} \;

rm -r .preprocessed
mkdir -p .preprocessed
for CSS_FILE in $(ls | grep ".css"); do
	yui-compressor "${CSS_FILE}" --output docs/"${CSS_FILE}"
done

find . -maxdepth 1 -name "*.css" -exec ln -s .{} .preprocessed/ \;
m4 index.html > docs/index.html

m4 -DFILE=claudia-negrini.html project-template.html > docs/claudia-negrini.html

for PROJECT_FILE in $(find . -maxdepth 1 -name "project-*.html" | grep -v project-template.html); do
	m4 -DFILE=${PROJECT_FILE} project-template.html > docs/$(echo ${PROJECT_FILE} | colrm 1 10)
done

