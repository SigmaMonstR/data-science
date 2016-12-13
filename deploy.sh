pandoc about.md -f markdown -t html -o about.html
pandoc syllabus_content.md -f markdown -t html -o syllabus_content.html

jekyll serve -w