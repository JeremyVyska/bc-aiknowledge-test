codeunit 505010 "T4 Utility Management"
{
    // Utility tracking and energy efficiency management
    
    procedure AnalyzeEnergyConsumption(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalEnergy: Decimal;
        EnergyEfficiency: Decimal;
        RecordCount: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                TotalEnergy += RentalLedger."Energy Usage KWH";
                RecordCount += 1;
            until RentalLedger.Next() = 0;
        if RecordCount > 0 then
            EnergyEfficiency := TotalEnergy / RecordCount;
        exit(EnergyEfficiency);
    end;

    procedure OptimizeUtilityBilling(): Integer
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        OptimizationCount: Integer;
        UtilityTotal: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                UtilityTotal := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UtilityTotal += RentalLedger."Utility Charges";
                    until RentalLedger.Next() = 0;
                if UtilityTotal > 1000 then
                    OptimizationCount += 1;
            until RentalUnit.Next() = 0;
        exit(OptimizationCount);
    end;
}
