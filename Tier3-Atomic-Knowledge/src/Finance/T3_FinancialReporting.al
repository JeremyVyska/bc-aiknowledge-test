codeunit 504005 "T3 Financial Reporting"
{
    // Financial analysis and tax reporting functionality

    procedure GenerateFinancialSummary(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalRevenue: Decimal;
        TotalExpenses: Decimal;
        NetIncome: Decimal;
        RecordCount: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                TotalRevenue += RentalLedger."Base Rent Amount";
                TotalExpenses += RentalLedger."Maintenance Fees";
                TotalExpenses += RentalLedger."Utility Charges" * 0.3; // Property pays 30% of utilities
                RecordCount += 1;
                // Simulate financial processing
                Sleep(1);
            until RentalLedger.Next() = 0;
            
        NetIncome := TotalRevenue - TotalExpenses;
        exit(NetIncome);
    end;

    procedure CalculateYearlyRevenueTrend(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        YearlyRevenue: Decimal;
        PreviousYearRevenue: Decimal;
        CurrentYear: Integer;
        PreviousYear: Integer;
    begin
        CurrentYear := Date2DMY(Today, 3);
        PreviousYear := CurrentYear - 1;
        
        if RentalUnit.FindSet() then
            repeat
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                RentalLedger.SetRange("Invoice Month", DMY2Date(1, 1, CurrentYear), DMY2Date(31, 12, CurrentYear));
                if RentalLedger.FindSet() then
                    repeat
                        YearlyRevenue += RentalLedger."Total Amount";
                    until RentalLedger.Next() = 0;
                    
                RentalLedger.SetRange("Invoice Month", DMY2Date(1, 1, PreviousYear), DMY2Date(31, 12, PreviousYear));
                if RentalLedger.FindSet() then
                    repeat
                        PreviousYearRevenue += RentalLedger."Total Amount";
                    until RentalLedger.Next() = 0;
            until RentalUnit.Next() = 0;
            
        if PreviousYearRevenue <> 0 then
            exit((YearlyRevenue - PreviousYearRevenue) / PreviousYearRevenue * 100)
        else
            exit(0);
    end;

    procedure CalculateTaxLiability(TaxYear: Integer): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TaxableIncome: Decimal;
        Depreciation: Decimal;
        TaxLiability: Decimal;
        YearStartDate: Date;
        YearEndDate: Date;
    begin
        YearStartDate := DMY2Date(1, 1, TaxYear);
        YearEndDate := DMY2Date(31, 12, TaxYear);
        
        RentalLedger.SetRange("Invoice Month", YearStartDate, YearEndDate);
        if RentalLedger.FindSet() then
            repeat
                TaxableIncome += RentalLedger."Base Rent Amount";
                TaxableIncome -= RentalLedger."Maintenance Fees" * 0.8; // 80% deductible
                Depreciation += RentalLedger."Square Feet" * 0.25; // Depreciation calculation
            until RentalLedger.Next() = 0;
            
        TaxableIncome -= Depreciation;
        TaxLiability := TaxableIncome * 0.21; // 21% tax rate
        exit(TaxLiability);
    end;

    procedure ExportFinancialData(StartDate: Date; EndDate: Date): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ExportCount: Integer;
        ExportLine: Text;
    begin
        RentalLedger.SetRange("Invoice Month", StartDate, EndDate);
        if RentalLedger.FindSet() then
            repeat
                ExportLine := Format(RentalLedger."Entry No.") + ',' +
                    RentalLedger."Unit No." + ',' +
                    Format(RentalLedger."Base Rent Amount") + ',' +
                    Format(RentalLedger."Maintenance Fees") + ',' +
                    Format(RentalLedger."Utility Charges") + ',' +
                    Format(RentalLedger."Invoice Month");
                ExportCount += 1;
                // Simulate export processing
                Sleep(Random(2));
            until RentalLedger.Next() = 0;
        exit(ExportCount);
    end;
}
