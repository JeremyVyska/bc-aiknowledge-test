codeunit 50415 "T3 Environmental Compliance"
{
    // Environmental monitoring and sustainability reporting
    
    trigger OnRun()
    begin
        MonitorEnergyEfficiency();
        GenerateSustainabilityReport();
    end;
    
    procedure MonitorEnergyEfficiency(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        EnergyPerSqFt: Decimal;
        TotalEnergy: Decimal;
        TotalSqFt: Decimal;
    begin
        if RentalLedger.FindSet() then
            repeat
                TotalEnergy += RentalLedger."Energy Usage KWH";
                TotalSqFt += RentalLedger."Square Feet";
            until RentalLedger.Next() = 0;
        if TotalSqFt > 0 then
            EnergyPerSqFt := TotalEnergy / TotalSqFt;
        exit(EnergyPerSqFt);
    end;

    procedure GenerateSustainabilityReport(): Integer
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        SustainabilityMetrics: Integer;
        WaterUsage: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                WaterUsage := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        WaterUsage += RentalLedger."Water Usage Gallons";
                    until RentalLedger.Next() = 0;
                if WaterUsage < 10000 then // Efficient water usage
                    SustainabilityMetrics += 1;
            until RentalUnit.Next() = 0;
        exit(SustainabilityMetrics);
    end;
}
