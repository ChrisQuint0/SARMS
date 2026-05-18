from lxml import etree

tree = etree.parse("library.xml")
root = tree.getroot()

# ==================== STAT CARDS ====================
books = root.findall(".//books/book")
total_books = len(books)
total_copies = sum(int(b.find("copies").text) for b in books)

records = root.findall(".//borrowingRecords/record")
active_loans = len([r for r in records if r.find("status").text == "Active"])
overdue = len([r for r in records if r.find("status").text == "Overdue"])

print("=" * 40)
print("   LIBRARY MANAGEMENT OVERVIEW")
print("=" * 40)
print(f"  Total Books   : {total_books}")
print(f"  Total Copies  : {total_copies}")
print(f"  Active Loans  : {active_loans}")
print(f"  Overdue       : {overdue}")
print("=" * 40)