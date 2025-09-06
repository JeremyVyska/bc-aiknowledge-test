codeunit 50312 "T2 Payment Processing"
{
    // Rent collection and payment management
    
    trigger OnRun()
    begin
        ProcessMonthlyPayments();
        IdentifyDelinquentAccounts();
        CalculateLateFees();
        GetPaymentSummaryOptimized();
    end;
    
    procedure ProcessMonthlyPayments(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalCollected: Decimal;
        PaymentCount: Integer;
    begin
        RentalLedger.SetRange("Payment Status", RentalLedger."Payment Status"::Paid);
        if RentalLedger.FindSet() then
            repeat
                TotalCollected += RentalLedger."Total Amount";
                PaymentCount += 1;
            until RentalLedger.Next() = 0;
        exit(TotalCollected);
    end;

    procedure IdentifyDelinquentAccounts(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        DelinquentCount: Integer;
    begin
        RentalLedger.SetRange("Payment Status", RentalLedger."Payment Status"::Overdue);
        if RentalLedger.FindSet() then
            repeat
                DelinquentCount += 1;
            until RentalLedger.Next() = 0;
        exit(DelinquentCount);
    end;

    procedure CalculateLateFees(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalLateFees: Decimal;
    begin
        if RentalLedger.FindSet() then
            repeat
                TotalLateFees += RentalLedger."Late Fees";
            until RentalLedger.Next() = 0;
        exit(TotalLateFees);
    end;

    procedure GetPaymentSummaryOptimized(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
    begin
        RentalLedger.SetLoadFields("Total Amount");
        RentalLedger.CalcSums("Total Amount");
        exit(RentalLedger."Total Amount");
    end;
}
