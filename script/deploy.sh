#!/bin/sh
set -euf

cd "$(dirname $0)"/..

LAST_MOD=$(date -I)

add_to_sitemap() { printf "  <url><lastmod>${LAST_MOD}</lastmod><loc>https://www.cnarchstudio.com/%s</loc></url>\n" $1 >> docs/sitemap.xml; }

# To compress a PNG image to WEBP
# cwebp example.png -q 85 -m 6 -sharp_yuv -blend_alpha 0xffffff -o example.webp

rm -rf docs/
mkdir docs/
echo "www.cnarchstudio.com" > docs/CNAME
cp claudia-negrini.json     docs/
cp arch-claudia-negrini.jpg docs/
cp logo.svg                 docs/
cp -r blog/                 docs/
cp -r progetti/             docs/
cp -a icons/.               docs/
cp -a robots.txt            docs/
cp template.html            docs/
for CSS_FILE in $(find . -maxdepth 1 -name "*.css"     ); do esbuild --minify "${CSS_FILE}" > docs/"${CSS_FILE}"; done
for JS_FILE  in $(find . -maxdepth 1 -name "*.js"      ); do cp "${JS_FILE}" docs/"${JS_FILE}";  done
#for JS_FILE  in $(find . -maxdepth 1 -name "*.js"      ); do esbuild --minify  "${JS_FILE}" > docs/"${JS_FILE}";  done
echo '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">' > docs/sitemap.xml
add_to_sitemap index.html
m4 -DDIR_PREFIX="/" index.html > docs/index.html
for ARTICLE_DIR in $(find blog/ -mindepth 1 -type d); do
	add_to_sitemap ${ARTICLE_DIR}/index.html
	m4  -DCONTENT="include(${ARTICLE_DIR}/index.html)" \
	    -DDIR_PREFIX="../../" \
	    -DMETA_TITLE="include(${ARTICLE_DIR}/meta-title.txt)" \
	    -DMETA_DESCRIPTION="include(${ARTICLE_DIR}/meta-description.txt)" \
	    -DLD_JSON="include(${ARTICLE_DIR}/ld.json)" \
	    -DLOGO_SVG="docs/blog/logo.svg" \
	    -DINCLUDE="include(docs/progetto.css)" \
	    -DH1="$(cat ${ARTICLE_DIR}/meta-title.txt | cut -d \| -f 1)" \
	    -DH2="$(cat ${ARTICLE_DIR}/meta-title.txt | cut -d \| -f 2)" \
	    docs/template.html > docs/${ARTICLE_DIR}/index.html
done
for PRJ_DIR in $(find progetti/ -mindepth 1 -type d); do
	add_to_sitemap ${PRJ_DIR}/index.html
	m4  -DCONTENT="include(${PRJ_DIR}/index.html)" \
	    -DDIR_PREFIX="../../" \
	    -DMETA_TITLE="include(${PRJ_DIR}/meta-title.txt)" \
	    -DMETA_DESCRIPTION="include(${PRJ_DIR}/meta-description.txt)" \
	    -DLD_JSON="include(${PRJ_DIR}/ld.json)" \
	    -DLOGO_SVG="docs/progetti/logo.svg" \
	    -DINCLUDE="include(docs/progetto.css)" \
	    -DH1="$(cat ${PRJ_DIR}/meta-title.txt | cut -d \| -f 1)" \
	    -DH2="$(cat ${PRJ_DIR}/meta-title.txt | cut -d \| -f 2)" \
	    docs/template.html > docs/${PRJ_DIR}/index.html
done
for PRJ_DIR in piscina-oliveto appartamento-solferino bagno-scotto concorso-scuola-fermi; do
	echo "<article>" >> docs/progetti.html
	echo " <a href=\"${PRJ_DIR}/\">" >> docs/progetti.html
	echo "  <h2>$(sed 's/ | /<br><small>/g' progetti/${PRJ_DIR}/meta-title.txt)</small></h2>" >> docs/progetti.html
	echo "  <p>$(sed 's/ | /<br>/g' progetti/${PRJ_DIR}/meta-description.txt)</p>" >> docs/progetti.html
	echo "  include(progetti/${PRJ_DIR}/copertina.html)" >> docs/progetti.html
	echo " </a>" >> docs/progetti.html
	echo "</article>" >> docs/progetti.html
done
for ARTICLE_DIR in spazi-fluidi-evoluzione-dell-abitare abuso-del-bianco-mancanza-contenuti; do
	echo "<article>" >> docs/blog.html
	echo " <a href=\"${ARTICLE_DIR}/\">" >> docs/blog.html
	echo "  <h2>$(sed 's/ | /<br><small>/g' blog/${ARTICLE_DIR}/meta-title.txt)</small></h2>" >> docs/blog.html
	echo "  <p>$(sed 's/ | /<br>/g' blog/${ARTICLE_DIR}/meta-description.txt)</p>" >> docs/blog.html
	echo "  include(blog/${ARTICLE_DIR}/copertina.html)" >> docs/blog.html
	echo " </a>" >> docs/blog.html
	echo "</article>" >> docs/blog.html
done
echo "<div id="pager">\n</div>" >> docs/progetti.html
echo "<div id="pager">\n</div>" >> docs/blog.html
add_to_sitemap progetti/index.html
m4 -DCONTENT="include(docs/progetti.html)" \
   -DDIR_PREFIX="../" \
   -DMETA_TITLE="Portfolio | I progetti più significativi dello studio" \
   -DMETA_DESCRIPTION="Realizzazioni delle opere originali e concorsi di idee, motivati razionalmente e documentati da immagini." \
   -DLD_JSON="include(docs/progetti/ld.json)" \
   -DLOGO_SVG="docs/logo.svg" \
   -DINCLUDE="include(docs/menu.css)" \
   -DH1="Portfolio" \
   -DH2="" \
   docs/template.html > docs/progetti/index.html
add_to_sitemap blog/index.html
m4 -DCONTENT="include(docs/blog.html)" \
   -DDIR_PREFIX="../" \
   -DMETA_TITLE="Blog | Articoli e riflessioni sull'architettura" \
   -DMETA_DESCRIPTION="Pensieri e considerazioni personali sull'architettura, su come le persone vivono quotidianamente gli spazi e sui clichè moderni." \
   -DLD_JSON="include(docs/blog/ld.json)" \
   -DLOGO_SVG="docs/logo.svg" \
   -DINCLUDE="include(docs/menu.css)" \
   -DH1="Blog" \
   -DH2="" \
   docs/template.html > docs/blog/index.html
add_to_sitemap claudia-negrini.html
m4 -DCONTENT="include(claudia-negrini.html)" \
   -DDIR_PREFIX="/" \
   -DMETA_TITLE="Biografia dell'arch. Claudia Negrini, fondatrice di CNArchStudio" \
   -DMETA_DESCRIPTION="Il percorso professionale dell'Arch. Claudia Negrini inizia a Pisa, con la laurea magistrale in Ingegneria Edile-Architettura." \
   -DLD_JSON="include(docs/claudia-negrini.json)" \
   -DLOGO_SVG="docs/logo.svg" \
   -DINCLUDE="include(docs/progetto.css)" \
   -DH1="Biografia professionale" \
   -DH2="Claudia Negrini" \
   docs/template.html > docs/claudia-negrini.html
echo "</urlset>" >> docs/sitemap.xml
find docs/ -name "copertina.html" -exec rm {} \; # All copertina.html files were temporary
find docs/ -name "*.txt" ! -name "robots.txt" -exec rm {} \; # All txt files, except robots.txt, were temporary
find docs/ -name "*.json" -exec rm {} \; # All json files must be included in html ones
find docs/ -name "*.svg"  -exec rm {} \; # All svg files must be included in html ones
find docs/ -name "*.css"  -exec rm {} \; # All css files must be included in html ones
find docs/ -name "*.js"   -exec rm {} \; # All  js files must be included in html ones
rm docs/progetti.html # Remove intermediate file for docs/progetti/index.html generation
rm docs/blog.html     # Remove intermediate file for docs/progetti/index.html generation
rm docs/template.html
cd docs
http-server -c -1
