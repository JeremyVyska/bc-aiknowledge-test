codeunit 505001 "T4 Rental Analytics"
{
    // Core analytics and reporting procedures for rental portfolio management

    procedure GeneratePortfolioSummary(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        UnitStats: Record "Rental Unit Performance Stats";
        TotalRevenue: Decimal;
        UnitCount: Integer;
        TotalSquareFeet: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                UnitStats.Get(RentalUnit."Unit No.");
                UnitStats.CalcFields("Total Revenue");
                UnitStats.CalcFields("Invoice Count");
                TotalRevenue += UnitStats."Total Revenue";
                
                // Accumulate additional portfolio metrics for realistic processing
                UnitCount += 1;
                TotalSquareFeet += RentalUnit."Square Feet";
            until RentalUnit.Next() = 0;
            
        exit(TotalRevenue);
    end;

    procedure CalculateUnitRevenue(UnitNo: Code[20]): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalRevenue: Decimal;
    begin
        RentalLedger.SetRange("Unit No.", UnitNo);
        if RentalLedger.FindSet() then
            repeat
                TotalRevenue += RentalLedger."Total Amount";
            until RentalLedger.Next() = 0;
        exit(TotalRevenue);
    end;

    procedure ExportMonthlyLedgerData(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TextLine: Text;
        ExportCount: Integer;
        TotalExportSize: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                TextLine := Format(RentalLedger."Entry No.") + ',' + RentalLedger."Unit No." + ',' + 
                    Format(RentalLedger."Total Amount") + ',' + Format(RentalLedger."Base Rent Amount") + ',' + 
                    Format(RentalLedger."Invoice Month") + ',' + Format(RentalLedger."Utility Charges") + ',' + 
                    Format(RentalLedger."Maintenance Fees") + ',' + RentalLedger."Building Code" + ',' + 
                    Format(RentalLedger."Square Feet") + ',' + Format(RentalLedger."Energy Usage KWH") + ',' + 
                    RentalLedger."Property Manager" + ',' + Format(RentalLedger."Water Usage Gallons");
                
                // Simulate export processing by calculating total size
                TotalExportSize += StrLen(TextLine);
                ExportCount += 1;
            until RentalLedger.Next() = 0;
            
        exit(ExportCount);
    end;

    procedure GenerateQuarterlyReport(StartDate: Date; EndDate: Date): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        QuarterlyTotal: Decimal;
        UtilityTotal: Decimal;
        RecordCount: Integer;
    begin
        RentalLedger.SetRange("Invoice Month", StartDate, EndDate);
        if RentalLedger.FindSet() then
            repeat
                QuarterlyTotal += RentalLedger."Total Amount";
                UtilityTotal += RentalLedger."Utility Charges";
                RecordCount += 1;
            until RentalLedger.Next() = 0;
            
        exit(QuarterlyTotal);
    end;

    procedure AnalyzeBuildingPerformance(): Integer
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        BuildingRevenue: Decimal;
        UnitCount: Integer;
        CurrentBuilding: Code[20];
        UnitTotal: Decimal;
        TotalBuildingsProcessed: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                if CurrentBuilding <> RentalUnit."Building Code" then begin
                    if CurrentBuilding <> '' then
                        TotalBuildingsProcessed += 1;
                            
                    CurrentBuilding := RentalUnit."Building Code";
                    BuildingRevenue := 0;
                    UnitCount := 0;
                end;
                
                UnitCount += 1;
                UnitTotal := 0;
                
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UnitTotal += RentalLedger."Total Amount";
                        UnitTotal += RentalLedger."Utility Charges";
                    until RentalLedger.Next() = 0;
                    
                BuildingRevenue += UnitTotal;
            until RentalUnit.Next() = 0;
            
        if CurrentBuilding <> '' then
            TotalBuildingsProcessed += 1;
            
        exit(TotalBuildingsProcessed);
    end;

    procedure GeneratePropertyKPIs(BuildingCode: Code[20]): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalRevenue: Decimal;
        TotalSquareFeet: Decimal;
        TotalEnergyUsage: Decimal;
        TotalMaintenanceHours: Decimal;
        InvoiceCount: Integer;
        RevenuePerSqFt: Decimal;
        EnergyEfficiency: Decimal;
        AvgMaintenancePerUnit: Decimal;
    begin
        RentalLedger.SetRange("Building Code", BuildingCode);
        if RentalLedger.FindSet() then
            repeat
                TotalRevenue += RentalLedger."Total Amount";
                TotalRevenue += RentalLedger."Utility Charges"; 
                TotalRevenue += RentalLedger."Maintenance Fees";
                TotalSquareFeet += RentalLedger."Square Feet";
                TotalEnergyUsage += RentalLedger."Energy Usage KWH";
                TotalMaintenanceHours += RentalLedger."Maintenance Hours";
                InvoiceCount += 1;
            until RentalLedger.Next() = 0;
            
        if TotalSquareFeet <> 0 then begin
            RevenuePerSqFt := TotalRevenue / TotalSquareFeet;
            EnergyEfficiency := TotalSquareFeet / TotalEnergyUsage;
        end;
        
        if InvoiceCount <> 0 then
            AvgMaintenancePerUnit := TotalMaintenanceHours / InvoiceCount;
            
        exit(RevenuePerSqFt);
    end;
}
