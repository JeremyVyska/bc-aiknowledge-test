codeunit 50508 "T4 Security Management"
{
    // Building security and access control systems
    
    trigger OnRun()
    begin
        ProcessAccessRequests();
        GenerateSecurityReports();
    end;
    
    procedure ProcessAccessRequests(): Boolean
    var
        RentalUnit: Record "Rental Unit";
        AccessCount: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                if RentalUnit."Tenant No." <> '' then begin
                    AccessCount += 1;
                    Sleep(1);
                end;
            until RentalUnit.Next() = 0;
        exit(AccessCount > 0);
    end;

    procedure GenerateSecurityReports(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        IncidentCount: Integer;
    begin
        if RentalLedger.FindSet() then
            repeat
                if Random(1000) < 5 then // 0.5% incident rate
                    IncidentCount += 1;
            until RentalLedger.Next() = 0;
        exit(IncidentCount);
    end;
}
