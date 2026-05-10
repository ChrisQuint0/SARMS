<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>SARMS - Library Management Report</title>
        <style>
          * { box-sizing: border-box; margin: 0; padding: 0; }

          body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            color: #222;
            padding: 32px;
            font-size: 14px;
          }

          /* Header */
          .header {
            background: #1a365d;
            color: white;
            padding: 24px 28px;
            margin-bottom: 24px;
          }
          .header h1 { font-size: 1.4rem; font-weight: bold; }
          .header p  { font-size: 0.88rem; margin-top: 4px; opacity: 0.85; }

          /* Summary Cards */
          .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            margin-bottom: 24px;
          }
          .card {
            background: white;
            border: 1px solid #ddd;
            padding: 16px;
            text-align: center;
          }
          .card .num { font-size: 2rem; font-weight: bold; color: #1a365d; }
          .card .lbl { font-size: 0.75rem; color: #666; margin-top: 4px; text-transform: uppercase; }

          /* Section */
          .section {
            background: white;
            border: 1px solid #ddd;
            padding: 24px;
            margin-bottom: 24px;
          }
          .section h2 {
            font-size: 1rem;
            font-weight: bold;
            color: #1a365d;
            border-bottom: 2px solid #1a365d;
            padding-bottom: 8px;
            margin-bottom: 16px;
          }
          .section h2.danger {
            color: #c53030;
            border-bottom-color: #c53030;
          }

          /* Tables */
          table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
          th {
            background: #1a365d;
            color: white;
            padding: 10px 12px;
            text-align: left;
            font-size: 0.8rem;
            text-transform: uppercase;
          }
          td { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; }
          tr:last-child td { border-bottom: none; }
          tr:hover td { background: #f9f9f9; }
          .row-overdue td { background: #fff5f5; }

          /* Status */
          .status {
            display: inline-block;
            padding: 2px 10px;
            font-size: 0.75rem;
            font-weight: bold;
            border: 1px solid;
          }
          .status-overdue      { color: #9b2c2c; border-color: #9b2c2c; background: #fff5f5; }
          .status-active       { color: #276749; border-color: #276749; background: #f0fff4; }
          .status-returned     { color: #2a4365; border-color: #2a4365; background: #ebf8ff; }
          .status-late         { color: #744210; border-color: #744210; background: #fffff0; }

          /* Overdue Notice */
          .notice {
            border: 1px solid #c53030;
            padding: 18px 20px;
            margin-bottom: 16px;
          }
          .notice h3 { font-size: 0.95rem; color: #c53030; margin-bottom: 12px; }
          .notice table { font-size: 0.85rem; }
          .notice td { padding: 5px 10px; border-bottom: 1px solid #f5d0d0; }
          .notice td:first-child { color: #555; font-weight: bold; width: 140px; }
          .notice .warning {
            margin-top: 12px;
            background: #c53030;
            color: white;
            padding: 8px 12px;
            font-size: 0.82rem;
            font-weight: bold;
          }

          .no-data { color: #999; font-style: italic; padding: 16px 0; }

          .footer {
            text-align: center;
            font-size: 0.78rem;
            color: #999;
            margin-top: 32px;
            border-top: 1px solid #ddd;
            padding-top: 16px;
          }
        </style>
      </head>
      <body>

        <!-- Header -->
        <div class="header">
          <h1>SARMS - Library Management System</h1>
          <p>Pamantasan ng Lungsod ng Pasig | Group 4 | Integrative Programming</p>
        </div>

        <!-- Summary Cards -->
        <div class="cards">
          <div class="card">
            <div class="num"><xsl:value-of select="count(/library/books/book)"/></div>
            <div class="lbl">Total Books</div>
          </div>
          <div class="card">
            <div class="num"><xsl:value-of select="count(/library/borrowingRecords/record)"/></div>
            <div class="lbl">Total Records</div>
          </div>
          <div class="card">
            <div class="num"><xsl:value-of select="count(/library/borrowingRecords/record[status='Active'])"/></div>
            <div class="lbl">Active</div>
          </div>
          <div class="card">
            <div class="num" style="color:#c53030;"><xsl:value-of select="count(/library/borrowingRecords/record[status='Overdue'])"/></div>
            <div class="lbl">Overdue</div>
          </div>
          <div class="card">
            <div class="num"><xsl:value-of select="count(/library/borrowingRecords/record[status='Returned'])"/></div>
            <div class="lbl">Returned</div>
          </div>
          <div class="card">
            <div class="num"><xsl:value-of select="count(/library/borrowingRecords/record[status='Returned Late'])"/></div>
            <div class="lbl">Returned Late</div>
          </div>
        </div>

        <!-- SECTION 1: Book Inventory -->
        <div class="section">
          <h2>Book Inventory</h2>
          <table>
            <tr>
              <th>Book ID</th>
              <th>Title</th>
              <th>Author</th>
              <th>Category</th>
              <th>ISBN</th>
              <th>Copies</th>
            </tr>
            <xsl:apply-templates select="/library/books/book"/>
          </table>
        </div>

        <!-- SECTION 2: Borrowing Records -->
        <div class="section">
          <h2>Borrowing Records</h2>
          <table>
            <tr>
              <th>Record ID</th>
              <th>Book ID</th>
              <th>Borrower Name</th>
              <th>Type</th>
              <th>Course</th>
              <th>Borrow Date</th>
              <th>Due Date</th>
              <th>Return Date</th>
              <th>Status</th>
            </tr>
            <xsl:apply-templates select="/library/borrowingRecords/record"/>
          </table>
        </div>

        <!-- SECTION 3: Overdue Notices -->
        <div class="section">
          <h2 class="danger">Overdue Notices</h2>
          <xsl:choose>
            <xsl:when test="/library/borrowingRecords/record[status='Overdue']">
              <xsl:apply-templates
                select="/library/borrowingRecords/record[status='Overdue']"
                mode="notice"/>
            </xsl:when>
            <xsl:otherwise>
              <p class="no-data">No overdue records found.</p>
            </xsl:otherwise>
          </xsl:choose>
        </div>

        <div class="footer">
          SARMS Library Management System - Group 4 | Generated from library.xml using library.xsl
        </div>

      </body>
    </html>
  </xsl:template>

  <!-- Book row -->
  <xsl:template match="book">
    <tr>
      <td><xsl:value-of select="@bookId"/></td>
      <td><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="author"/></td>
      <td><xsl:value-of select="category"/></td>
      <td><xsl:value-of select="isbn"/></td>
      <td><xsl:value-of select="copies"/></td>
    </tr>
  </xsl:template>

  <!-- Borrowing record row -->
  <xsl:template match="record">
    <xsl:variable name="rowClass">
      <xsl:if test="status = 'Overdue'">row-overdue</xsl:if>
    </xsl:variable>
    <tr class="{$rowClass}">
      <td><xsl:value-of select="@recordId"/></td>
      <td><xsl:value-of select="bookId"/></td>
      <td><xsl:value-of select="borrower/borrowerName"/></td>
      <td><xsl:value-of select="borrower/borrowerType"/></td>
      <td><xsl:value-of select="borrower/course"/></td>
      <td><xsl:value-of select="borrowDate"/></td>
      <td><xsl:value-of select="dueDate"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="returnDate != ''"><xsl:value-of select="returnDate"/></xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:variable name="sc">
          <xsl:choose>
            <xsl:when test="status = 'Overdue'">status status-overdue</xsl:when>
            <xsl:when test="status = 'Active'">status status-active</xsl:when>
            <xsl:when test="status = 'Returned'">status status-returned</xsl:when>
            <xsl:when test="status = 'Returned Late'">status status-late</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <span class="{$sc}"><xsl:value-of select="status"/></span>
      </td>
    </tr>
  </xsl:template>

  <!-- Overdue notice block -->
  <xsl:template match="record" mode="notice">
    <div class="notice">
      <h3>Notice for: <xsl:value-of select="borrower/borrowerName"/></h3>
      <table>
        <tr>
          <td>Record ID</td>
          <td><xsl:value-of select="@recordId"/></td>
        </tr>
        <tr>
          <td>Borrower ID</td>
          <td><xsl:value-of select="borrower/borrowerId"/></td>
        </tr>
        <tr>
          <td>Borrower Type</td>
          <td><xsl:value-of select="borrower/borrowerType"/></td>
        </tr>
        <tr>
          <td>Course / Dept.</td>
          <td><xsl:value-of select="borrower/course"/></td>
        </tr>
        <tr>
          <td>Contact No.</td>
          <td><xsl:value-of select="borrower/contactNo"/></td>
        </tr>
        <tr>
          <td>Book ID</td>
          <td><xsl:value-of select="bookId"/></td>
        </tr>
        <tr>
          <td>Borrow Date</td>
          <td><xsl:value-of select="borrowDate"/></td>
        </tr>
        <tr>
          <td>Due Date</td>
          <td><xsl:value-of select="dueDate"/></td>
        </tr>
        <tr>
          <td>Return Date</td>
          <td>Not yet returned</td>
        </tr>
      </table>
      <div class="warning">This book is OVERDUE. Please return immediately to avoid penalties.</div>
    </div>
  </xsl:template>

</xsl:stylesheet>