codeunit 50304 "T2 Tenant Services"
{
    // Tenant communication and service request handling

    procedure ProcessServiceRequests(): Integer
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        ServiceCount: Integer;
        UnitMaintenanceHours: Decimal;
    begin
        if RentalUnit.FindSet() then
            repeat
                UnitMaintenanceHours := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UnitMaintenanceHours += RentalLedger."Maintenance Hours";
                    until RentalLedger.Next() = 0;
                    
                if UnitMaintenanceHours > 20 then begin
                    ServiceCount += 1;
                    // Simulate service request processing
                    Sleep(Random(4));
                end;
            until RentalUnit.Next() = 0;
        exit(ServiceCount);
    end;

    procedure CalculateTenantSatisfaction(PropertyManager: Code[20]): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        SatisfactionScore: Decimal;
        TenantCount: Integer;
        AvgMaintenanceHours: Decimal;
        TotalMaintenanceHours: Decimal;
    begin
        RentalUnit.SetRange("Property Manager", PropertyManager);
        if RentalUnit.FindSet() then
            repeat
                TenantCount += 1;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        TotalMaintenanceHours += RentalLedger."Maintenance Hours";
                    until RentalLedger.Next() = 0;
            until RentalUnit.Next() = 0;
            
        if TenantCount > 0 then begin
            AvgMaintenanceHours := TotalMaintenanceHours / TenantCount;
            SatisfactionScore := 100 - (AvgMaintenanceHours * 2); // Lower maintenance = higher satisfaction
        end;
        
        exit(SatisfactionScore);
    end;

    procedure GenerateTenantReports(): Boolean
    var
        RentalLedger: Record "Monthly Rental Ledger";
        ReportCount: Integer;
        TextData: Text;
    begin
        if RentalLedger.FindSet() then
            repeat
                TextData := RentalLedger."Unit No." + ',' + 
                    Format(RentalLedger."Total Amount") + ',' + 
                    Format(RentalLedger."Maintenance Hours");
                ReportCount += 1;
                // Simulate report generation
                Sleep(Random(2));
            until RentalLedger.Next() = 0;
        exit(ReportCount > 0);
    end;

    procedure GetTenantPaymentHistory(TenantNo: Code[20]): Decimal
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        TotalPayments: Decimal;
        UnitPayments: Decimal;
    begin
        RentalUnit.SetRange("Tenant No.", TenantNo);
        if RentalUnit.FindSet() then
            repeat
                UnitPayments := 0;
                RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
                if RentalLedger.FindSet() then
                    repeat
                        UnitPayments += RentalLedger."Total Amount";
                    until RentalLedger.Next() = 0;
                TotalPayments += UnitPayments;
            until RentalUnit.Next() = 0;
        exit(TotalPayments);
    end;
}
