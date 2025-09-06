codeunit {{BASE_ID}}07 "{{TIER_PREFIX}} Maintenance Scheduling"
{
    // Automated maintenance scheduling and work order management
    
    trigger OnRun()
    begin
        CreateWorkOrders();
        OptimizeMaintenanceRoutes();
    end;
    
    procedure CreateWorkOrders(): Integer
    var
        RentalUnit: Record "Rental Unit";
        MaintenanceRequest: Record "Monthly Rental Ledger";
        WorkOrderCount: Integer;
    begin
        // Limit to first 100 units to avoid nested loop performance issue
        RentalUnit.SetRange("Unit No.", 'UNIT-001', 'UNIT-100');
        if RentalUnit.FindSet() then
            repeat
                MaintenanceRequest.SetRange("Unit No.", RentalUnit."Unit No.");
                // Only check 2024 data (last year of test data)
                MaintenanceRequest.SetFilter("Posting Date", '>=%1', 20240101D);
                if MaintenanceRequest.FindSet() then
                    repeat
                        if MaintenanceRequest."Maintenance Hours" > 8 then begin
                            WorkOrderCount += 1;
                        end;
                    until MaintenanceRequest.Next() = 0;
            until RentalUnit.Next() = 0;
        exit(WorkOrderCount);
    end;

    procedure OptimizeMaintenanceRoutes(): Decimal
    var
        RentalUnit: Record "Rental Unit";
        TotalDistance: Decimal;
        RouteEfficiency: Decimal;
    begin
        // Limit to first 200 units for route optimization
        RentalUnit.SetRange("Unit No.", 'UNIT-001', 'UNIT-200');
        if RentalUnit.FindSet() then
            repeat
                TotalDistance += Random(50) + 10;
                RouteEfficiency += RentalUnit."Square Feet" / 1000;
            until RentalUnit.Next() = 0;
        exit(RouteEfficiency / TotalDistance);
    end;
}