codeunit 50020 "Test Data Generator"
{
    procedure GenerateAllTestData(): Boolean
    var
        Window: Dialog;
    begin
        Window.Open('Test Data Generation Progress\' +
                    'Phase: #1###################\' +
                    'Progress: #2###############\' +
                    'Status: #3##################');

        Window.Update(1, 'Generating Rental Units');
        Window.Update(2, '');
        Window.Update(3, 'Starting...');
        GenerateRentalUnits(Window);

        Window.Update(1, 'Generating Monthly Ledger Entries');
        Window.Update(2, '');
        Window.Update(3, 'Processing 3.6M+ records...');
        GenerateMonthlyLedgerEntries(Window);

        Window.Update(1, 'Generating Performance Stats');
        Window.Update(2, '');
        Window.Update(3, 'Finalizing...');
        GeneratePerformanceStats(Window);

        Window.Update(1, 'Complete!');
        Window.Update(2, '100%');
        Window.Update(3, '5K units + 3.6M ledger entries created');
        Sleep(2000); // Show completion for 2 seconds
        Window.Close();

        exit(true);
    end;

    procedure GenerateRentalUnits(var Window: Dialog)
    var
        RentalUnit: Record "Rental Unit";
        BuildingCode: Code[20];
        ProgressPct: Decimal;
        BuildingCount: Integer;
        UnitCount: Integer;
    begin
        RentalUnit.DeleteAll();

        for BuildingCount := 1 to 50 do begin
            BuildingCode := 'BLDG-' + Format(BuildingCount);

            // Update progress every 5 buildings
            if BuildingCount mod 5 = 0 then begin
                ProgressPct := BuildingCount / 50 * 100;
                Window.Update(2, Format(ProgressPct, 0, '<Integer,3>') + '%');
                Window.Update(3, 'Building ' + Format(BuildingCount) + ' of 50');
            end;

            for UnitCount := 1 to 100 do begin
                RentalUnit.Init();
                RentalUnit."Unit No." := BuildingCode + '-' + Format(UnitCount, 0, '<Integer,3><Filler Character,0>');
                RentalUnit.Description := GenerateUnitDescription(GenerateRandomUnitType());
                RentalUnit."Building Code" := BuildingCode;
                RentalUnit.Floor := Random(20) + 1;
                RentalUnit."Unit Type" := GenerateRandomUnitType();
                RentalUnit."Square Feet" := GenerateSquareFeet(RentalUnit."Unit Type");
                RentalUnit."Monthly Base Rent" := CalculateBaseRent(RentalUnit."Unit Type", RentalUnit."Square Feet");
                RentalUnit."Tenant No." := GenerateTenantNo();
                RentalUnit."Lease Start Date" := GenerateLeaseStartDate();
                RentalUnit."Lease End Date" := CalcDate('<+2Y>', RentalUnit."Lease Start Date");
                RentalUnit."Property Manager" := GeneratePropertyManager(BuildingCount);
                RentalUnit."Parking Spaces" := GenerateParkingSpaces(RentalUnit."Unit Type");
                RentalUnit."HVAC Zone" := Format(Random(5) + 1);
                RentalUnit."Security Deposit" := RentalUnit."Monthly Base Rent" * 2;
                RentalUnit."Utilities Included" := (Random(10) < 3);
                RentalUnit.Insert();
            end;
        end;
    end;

    procedure GenerateMonthlyLedgerEntries(var Window: Dialog)
    var
        RentalLedger: Record "Monthly Rental Ledger";
        RentalUnit: Record "Rental Unit";
        InvoiceDate: Date;
        LastUpdateTime: DateTime;
        ProgressPct: Decimal;
        EntryNo: Integer;
        TotalUnits: Integer;
        UnitCounter: Integer;
    begin
        RentalLedger.DeleteAll();
        EntryNo := 1;
        UnitCounter := 0;

        if RentalUnit.FindSet() then
            TotalUnits := RentalUnit.Count();

        LastUpdateTime := CurrentDateTime;

        if RentalUnit.FindSet() then
            repeat
                UnitCounter += 1;
                InvoiceDate := 20190101D; // Start from January 2019

                // Update progress every minute or every 100 units, whichever comes first
                if (UnitCounter mod 100 = 0) or (CurrentDateTime - LastUpdateTime >= 60000) then begin
                    ProgressPct := UnitCounter / TotalUnits * 100;
                    Window.Update(2, Format(ProgressPct, 0, '<Integer,3>') + '%');
                    Window.Update(3, 'Unit ' + Format(UnitCounter) + ' of ' + Format(TotalUnits) + ' (' + Format(EntryNo) + ' entries)');
                    LastUpdateTime := CurrentDateTime;
                end;

                while InvoiceDate <= 20241201D do begin // Through December 2024 (6 years total)
                    // Generate multiple entries per month to reach 3M+ scale
                    // Main invoice entry
                    RentalLedger.Init();
                    RentalLedger."Entry No." := EntryNo;
                    RentalLedger."Unit No." := RentalUnit."Unit No.";
                    RentalLedger."Posting Date" := InvoiceDate;
                    RentalLedger."Invoice Month" := InvoiceDate;
                    RentalLedger."Tenant No." := RentalUnit."Tenant No.";
                    RentalLedger."Building Code" := RentalUnit."Building Code";
                    RentalLedger."Unit Type" := RentalUnit."Unit Type";
                    RentalLedger."Property Manager" := RentalUnit."Property Manager";

                    // Generate revenue amounts with seasonal variation
                    RentalLedger."Base Rent Amount" := GenerateBaseRentAmount(RentalUnit."Monthly Base Rent", InvoiceDate);
                    RentalLedger."Utility Charges" := GenerateUtilityCharges(RentalUnit."Square Feet", InvoiceDate);
                    RentalLedger."Maintenance Fees" := GenerateMaintenanceFees(RentalUnit."Unit Type");
                    RentalLedger."Parking Fees" := GenerateParkingFees(RentalUnit."Parking Spaces");
                    RentalLedger."Late Fees" := GenerateLateFees(RentalLedger."Base Rent Amount");
                    RentalLedger."Total Amount" := RentalLedger."Base Rent Amount" + RentalLedger."Utility Charges" +
                                                  RentalLedger."Maintenance Fees" + RentalLedger."Parking Fees" + RentalLedger."Late Fees";

                    // Generate usage and performance metrics
                    RentalLedger."Square Feet" := RentalUnit."Square Feet";
                    RentalLedger."Occupancy Days" := GenerateOccupancyDays(InvoiceDate);
                    RentalLedger."Maintenance Hours" := GenerateMaintenanceHours(RentalUnit."Unit Type", InvoiceDate);
                    RentalLedger."Energy Usage KWH" := GenerateEnergyUsage(RentalUnit."Square Feet", InvoiceDate);
                    RentalLedger."Water Usage Gallons" := GenerateWaterUsage(RentalUnit."Unit Type", InvoiceDate);
                    RentalLedger."Payment Status" := GeneratePaymentStatus();
                    RentalLedger."Invoice Generated" := true;

                    RentalLedger.Insert();
                    EntryNo += 1;

                    // Generate 9 additional transaction variants per month to reach 3M+ scale
                    // (Adjustments, partial payments, maintenance events, etc.)
                    GenerateAdditionalMonthlyTransactions(RentalUnit, InvoiceDate, EntryNo);

                    InvoiceDate := CalcDate('<+1M>', InvoiceDate);
                end;
            until RentalUnit.Next() = 0;
    end;

    procedure GeneratePerformanceStats(var Window: Dialog)
    var
        RentalUnit: Record "Rental Unit";
        PerformanceStats: Record "Rental Unit Performance Stats";
        ProgressPct: Decimal;
        TotalUnits: Integer;
        UnitCounter: Integer;
    begin
        PerformanceStats.DeleteAll();

        if RentalUnit.FindSet() then
            TotalUnits := RentalUnit.Count();

        UnitCounter := 0;
        if RentalUnit.FindSet() then
            repeat
                UnitCounter += 1;

                if UnitCounter mod 500 = 0 then begin
                    ProgressPct := UnitCounter / TotalUnits * 100;
                    Window.Update(2, Format(ProgressPct, 0, '<Integer,3>') + '%');
                    Window.Update(3, 'Performance stats: ' + Format(UnitCounter) + ' of ' + Format(TotalUnits));
                end;

                PerformanceStats.Init();
                PerformanceStats."Unit No." := RentalUnit."Unit No.";
                PerformanceStats.Insert();
            until RentalUnit.Next() = 0;
    end;

    local procedure GenerateRandomUnitType(): Enum "Rental Unit Type"
    var
        RandomValue: Integer;
    begin
        RandomValue := Random(100);
        case true of
            RandomValue <= 60:
                exit("Rental Unit Type"::Office);
            RandomValue <= 80:
                exit("Rental Unit Type"::Retail);
            RandomValue <= 90:
                exit("Rental Unit Type"::Warehouse);
            RandomValue <= 95:
                exit("Rental Unit Type"::Conference);
            else
                exit("Rental Unit Type"::Coworking);
        end;
    end;

    local procedure GenerateSquareFeet(UnitType: Enum "Rental Unit Type"): Decimal
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                exit(Random(2000) + 500);
            "Rental Unit Type"::Retail:
                exit(Random(4000) + 1000);
            "Rental Unit Type"::Warehouse:
                exit(Random(8000) + 2000);
            "Rental Unit Type"::Conference:
                exit(Random(500) + 200);
            "Rental Unit Type"::Coworking:
                exit(Random(1500) + 800);
        end;
    end;

    local procedure CalculateBaseRent(UnitType: Enum "Rental Unit Type"; SquareFeet: Decimal): Decimal
    var
        RentPerSqFt: Decimal;
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                RentPerSqFt := 2.5 + (Random(200) / 100);
            "Rental Unit Type"::Retail:
                RentPerSqFt := 3.0 + (Random(300) / 100);
            "Rental Unit Type"::Warehouse:
                RentPerSqFt := 1.0 + (Random(150) / 100);
            "Rental Unit Type"::Conference:
                RentPerSqFt := 4.0 + (Random(400) / 100);
            "Rental Unit Type"::Coworking:
                RentPerSqFt := 2.0 + (Random(250) / 100);
        end;
        exit(Round(SquareFeet * RentPerSqFt, 0.01));
    end;

    local procedure GenerateBaseRentAmount(BaseRent: Decimal; InvoiceDate: Date): Decimal
    var
        RandomVariation: Decimal;
        SeasonalVariation: Decimal;
    begin
        case Date2DMY(InvoiceDate, 2) of
            1, 2, 3:
                SeasonalVariation := 0.95 + (Random(10) / 100);
            4, 5, 6:
                SeasonalVariation := 0.90 + (Random(15) / 100);
            7, 8, 9:
                SeasonalVariation := 0.95 + (Random(10) / 100);
            10, 11, 12:
                SeasonalVariation := 1.00 + (Random(15) / 100);
        end;

        RandomVariation := 0.98 + (Random(4) / 100);
        exit(Round(BaseRent * SeasonalVariation * RandomVariation, 0.01));
    end;

    local procedure GenerateUtilityCharges(SquareFeet: Decimal; InvoiceDate: Date): Decimal
    var
        BaseUtilityCost: Decimal;
        SeasonalMultiplier: Decimal;
    begin
        BaseUtilityCost := SquareFeet * 0.15;

        case Date2DMY(InvoiceDate, 2) of
            12, 1, 2:
                SeasonalMultiplier := 1.3 + (Random(20) / 100);
            3, 4, 5:
                SeasonalMultiplier := 0.8 + (Random(20) / 100);
            6, 7, 8:
                SeasonalMultiplier := 1.4 + (Random(30) / 100);
            9, 10, 11:
                SeasonalMultiplier := 0.9 + (Random(20) / 100);
        end;

        exit(Round(BaseUtilityCost * SeasonalMultiplier, 0.01));
    end;

    local procedure GenerateEnergyUsage(SquareFeet: Decimal; InvoiceDate: Date): Decimal
    var
        BaseUsage: Decimal;
        SeasonalMultiplier: Decimal;
    begin
        BaseUsage := SquareFeet * 8;

        case Date2DMY(InvoiceDate, 2) of
            12, 1, 2:
                SeasonalMultiplier := 1.2 + (Random(15) / 100);
            3, 4, 5:
                SeasonalMultiplier := 0.8 + (Random(15) / 100);
            6, 7, 8:
                SeasonalMultiplier := 1.5 + (Random(25) / 100);
            9, 10, 11:
                SeasonalMultiplier := 0.9 + (Random(15) / 100);
        end;

        exit(Round(BaseUsage * SeasonalMultiplier, 0.1));
    end;

    local procedure GeneratePropertyManager(BuildingNumber: Integer): Code[20]
    begin
        exit('MGR-' + Format((BuildingNumber - 1) div 10 + 1));
    end;

    local procedure GenerateTenantNo(): Code[20]
    begin
        exit('TENANT-' + Format(Random(9999), 0, '<Integer,4><Filler Character,0>'));
    end;

    local procedure GeneratePaymentStatus(): Enum "Payment Status"
    var
        RandomValue: Integer;
    begin
        RandomValue := Random(100);
        case true of
            RandomValue <= 85:
                exit("Payment Status"::Paid);
            RandomValue <= 90:
                exit("Payment Status"::Pending);
            RandomValue <= 97:
                exit("Payment Status"::Overdue);
            else
                exit("Payment Status"::PartialPaid);
        end;
    end;

    local procedure GenerateUnitDescription(UnitType: Enum "Rental Unit Type"): Text[100]
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                exit('Modern office space with city views');
            "Rental Unit Type"::Retail:
                exit('Prime retail location with street access');
            "Rental Unit Type"::Warehouse:
                exit('Large warehouse space with loading dock');
            "Rental Unit Type"::Conference:
                exit('Professional conference room facility');
            "Rental Unit Type"::Coworking:
                exit('Flexible co-working space with amenities');
        end;
    end;

    local procedure GenerateLeaseStartDate(): Date
    begin
        exit(CalcDate('<-' + Format(Random(1095)) + 'D>', Today)); // Random date within last 3 years
    end;

    local procedure GenerateParkingSpaces(UnitType: Enum "Rental Unit Type"): Integer
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                exit(Random(5) + 1);
            "Rental Unit Type"::Retail:
                exit(Random(10) + 2);
            "Rental Unit Type"::Warehouse:
                exit(Random(3) + 1);
            "Rental Unit Type"::Conference:
                exit(Random(8) + 5);
            "Rental Unit Type"::Coworking:
                exit(Random(3));
        end;
    end;

    local procedure GenerateMaintenanceFees(UnitType: Enum "Rental Unit Type"): Decimal
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                exit(Random(200) + 50);
            "Rental Unit Type"::Retail:
                exit(Random(400) + 100);
            "Rental Unit Type"::Warehouse:
                exit(Random(800) + 200);
            "Rental Unit Type"::Conference:
                exit(Random(150) + 25);
            "Rental Unit Type"::Coworking:
                exit(Random(300) + 75);
        end;
    end;

    local procedure GenerateParkingFees(ParkingSpaces: Integer): Decimal
    begin
        exit(ParkingSpaces * (Random(50) + 25)); // $25-75 per parking space
    end;

    local procedure GenerateLateFees(BaseRentAmount: Decimal): Decimal
    begin
        if Random(100) <= 10 then // 10% chance of late fees
            exit(BaseRentAmount * 0.05) // 5% late fee
        else
            exit(0);
    end;

    local procedure GenerateOccupancyDays(InvoiceDate: Date): Integer
    var
        DaysInMonth: Integer;
    begin
        DaysInMonth := Date2DMY(CalcDate('<CM>', InvoiceDate), 1) - Date2DMY(CalcDate('<-CM>', InvoiceDate), 1) + 1;
        if Random(100) <= 95 then // 95% occupancy rate
            exit(DaysInMonth)
        else
            exit(Random(DaysInMonth));
    end;

    local procedure GenerateMaintenanceHours(UnitType: Enum "Rental Unit Type"; InvoiceDate: Date): Decimal
    var
        BaseHours: Decimal;
        SeasonalMultiplier: Decimal;
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                BaseHours := Random(5) + 1;
            "Rental Unit Type"::Retail:
                BaseHours := Random(8) + 2;
            "Rental Unit Type"::Warehouse:
                BaseHours := Random(12) + 3;
            "Rental Unit Type"::Conference:
                BaseHours := Random(3) + 1;
            "Rental Unit Type"::Coworking:
                BaseHours := Random(6) + 2;
        end;

        // More maintenance in winter and summer
        case Date2DMY(InvoiceDate, 2) of
            12, 1, 2, 6, 7, 8:
                SeasonalMultiplier := 1.2;
            else
                SeasonalMultiplier := 1.0;
        end;

        exit(Round(BaseHours * SeasonalMultiplier, 0.1));
    end;

    local procedure GenerateWaterUsage(UnitType: Enum "Rental Unit Type"; InvoiceDate: Date): Decimal
    var
        BaseUsage: Decimal;
        SeasonalMultiplier: Decimal;
    begin
        case UnitType of
            "Rental Unit Type"::Office:
                BaseUsage := Random(500) + 100;
            "Rental Unit Type"::Retail:
                BaseUsage := Random(800) + 200;
            "Rental Unit Type"::Warehouse:
                BaseUsage := Random(300) + 50;
            "Rental Unit Type"::Conference:
                BaseUsage := Random(400) + 75;
            "Rental Unit Type"::Coworking:
                BaseUsage := Random(600) + 150;
        end;

        // Higher usage in summer
        case Date2DMY(InvoiceDate, 2) of
            6, 7, 8:
                SeasonalMultiplier := 1.3;
            else
                SeasonalMultiplier := 1.0;
        end;

        exit(Round(BaseUsage * SeasonalMultiplier, 1));
    end;

    local procedure GenerateAdditionalMonthlyTransactions(RentalUnit: Record "Rental Unit"; InvoiceDate: Date; var EntryNo: Integer)
    var
        RentalLedger: Record "Monthly Rental Ledger";
        TransactionCount: Integer;
        TransactionType: Integer;
    begin
        // Generate 9 additional transactions per unit per month for realistic volume
        for TransactionCount := 1 to 9 do begin
            RentalLedger.Init();
            RentalLedger."Entry No." := EntryNo;
            RentalLedger."Unit No." := RentalUnit."Unit No.";
            RentalLedger."Building Code" := RentalUnit."Building Code";
            RentalLedger."Unit Type" := RentalUnit."Unit Type";
            RentalLedger."Property Manager" := RentalUnit."Property Manager";
            RentalLedger."Tenant No." := RentalUnit."Tenant No.";
            RentalLedger."Invoice Month" := InvoiceDate;
            RentalLedger."Square Feet" := RentalUnit."Square Feet";

            // Vary posting date within the month
            RentalLedger."Posting Date" := CalcDate('<+' + Format(Random(28)) + 'D>', InvoiceDate);

            // Generate different transaction types
            TransactionType := Random(9) + 1;
            case TransactionType of
                1:
                    begin // Utility adjustment
                        RentalLedger."Utility Charges" := Random(500) - 250; // Adjustment amount
                        RentalLedger."Total Amount" := RentalLedger."Utility Charges";
                    end;
                2:
                    begin // Maintenance event
                        RentalLedger."Maintenance Fees" := Random(800) + 100;
                        RentalLedger."Maintenance Hours" := Random(12) + 1;
                        RentalLedger."Total Amount" := RentalLedger."Maintenance Fees";
                    end;
                3:
                    begin // Partial payment
                        RentalLedger."Base Rent Amount" := -(Random(2000) + 500);
                        RentalLedger."Payment Status" := RentalLedger."Payment Status"::PartialPaid;
                        RentalLedger."Total Amount" := RentalLedger."Base Rent Amount";
                    end;
                4:
                    begin // Energy usage reading
                        RentalLedger."Energy Usage KWH" := GenerateEnergyUsage(RentalUnit."Square Feet", InvoiceDate) / 30 * Random(5);
                        RentalLedger."Total Amount" := 0;
                    end;
                5:
                    begin // Water usage reading  
                        RentalLedger."Water Usage Gallons" := GenerateWaterUsage(RentalUnit."Unit Type", InvoiceDate) / 30 * Random(5);
                        RentalLedger."Total Amount" := 0;
                    end;
                6:
                    begin // Late fee assessment
                        RentalLedger."Late Fees" := Random(200) + 50;
                        RentalLedger."Payment Status" := RentalLedger."Payment Status"::Overdue;
                        RentalLedger."Total Amount" := RentalLedger."Late Fees";
                    end;
                7:
                    begin // Parking violation
                        RentalLedger."Parking Fees" := Random(100) + 25;
                        RentalLedger."Total Amount" := RentalLedger."Parking Fees";
                    end;
                8:
                    begin // Credit adjustment
                        RentalLedger."Total Amount" := -(Random(300) + 50);
                        RentalLedger."Payment Status" := RentalLedger."Payment Status"::Paid;
                    end;
                9:
                    begin // Miscellaneous charge
                        RentalLedger."Total Amount" := Random(150) + 25;
                        RentalLedger."Payment Status" := RentalLedger."Payment Status"::Pending;
                    end;
            end;

            RentalLedger."Invoice Generated" := (TransactionType in [1, 2, 6, 7, 9]);
            RentalLedger.Insert();
            EntryNo += 1;
        end;
    end;
}