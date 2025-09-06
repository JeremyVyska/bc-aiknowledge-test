codeunit 50316 "T2 Vendor Management"
{
    // Vendor coordination and service provider management
    
    trigger OnRun()
    begin
        EvaluateVendorPerformance();
        ProcessVendorInvoices();
    end;
    
    procedure EvaluateVendorPerformance(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        RentalUnit: Record "Rental Unit";
        PerformanceScore: Decimal;
        VendorCount: Integer;
        AvgMaintenanceTime: Decimal;
        TotalMaintenanceHours: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                VendorCount += 1;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        TotalMaintenanceHours += RentalLedger."Maintenance Hours";
                    until RentalLedger.Next() = 0;
            until RentalUnit.Next() = 0;
        if VendorCount > 0 then begin
            AvgMaintenanceTime := TotalMaintenanceHours / VendorCount;
            PerformanceScore := 100 - AvgMaintenanceTime; // Lower maintenance time = higher score
        end;
        exit(PerformanceScore);
    end;

    procedure ProcessVendorInvoices(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        InvoiceCount: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                if RentalLedger."Maintenance Fees" > 0 then begin
                    InvoiceCount += 1;
                    Sleep(1);
                end;
            until RentalLedger.Next() = 0;
        exit(InvoiceCount);
    end;
}
