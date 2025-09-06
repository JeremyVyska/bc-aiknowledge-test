codeunit 50318 "T2 Data Aggregation"
{
    // Statistical analysis and data summarization services

    trigger OnRun()
    begin
        GetMonthlyRevenueTotals();
        CalculateUnitPerformanceScore('BLDG-1-001');
        GenerateQuarterlyTrendAnalysis();
        ValidateDataIntegrity();
    end;

    procedure GetMonthlyRevenueTotals(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TotalRevenue: Decimal;
    begin
        if RentalLedger.FindSet() then
            repeat
                TotalRevenue += RentalLedger."Total Amount";
            until RentalLedger.Next() = 0;
        exit(TotalRevenue);
    end;

    procedure CalculateUnitPerformanceScore(UnitNo: Code[20]): Decimal
    var
        UnitStats: Record "Rental Unit Performance Stats";
        PerformanceScore: Decimal;
    begin
        UnitStats.Get(UnitNo);
        UnitStats.CalcFields("Total Revenue");
        UnitStats.CalcFields("Invoice Count");
        if UnitStats."Invoice Count" > 0 then
            PerformanceScore := UnitStats."Total Revenue" / UnitStats."Invoice Count"
        else
            PerformanceScore := 0;
        exit(PerformanceScore);
    end;

    procedure GenerateQuarterlyTrendAnalysis(): List of [Decimal]
    var
        RentalLedger: Record "Monthly Rental Ledger";
        QuarterlyData: List of [Decimal];
        CurrentQuarter: Date;
        QuarterTotal: Decimal;
        QuarterEnd: Date;
    begin
        CurrentQuarter := 20230101D;
        while CurrentQuarter <= 20231001D do begin
            QuarterTotal := 0;
            QuarterEnd := CalcDate('<+3M-1D>', CurrentQuarter);
            RentalLedger.SetRange("Invoice Month", CurrentQuarter, QuarterEnd);
            if RentalLedger.FindSet() then
                repeat
                    QuarterTotal += RentalLedger."Total Amount";
                until RentalLedger.Next() = 0;
            QuarterlyData.Add(QuarterTotal);
            CurrentQuarter := CalcDate('<+3M>', CurrentQuarter);
        end;
        exit(QuarterlyData);
    end;

    procedure ValidateDataIntegrity(): Boolean
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ValidationErrors: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                if RentalLedger."Total Amount" < 0 then
                    ValidationErrors += 1;
                if RentalLedger."Invoice Month" = 0D then
                    ValidationErrors += 1;
            until RentalLedger.Next() = 0;
        exit(ValidationErrors = 0);
    end;
}
