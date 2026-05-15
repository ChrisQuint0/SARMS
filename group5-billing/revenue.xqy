(: SARMS Group 5: Student Billing System :)
(: XQuery script to calculate total revenue, payments, and balances :)

let $doc := doc("billing.xml")
let $records := $doc/billing/record
let $totalTuition := sum($records/tuitionFee)
let $totalPayments := sum($records/paymentsMade)
let $totalBalance := sum($records/balance)
let $recordCount := count($records)

let $fmtTuition := format-number($totalTuition, "#,##0.00")
let $fmtPayments := format-number($totalPayments, "#,##0.00")
let $fmtBalance := format-number($totalBalance, "#,##0.00")

return
<billingSummary>
    <title>SARMS Billing System - Financial Overview</title>
    <timestamp>{ current-dateTime() }</timestamp>
    <statistics>
        <totalStudents>{ $recordCount }</totalStudents>
        <totalExpectedRevenue currency="PHP">{ $fmtTuition }</totalExpectedRevenue>
        <totalPaymentsCollected currency="PHP">{ $fmtPayments }</totalPaymentsCollected>
        <totalOutstandingBalance currency="PHP">{ $fmtBalance }</totalOutstandingBalance>
    </statistics>
    <status>
        {
            if ($totalBalance = 0) then "All accounts are fully settled."
            else concat("There is a remaining balance of PHP ", $fmtBalance, " to be collected.")
        }
    </status>
</billingSummary>
