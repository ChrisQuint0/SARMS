xquery version "1.0";

declare variable $lib := doc("library.xml");

(: ------------------------------------------------------------ :)
(: QUERY 1 — Most Borrowed Books (REQUIRED)                     :)
(:                                                             :)
(: FLWOR breakdown:                                            :)
(:   FOR   — loop through every book in the library            :)
(:   LET   — count how many records reference that book        :)
(:   WHERE — only include books borrowed at least once         :)
(:   ORDER — sort by borrow count, highest first               :)
(:   RETURN— output the result as XML                          :)
(: ------------------------------------------------------------ :)
<mostBorrowedBooks>
{
  for $book in $lib/books/book
  let $borrowCount :=
      count($lib/borrowingRecords/record[bookId = $book/@bookId])
  where $borrowCount > 0
  order by $borrowCount descending
  return
    <book bookId="{$book/@bookId}">
      <title>{$book/title/text()}</title>
      <author>{$book/author/text()}</author>
      <category>{$book/category/text()}</category>
      <timesBorrowed>{$borrowCount}</timesBorrowed>
    </book>
}
</mostBorrowedBooks>
,

(: ------------------------------------------------------------ :)
(: QUERY 2 — All Overdue Records                                :)
(:                                                             :)
(: Lists every borrowing record with status = Overdue          :)
(: ------------------------------------------------------------ :)
<overdueRecords>
{
  for $rec in $lib/borrowingRecords/record[status = 'Overdue']
  order by $rec/dueDate ascending
  return
    <overdueRecord recordId="{$rec/@recordId}">
      <borrowerName>{$rec/borrower/borrowerName/text()}</borrowerName>
      <borrowerId>{$rec/borrower/borrowerId/text()}</borrowerId>
      <course>{$rec/borrower/course/text()}</course>
      <contactNo>{$rec/borrower/contactNo/text()}</contactNo>
      <bookId>{$rec/bookId/text()}</bookId>
      <borrowDate>{$rec/borrowDate/text()}</borrowDate>
      <dueDate>{$rec/dueDate/text()}</dueDate>
    </overdueRecord>
}
</overdueRecords>
,

(: ------------------------------------------------------------ :)
(: QUERY 3 — Borrowing Status Summary                           :)
(:                                                             :)
(: Groups all records by status and counts each group          :)
(: ------------------------------------------------------------ :)
<statusSummary>
{
  let $statuses := distinct-values($lib/borrowingRecords/record/status)
  for $s in $statuses
  let $count := count($lib/borrowingRecords/record[status = $s])
  order by $count descending
  return
    <statusGroup>
      <status>{$s}</status>
      <totalRecords>{$count}</totalRecords>
    </statusGroup>
}
</statusSummary>
,

(: ------------------------------------------------------------ :)
(: QUERY 4 — Books Per Category with Total Copies               :)
(:                                                             :)
(: Groups books by category, counts books and total copies     :)
(: ------------------------------------------------------------ :)
<categoryReport>
{
  let $categories := distinct-values($lib/books/book/category)
  for $cat in $categories
  let $books := $lib/books/book[category = $cat]
  order by $cat ascending
  return
    <category name="{$cat}">
      <totalBooks>{count($books)}</totalBooks>
      <totalCopies>{sum($books/copies)}</totalCopies>
    </category>
}
</categoryReport>
,

(: ------------------------------------------------------------ :)
(: QUERY 5 — Currently Active Loans                             :)
(:                                                             :)
(: Lists all records where book is currently borrowed          :)
(: ------------------------------------------------------------ :)
<activeLoans>
{
  for $rec in $lib/borrowingRecords/record[status = 'Active']
  order by $rec/dueDate ascending
  return
    <activeLoan recordId="{$rec/@recordId}">
      <borrowerName>{$rec/borrower/borrowerName/text()}</borrowerName>
      <borrowerType>{$rec/borrower/borrowerType/text()}</borrowerType>
      <course>{$rec/borrower/course/text()}</course>
      <bookId>{$rec/bookId/text()}</bookId>
      <borrowDate>{$rec/borrowDate/text()}</borrowDate>
      <dueDate>{$rec/dueDate/text()}</dueDate>
    </activeLoan>
}
</activeLoans>
,

(: ------------------------------------------------------------ :)
(: QUERY 6 — Returned Late Records                              :)
(:                                                             :)
(: Lists all books returned after the due date                 :)
(: ------------------------------------------------------------ :)
<returnedLateRecords>
{
  for $rec in $lib/borrowingRecords/record[status = 'Returned Late']
  order by $rec/returnDate descending
  return
    <lateReturn recordId="{$rec/@recordId}">
      <borrowerName>{$rec/borrower/borrowerName/text()}</borrowerName>
      <bookId>{$rec/bookId/text()}</bookId>
      <dueDate>{$rec/dueDate/text()}</dueDate>
      <returnDate>{$rec/returnDate/text()}</returnDate>
    </lateReturn>
}
</returnedLateRecords>
,

(: ------------------------------------------------------------ :)
(: QUERY 7 — Books Never Borrowed                               :)
(:                                                             :)
(: Finds books that have no borrowing records at all           :)
(: ------------------------------------------------------------ :)
<neverBorrowedBooks>
{
  for $book in $lib/books/book
  let $borrowCount :=
      count($lib/borrowingRecords/record[bookId = $book/@bookId])
  where $borrowCount = 0
  return
    <book bookId="{$book/@bookId}">
      <title>{$book/title/text()}</title>
      <author>{$book/author/text()}</author>
      <category>{$book/category/text()}</category>
      <copies>{$book/copies/text()}</copies>
    </book>
}
</neverBorrowedBooks>