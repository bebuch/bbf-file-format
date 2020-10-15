#!/bin/bash
set -e        # exit script on any error
set -o xtrace # print commands in log

# add pandoc configuration files
cp -r /syntax-highlight ./
cp -r /config ./
cp -r /config/.puppeteer.json ./

# remove TOCs from markdown files
sed -i '1s/\[\[_TOC_\]\]//' *.md

# convert Markdown to PDF
pandoc README.md -o "${CI_PROJECT_NAME}.pdf" \
    --pdf-engine=lualatex --number-sections --toc --fail-if-warnings \
    --template config/template.latex \
    --filter mermaid-filter \
    --lua-filter config/gitlab-math.lua \
    --lua-filter config/remove-multimedia.lua \
    --syntax-definition syntax-highlight/matlab.xml \
    --highlight-style tango
