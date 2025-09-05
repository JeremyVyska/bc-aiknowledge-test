codeunit 503006 "T2 Market Analysis"
{
    // Market research and competitive analysis tools

    procedure AnalyzeMarketTrends(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        RentalUnit: Record "Rental Unit";
        TotalRentPerSqFt: Decimal;
        TotalSquareFeet: Decimal;
        MarketRate: Decimal;
        UnitSquareFeet: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                UnitSquareFeet := RentalUnit."Square Feet";
                TotalSquareFeet += UnitSquareFeet;
                
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        TotalRentPerSqFt += RentalLedger."Base Rent Amount" / UnitSquareFeet;
                    until RentalLedger.Next() = 0;
            until RentalUnit.Next() = 0;
            
        if TotalSquareFeet > 0 then
            MarketRate := TotalRentPerSqFt / TotalSquareFeet * 1000; // Average per 1000 sq ft
            
        exit(MarketRate);
    end;

    procedure CompareCompetitiveRates(UnitType: Enum "Rental Unit Type"): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        TypeRevenue: Decimal;
        TypeCount: Integer;
        AverageRate: Decimal;
        CompetitiveIndex: Decimal;
    begin
        RentalUnit.SetRange("Unit Type", UnitType);
        if RentalUnit.FindSet() then
            repeat
                TypeCount += 1;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        TypeRevenue += RentalLedger."Base Rent Amount";
                    until RentalLedger.Next() = 0;
            until RentalUnit.Next() = 0;
            
        if TypeCount > 0 then begin
            AverageRate := TypeRevenue / TypeCount;
            CompetitiveIndex := AverageRate / 2500; // Compare to market baseline of $2500
        end;
        
        exit(CompetitiveIndex);
    end;

    procedure GenerateMarketReport(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ReportLines: Integer;
        MarketData: Text;
    begin
        if RentalLedger.FindSet() then
            repeat
                MarketData := RentalLedger."Building Code" + ',' +
                    Format(RentalLedger."Square Feet") + ',' +
                    Format(RentalLedger."Base Rent Amount") + ',' +
                    Format(RentalLedger."Unit Type");
                ReportLines += 1;
                // Simulate market analysis processing
                Sleep(Random(3));
            until RentalLedger.Next() = 0;
        exit(ReportLines);
    end;
}
