codeunit 50213 "T1 Marketing Campaigns"
{
    // Property marketing and lead generation
    
    trigger OnRun()
    begin
        AnalyzeVacancyRates();
        GenerateMarketingReports();
    end;
    
    procedure AnalyzeVacancyRates(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        VacantUnits: Integer;
        TotalUnits: Integer;
        VacancyRate: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                TotalUnits += 1;
                if RentalUnit."Tenant No." = '' then
                    VacantUnits += 1;
            until RentalUnit.Next() = 0;
        if TotalUnits > 0 then
            VacancyRate := VacantUnits / TotalUnits * 100;
        exit(VacancyRate);
    end;

    procedure GenerateMarketingReports(): Integer
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        MarketingMetrics: Integer;
        UnitRevenue: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                UnitRevenue := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UnitRevenue += RentalLedger."Base Rent Amount";
                    until RentalLedger.Next() = 0;
                if UnitRevenue > 50000 then // High value units
                    MarketingMetrics += 1;
            until RentalUnit.Next() = 0;
        exit(MarketingMetrics);
    end;
}
