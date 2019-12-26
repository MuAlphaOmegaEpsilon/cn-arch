#!/bin/sh
set -euf

cd "$(dirname "$0")"/..

for HTML_FILE in $(ls docs/ | grep ".html"); do
	rm "docs/${HTML_FILE}"
done

mkdir -p .preprocessed
for CSS_FILE in $(ls | grep ".css"); do
	csso "${CSS_FILE}" --output .preprocessed/"${CSS_FILE}"
done

m4 index.html > .preprocessed/index.html
html-inline --ignore-links --ignore-images -i .preprocessed/index.html -o docs/index.html -b .preprocessed

m4 -DFILE=claudia-negrini.html project-template.html > .preprocessed/claudia-negrini.html
html-inline --ignore-links --ignore-images -i .preprocessed/claudia-negrini.html -o docs/claudia-negrini.html -b .preprocessed

for PROJECT_FILE in $(find . -maxdepth 1 -name "project-*.html" | grep -v project-template.html); do
	m4 -DFILE=${PROJECT_FILE} project-template.html > .preprocessed/${PROJECT_FILE}
	html-inline --ignore-links --ignore-images -i .preprocessed/${PROJECT_FILE} -o docs/$(echo ${PROJECT_FILE} | colrm 1 10) -b .preprocessed
done

