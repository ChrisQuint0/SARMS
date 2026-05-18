# fix_xsl.py
with open('library.xsl', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(
    '<script>\n/* ── Pagination builder ── */',
    '<script>\n//<![CDATA[\n/* ── Pagination builder ── */'
)

content = content.replace(
    '_renderNotices();\n        </script>',
    '_renderNotices();\n//]]>\n        </script>'
)

with open('library.xsl', 'w', encoding='utf-8') as f:
    f.write(content)

print("Done! CDATA wrapper added.")