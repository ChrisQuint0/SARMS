from lxml import etree

parser = etree.XMLParser(load_dtd=True, resolve_entities=True)
tree = etree.parse("sarms.xml", parser)
tree.xinclude()  # correct way

# apply the XSL
xslt = etree.parse("sarms.xsl")
transform = etree.XSLT(xslt)
result = transform(tree)

with open("output.html", "wb") as f:
    f.write(bytes(result))

print("Done! Open output.html")