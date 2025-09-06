codeunit 50509 "T4 Inspection Services"
{
    // Property inspection and compliance monitoring
    
    trigger OnRun()
    begin
        ScheduleInspections();
        ValidateComplianceStandards();
    end;
    
    procedure ScheduleInspections(): Integer
    var
        RentalUnit: Record "Rental Unit";
        InspectionCount: Integer;
        InspectionDate: Date;
    begin
        if RentalUnit.FindSet() then
            repeat
                InspectionDate := CalcDate('<+1Y>', RentalUnit."Lease Start Date");
                if InspectionDate <= Today then begin
                    InspectionCount += 1;
                    Sleep(Random(3));
                end;
            until RentalUnit.Next() = 0;
        exit(InspectionCount);
    end;

    procedure ValidateComplianceStandards(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        ComplianceScore: Decimal;
        TotalUnits: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                TotalUnits += 1;
                if RentalUnit."Square Feet" >= 500 then
                    ComplianceScore += 1;
                if RentalUnit."HVAC Zone" <> '' then
                    ComplianceScore += 1;
            until RentalUnit.Next() = 0;
        if TotalUnits > 0 then
            exit(ComplianceScore / TotalUnits * 100)
        else
            exit(0);
    end;
}
