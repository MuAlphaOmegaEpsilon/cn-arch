#!/bin/sh
set -euf

cd "$(dirname $0)"/..

# To compress a PNG image to WEBP
# cwebp example.png -q 85 -m 6 -sharp_yuv -blend_alpha 0xffffff -o example.webp

rm -rf docs/
mkdir docs/
echo "www.cnarchstudio.com" > docs/CNAME
cp -r blog/ docs/
cp -r progetti/ docs/
cp -a icons/. docs/
cp template.html docs/
for CSS_FILE in $(find . -maxdepth 1 -name "*.css"     ); do esbuild --minify "${CSS_FILE}" > docs/"${CSS_FILE}"; done
for JS_FILE  in $(find . -maxdepth 1 -name "*.js"      ); do cp "${JS_FILE}" docs/"${JS_FILE}";  done
#for JS_FILE  in $(find . -maxdepth 1 -name "*.js"      ); do esbuild --minify  "${JS_FILE}" > docs/"${JS_FILE}";  done
for ARTICLE_DIR in $(find blog/ -mindepth 1 -type d); do
	m4  -DFILE="${ARTICLE_DIR}/index.html" \
	    -DDIR_PREFIX="../../" \
	    -DMETA_TITLE="include(${ARTICLE_DIR}/meta-title.txt)" \
	    -DMETA_DESCRIPTION="include(${ARTICLE_DIR}/meta-description.txt)" \
	    -DINCLUDE="include(docs/progetto.css)" \
	    -DH1="$(cat ${ARTICLE_DIR}/meta-title.txt | cut -d \| -f 1)" \
	    -DH2="$(cat ${ARTICLE_DIR}/meta-title.txt | cut -d \| -f 2)" \
	    docs/template.html > docs/${ARTICLE_DIR}/index.html
done
for PRJ_DIR in $(find progetti/ -mindepth 1 -type d); do
	m4  -DFILE="${PRJ_DIR}/index.html" \
	    -DDIR_PREFIX="../../" \
	    -DMETA_TITLE="include(${PRJ_DIR}/meta-title.txt)" \
	    -DMETA_DESCRIPTION="include(${PRJ_DIR}/meta-description.txt)" \
	    -DINCLUDE="include(docs/progetto.css)" \
	    -DH1="$(cat ${PRJ_DIR}/meta-title.txt | cut -d \| -f 1)" \
	    -DH2="$(cat ${PRJ_DIR}/meta-title.txt | cut -d \| -f 2)" \
	    docs/template.html > docs/${PRJ_DIR}/index.html
done
m4 -DDIR_PREFIX="/" index.html > docs/index.html
m4 -DFILE=blog/index.html \
   -DDIR_PREFIX="../" \
   -DMETA_TITLE="Blog | Articoli e riflessioni sull'architettura" \
   -DMETA_DESCRIPTION="Pensieri e considerazioni personali sull'architettura, su come le persone vivono quotidianamente gli spazi e sui clichè moderni." \
   -DINCLUDE="include(docs/blog.css)" \
   -DH1="Blog" \
   -DH2="Articoli e riflessioni sull'architettura" \
   docs/template.html > docs/blog/index.html
m4 -DFILE=progetti/index.html \
   -DDIR_PREFIX="../" \
   -DMETA_TITLE="Portfolio | I progetti più significativi dello studio" \
   -DMETA_DESCRIPTION="Realizzazioni delle opere originali e concorsi di idee, motivati razionalmente e documentati da immagini." \
   -DINCLUDE="include(docs/portfolio.css)" \
   -DH1="Portfolio" \
   -DH2="I progetti più significativi dello studio" \
   docs/template.html > docs/progetti/index.html
m4 -DFILE=claudia-negrini.html \
   -DDIR_PREFIX="/" \
   -DMETA_TITLE="Biografia dell'arch. Claudia Negrini, fondatrice di CNArchStudio" \
   -DMETA_DESCRIPTION="Il percorso professionale dell'Arch. Claudia Negrini inizia a Pisa, con la laurea magistrale in Ingegneria Edile-Architettura." \
   -DH1="Biografia professionale" \
   -DH2="Claudia Negrini" \
   docs/template.html > docs/claudia-negrini.html
find docs/ -name "*.txt" -exec rm {} \; # All txt files were temporary
find docs/ -name "*.svg" -exec rm {} \; # All svg files must be included in html ones
find docs/ -name "*.css" -exec rm {} \; # All css files must be included in html ones
find docs/ -name "*.js"  -exec rm {} \; # All  js files must be included in html ones
rm docs/template.html
cd docs
http-server
