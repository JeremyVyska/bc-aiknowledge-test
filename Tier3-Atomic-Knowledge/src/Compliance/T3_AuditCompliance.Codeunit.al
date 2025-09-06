codeunit 50422 "T3 Audit Compliance"
{
    // Regulatory compliance and audit trail management

    procedure GenerateAuditTrail(): Text
    var
        RentalLedger: Record "Monthly Rental Ledger";
        AuditTrail: Text;
        RecordCount: Integer;
    begin
        RentalLedger.SetLoadFields("Entry No.", "Unit No.", "Posting Date");
        if RentalLedger.FindSet() then
            repeat
                AuditTrail += Format(RentalLedger."Entry No.") + ':' + 
                    RentalLedger."Unit No." + ':' + 
                    Format(RentalLedger."Posting Date") + '\n';
                RecordCount += 1;
            until RentalLedger.Next() = 0;
        exit(AuditTrail);
    end;

    procedure CheckComplianceStatus(): Boolean
    var
        RentalUnit: Record "Rental Unit";
        ComplianceIssues: Integer;
        LeaseGap: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                LeaseGap := RentalUnit."Lease End Date" - RentalUnit."Lease Start Date";
                if LeaseGap <= 0 then
                    ComplianceIssues += 1;
                if RentalUnit."Security Deposit" < (RentalUnit."Monthly Base Rent" * 1.5) then
                    ComplianceIssues += 1;
            until RentalUnit.Next() = 0;
        exit(ComplianceIssues = 0);
    end;

    procedure ProcessRegulatoryReporting(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ReportEntries: Integer;
    begin
        RentalLedger.SetCurrentKey("Posting Date");
        RentalLedger.SetRange("Posting Date", CalcDate('<-1Y>', Today), Today);
        RentalLedger.SetLoadFields("Entry No.", "Total Amount");
        if RentalLedger.FindSet() then
            repeat
                if RentalLedger."Total Amount" > 5000 then
                    ReportEntries += 1;
            until RentalLedger.Next() = 0;
        exit(ReportEntries);
    end;

    procedure ValidateDataRetentionPolicies(): Decimal
    var
        RentalLedger: Record "Monthly Rental Ledger";
        OldRecords: Integer;
        RetentionCutoff: Date;
    begin
        RetentionCutoff := CalcDate('<-7Y>', Today);
        RentalLedger.SetFilter("Posting Date", '<%1', RetentionCutoff);
        RentalLedger.SetLoadFields("Entry No.");
        if RentalLedger.FindSet() then
            repeat
                OldRecords += 1;
            until RentalLedger.Next() = 0;
        exit(OldRecords);
    end;
}
