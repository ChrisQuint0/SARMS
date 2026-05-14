(: SARMS Group 5: Student Billing System :)
(: XQuery script to calculate total revenue, payments, and balances :)

let $doc := doc("billing.xml")
let $records := $doc/billing/record
let $totalTuition := sum($records/tuitionFee)
let $totalPayments := sum($records/paymentsMade)
let $totalBalance := sum($records/balance)
let $recordCount := count($records)

return
<billingSummary>
    <title>SARMS Billing System - Financial Overview</title>
    <timestamp>{ current-dateTime() }</timestamp>
    <statistics>
        <totalStudents>{ $recordCount }</totalStudents>
        <totalExpectedRevenue currency="PHP">{ $totalTuition }</totalExpectedRevenue>
        <totalPaymentsCollected currency="PHP">{ $totalPayments }</totalPaymentsCollected>
        <totalOutstandingBalance currency="PHP">{ $totalBalance }</totalOutstandingBalance>
    </statistics>
    <status>
        {
            if ($totalBalance = 0) then "All accounts are fully settled."
            else concat("There is a remaining balance of PHP ", $totalBalance, " to be collected.")
        }
    </status>
</billingSummary>
