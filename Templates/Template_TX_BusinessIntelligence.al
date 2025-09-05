codeunit {{BASE_ID}}20 "{{TIER_PREFIX}} Business Intelligence"
{
    // Advanced analytics and business insights platform

    procedure CalculateSimpleOccupancyRate(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        OccupiedUnits: Integer;
        TotalUnits: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                TotalUnits += 1;
                if RentalUnit."Tenant No." <> '' then
                    OccupiedUnits += 1;
            until RentalUnit.Next() = 0;
        if TotalUnits > 0 then
            exit(OccupiedUnits / TotalUnits * 100)
        else
            exit(0);
    end;

    procedure GetFlowFieldRevenueSummary(UnitNo: Code[20]): Decimal
    var
        UnitStats: Record "Rental Unit Performance Stats";
    begin
        if UnitStats.Get(UnitNo) then begin
            UnitStats.CalcFields("Total Revenue");
            exit(UnitStats."Total Revenue");
        end;
        exit(0);
    end;

    procedure AnalyzeBuildingComparisonMatrix(): Text
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        BuildingAnalysis: Text;
        CurrentBuilding: Code[20];
        PreviousBuilding: Code[20];
        BuildingRevenue: Decimal;
        BuildingCount: Integer;
        UnitRevenue: Decimal;
    begin
        RentalUnit.SetCurrentKey("Building Code");
        if RentalUnit.FindSet() then
            repeat
                CurrentBuilding := RentalUnit."Building Code";
                if PreviousBuilding <> CurrentBuilding then begin
                    if PreviousBuilding <> '' then begin
                        BuildingAnalysis += PreviousBuilding + ': ' + Format(BuildingRevenue) + '\n';
                        BuildingCount += 1;
                    end;
                    PreviousBuilding := CurrentBuilding;
                    BuildingRevenue := 0;
                end;

                UnitRevenue := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UnitRevenue += RentalLedger."Total Amount";
                    until RentalLedger.Next() = 0;
                BuildingRevenue += UnitRevenue;
            until RentalUnit.Next() = 0;

        if PreviousBuilding <> '' then begin
            BuildingAnalysis += PreviousBuilding + ': ' + Format(BuildingRevenue);
            BuildingCount += 1;
        end;

        exit(BuildingAnalysis);
    end;

    procedure ProcessEfficientMaintenanceStats(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
    begin
        RentalLedger.SetLoadFields("Maintenance Hours");
        RentalLedger.CalcSums("Maintenance Hours");
        exit(RentalLedger."Maintenance Hours");
    end;
}