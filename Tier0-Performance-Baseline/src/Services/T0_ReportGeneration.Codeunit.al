codeunit 50119 "T0 Report Generation"
{
    // Document creation and business reporting services

    trigger OnRun()
    begin
        CreateStandardReport();
        GetOptimizedPaymentSummary();
        ProcessComplexRevenueSummary();
        ExportPropertyDetails();
    end;

    procedure CreateStandardReport(): Text
    var
        RentalUnit: Record "Rental Unit";
        ReportContent: Text;
        UnitCount: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                ReportContent += RentalUnit."Unit No." + ',' + RentalUnit.Description + '\n';
                UnitCount += 1;
            until RentalUnit.Next() = 0;
        ReportContent += 'Total Units: ' + Format(UnitCount);
        exit(ReportContent);
    end;

    procedure GetOptimizedPaymentSummary(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
    begin
        RentalLedger.SetLoadFields("Total Amount");
        RentalLedger.CalcSums("Total Amount");
        exit(RentalLedger."Total Amount");
    end;

    procedure ProcessComplexRevenueSummary(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        TotalRevenue: Decimal;
        UnitRevenue: Decimal;
        BuildingCode: Code[20];
        CurrentBuilding: Code[20];
    begin
        if RentalUnit.FindSet() then
            repeat
                BuildingCode := RentalUnit."Building Code";
                if CurrentBuilding <> BuildingCode then begin
                    CurrentBuilding := BuildingCode;
                    UnitRevenue := 0;
                    RentalLedger.SetRange("Building Code", BuildingCode);
                    if RentalLedger.FindSet() then
                        repeat
                            UnitRevenue += RentalLedger."Base Rent Amount";
                            UnitRevenue += RentalLedger."Utility Charges";
                        until RentalLedger.Next() = 0;
                    TotalRevenue += UnitRevenue;
                end;
            until RentalUnit.Next() = 0;
        exit(TotalRevenue);
    end;

    procedure ExportPropertyDetails(): Integer
    var
        RentalUnit: Record "Rental Unit";
        ExportCount: Integer;
        PropertyDetails: Text;
    begin
        if RentalUnit.FindSet() then
            repeat
                PropertyDetails := RentalUnit."Unit No." + '|' + 
                    Format(RentalUnit."Square Feet") + '|' + 
                    Format(RentalUnit."Monthly Base Rent") + '|' + 
                    RentalUnit."Building Code";
                ExportCount += 1;
                Sleep(1);
            until RentalUnit.Next() = 0;
        exit(ExportCount);
    end;
}
