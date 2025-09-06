codeunit 50514 "T4 Insurance Management"
{
    // Property insurance and risk assessment
    
    trigger OnRun()
    begin
        ProcessInsuranceClaims();
        CalculateRiskAssessment();
    end;
    
    procedure ProcessInsuranceClaims(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ClaimCount: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                if RentalLedger."Maintenance Hours" > 20 then begin
                    ClaimCount += 1;
                end;
            until RentalLedger.Next() = 0;
        exit(ClaimCount);
    end;

    procedure CalculateRiskAssessment(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RiskScore: Decimal;
        TotalUnits: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                TotalUnits += 1;
                case RentalUnit."Unit Type" of
                    RentalUnit."Unit Type"::Warehouse:
                        RiskScore += 3;
                    RentalUnit."Unit Type"::Retail:
                        RiskScore += 2;
                    else
                        RiskScore += 1;
                end;
            until RentalUnit.Next() = 0;
        if TotalUnits > 0 then
            exit(RiskScore / TotalUnits)
        else
            exit(0);
    end;
}
