# Common Baseline Features - Five-Tier Copilot Testing

**Purpose**: Define the shared data infrastructure and tier-specific testing objects for the Five-Tier Copilot Testing Protocol. Uses a Common extension for shared data and separate tier extensions for isolated optimization testing.

**Date**: 2025-01-26  
**Status**: Planning phase - ready for implementation

---

## 🎯 **Testing Strategy**

Each tier contains **identical inefficient code** with tier-specific prefixes to test how different knowledge contexts influence Copilot's optimization suggestions:

- **Tier 0**: Performance baseline - no optimization applied
- **Tier 1**: Generic programming knowledge only
- **Tier 2**: General BC community knowledge  
- **Tier 3**: Focused atomic BC performance topics
- **Tier 4**: MCP-enhanced intelligent knowledge delivery

## 🏗️ **Architecture Overview**

### **Common Extension - Shared Data Infrastructure**
- **Extension Name**: `Common-Data-Infrastructure`
- **ID Range**: 50000-50099
- **Purpose**: Single source of truth for all test data and shared infrastructure
- **Contents**: Data storage tables, data generator, setup objects, master data pages

### **Tier Extensions - Testing & Camouflage Objects**
- **Extension Names**: `Tier0-Performance-Baseline`, `Tier1-Baseline-NoKnowledge`, etc.
- **ID Ranges**: 50100-50199 (T0), 50200-50299 (T1), 50300-50399 (T2), 50400-50499 (T3), 50500-50599 (T4)
- **Dependencies**: Each tier extension depends on Common extension
- **Contents**: Tier-prefixed inefficient codeunits + complete camouflage object forest

---

## 📋 **Common Extension - Data Infrastructure**

### **Table 50001: Rental Unit**
```al
table 50001 "Rental Unit"
{
    Caption = 'Rental Unit';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
        }
        field(11; Floor; Integer)
        {
            Caption = 'Floor';
        }
        field(20; "Unit Type"; Enum "Rental Unit Type")
        {
            Caption = 'Unit Type';
        }
        field(30; "Square Feet"; Decimal)
        {
            Caption = 'Square Feet';
        }
        field(40; "Monthly Base Rent"; Decimal)
        {
            Caption = 'Monthly Base Rent';
        }
        field(50; "Tenant No."; Code[20])
        {
            Caption = 'Tenant No.';
        }
        field(60; "Lease Start Date"; Date)
        {
            Caption = 'Lease Start Date';
        }
        field(70; "Lease End Date"; Date)
        {
            Caption = 'Lease End Date';
        }
        // Additional fields to test SetLoadFields impact
        field(80; "Property Manager"; Code[20])
        {
            Caption = 'Property Manager';
        }
        field(90; "Parking Spaces"; Integer)
        {
            Caption = 'Parking Spaces';
        }
        field(100; "HVAC Zone"; Code[10])
        {
            Caption = 'HVAC Zone';
        }
        field(110; "Security Deposit"; Decimal)
        {
            Caption = 'Security Deposit';
        }
        field(120; "Utilities Included"; Boolean)
        {
            Caption = 'Utilities Included';
        }
    }

    keys
    {
        key(PK; "Unit No.")
        {
            Clustered = true;
        }
        key(Building; "Building Code") { }
    }
}
```

### **Table 50002: Monthly Rental Ledger**
```al
table 50002 "Monthly Rental Ledger"
{
    Caption = 'Monthly Rental Ledger';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Rental Unit";
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(30; "Invoice Month"; Date)
        {
            Caption = 'Invoice Month';
        }
        field(40; "Base Rent Amount"; Decimal)
        {
            Caption = 'Base Rent Amount';
        }
        field(50; "Utility Charges"; Decimal)
        {
            Caption = 'Utility Charges';
        }
        field(60; "Maintenance Fees"; Decimal)
        {
            Caption = 'Maintenance Fees';
        }
        field(70; "Parking Fees"; Decimal)
        {
            Caption = 'Parking Fees';
        }
        field(80; "Late Fees"; Decimal)
        {
            Caption = 'Late Fees';
        }
        field(90; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(100; "Tenant No."; Code[20])
        {
            Caption = 'Tenant No.';
        }
        field(110; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
        }
        field(120; "Unit Type"; Enum "Rental Unit Type")
        {
            Caption = 'Unit Type';
        }
        // Quality metrics for complex SIFT testing
        field(130; "Square Feet"; Decimal)
        {
            Caption = 'Square Feet';
        }
        field(140; "Occupancy Days"; Integer)
        {
            Caption = 'Occupancy Days';
        }
        field(150; "Maintenance Hours"; Decimal)
        {
            Caption = 'Maintenance Hours';
        }
        field(160; "Energy Usage KWH"; Decimal)
        {
            Caption = 'Energy Usage KWH';
        }
        field(170; "Water Usage Gallons"; Decimal)
        {
            Caption = 'Water Usage Gallons';
        }
        // Feature flags for advanced filtering
        field(180; "Payment Status"; Enum "Payment Status")
        {
            Caption = 'Payment Status';
        }
        field(190; "Invoice Generated"; Boolean)
        {
            Caption = 'Invoice Generated';
        }
        field(200; "Property Manager"; Code[20])
        {
            Caption = 'Property Manager';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Unit; "Unit No.") { }
        key(InvoiceMonth; "Invoice Month") { }
    }
}
```

### **Table 50003: Rental Unit Performance Stats**
```al
table 50003 "Rental Unit Performance Stats"
{
    Caption = 'Rental Unit Performance Stats';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Rental Unit";
            NotBlank = true;
        }
        
        // FlowField scenarios for testing - Revenue metrics
        field(10; "Total Revenue"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Revenue';
            CalcFormula = Sum("Monthly Rental Ledger"."Total Amount" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(11; "Total Base Rent"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Base Rent';
            CalcFormula = Sum("Monthly Rental Ledger"."Base Rent Amount" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(12; "Total Utility Charges"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Utility Charges';
            CalcFormula = Sum("Monthly Rental Ledger"."Utility Charges" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(13; "Average Monthly Rent"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Average Monthly Rent';
            CalcFormula = Average("Monthly Rental Ledger"."Total Amount" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        
        // Performance and usage metrics
        field(20; "Total Occupancy Days"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Total Occupancy Days';
            CalcFormula = Sum("Monthly Rental Ledger"."Occupancy Days" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(21; "Total Maintenance Hours"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Maintenance Hours';
            CalcFormula = Sum("Monthly Rental Ledger"."Maintenance Hours" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(22; "Total Energy Usage"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Energy Usage';
            CalcFormula = Sum("Monthly Rental Ledger"."Energy Usage KWH" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        field(23; "Total Water Usage"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Water Usage';
            CalcFormula = Sum("Monthly Rental Ledger"."Water Usage Gallons" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        
        // Filtered FlowFields for date range testing
        field(30; "Current Year Revenue"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Current Year Revenue';
            CalcFormula = Sum("Monthly Rental Ledger"."Total Amount" WHERE(
                "Unit No." = FIELD("Unit No."),
                "Invoice Month" = FIELD("Date Filter")));
            Editable = false;
        }
        field(31; "Invoice Count"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Invoice Count';
            CalcFormula = Count("Monthly Rental Ledger" WHERE("Unit No." = FIELD("Unit No.")));
            Editable = false;
        }
        
        // FlowFilters
        field(100; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(101; "Building Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Building Filter';
        }
        field(102; "Manager Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Manager Filter';
        }
    }

    keys
    {
        key(PK; "Unit No.")
        {
            Clustered = true;
        }
    }
}
```

### **Enum 50010: Rental Unit Type**
```al
enum 50010 "Rental Unit Type"
{
    Extensible = true;

    value(0; Office)
    {
        Caption = 'Office';
    }
    value(1; Retail)
    {
        Caption = 'Retail';
    }
    value(2; Warehouse)
    {
        Caption = 'Warehouse';
    }
    value(3; Conference)
    {
        Caption = 'Conference Room';
    }
    value(4; Coworking)
    {
        Caption = 'Co-working Space';
    }
}
```

### **Enum 50011: Payment Status**
```al
enum 50011 "Payment Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Paid)
    {
        Caption = 'Paid';
    }
    value(2; Overdue)
    {
        Caption = 'Overdue';
    }
    value(3; PartialPaid)
    {
        Caption = 'Partial Payment';
    }
}
```

---

---

## 🚫 **Tier-Specific Inefficient Code Patterns**

These are the **intentionally poor** patterns that each tier implements with tier-specific prefixes, designed to trigger optimization suggestions:

### **Core Testing Codeunits (Per Tier)**

#### **Codeunit 50T01: "TX Rental Analytics"** (Primary Optimization Target)
*Where T = tier number (0,1,2,3,4) and X = tier ID range (1,2,3,4,5)*

#### **Job 1: Property Portfolio Summary**
```al
procedure GeneratePortfolioSummary(): Decimal
var
    RentalUnit: Record "Rental Unit";
    UnitStats: Record "Rental Unit Performance Stats";
    TotalRevenue: Decimal;
    UnitCount: Integer;
    TotalSquareFeet: Decimal;
begin
    if RentalUnit.FindSet() then
        repeat
            UnitStats.Get(RentalUnit."Unit No.");
            UnitStats.CalcFields("Total Revenue");
            UnitStats.CalcFields("Invoice Count");
            TotalRevenue += UnitStats."Total Revenue";
            
            // Accumulate additional portfolio metrics for realistic processing
            UnitCount += 1;
            TotalSquareFeet += RentalUnit."Square Feet";
        until RentalUnit.Next() = 0;
        
    exit(TotalRevenue);
end;
```

#### **Job 2: Unit Revenue Calculation**
```al
procedure CalculateUnitRevenue(UnitNo: Code[20]): Decimal
var
    RentalLedger: Record "Monthly Rental Ledger";
    TotalRevenue: Decimal;
begin
    RentalLedger.SetRange("Unit No.", UnitNo);
    if RentalLedger.FindSet() then
        repeat
            TotalRevenue += RentalLedger."Total Amount";
        until RentalLedger.Next() = 0;
    exit(TotalRevenue);
end;
```

#### **Job 3: Monthly Ledger Export**
```al
procedure ExportMonthlyLedgerData(): Integer
var
    RentalLedger: Record "Monthly Rental Ledger";
    TextLine: Text;
    ExportCount: Integer;
    TotalExportSize: Integer;
begin
    if RentalLedger.FindSet() then
        repeat
            TextLine := Format(RentalLedger."Entry No.") + ',' + RentalLedger."Unit No." + ',' + 
                Format(RentalLedger."Total Amount") + ',' + Format(RentalLedger."Base Rent Amount") + ',' + 
                Format(RentalLedger."Invoice Month") + ',' + Format(RentalLedger."Utility Charges") + ',' + 
                Format(RentalLedger."Maintenance Fees") + ',' + RentalLedger."Building Code" + ',' + 
                Format(RentalLedger."Square Feet") + ',' + Format(RentalLedger."Energy Usage KWH") + ',' + 
                RentalLedger."Property Manager" + ',' + Format(RentalLedger."Water Usage Gallons");
            
            // Simulate export processing by calculating total size
            TotalExportSize += StrLen(TextLine);
            ExportCount += 1;
        until RentalLedger.Next() = 0;
        
    exit(ExportCount);
end;
```

#### **Job 4: Quarterly Revenue Report**
```al
procedure GenerateQuarterlyReport(StartDate: Date; EndDate: Date): Decimal
var
    RentalLedger: Record "Monthly Rental Ledger";
    QuarterlyTotal: Decimal;
    UtilityTotal: Decimal;
    RecordCount: Integer;
begin
    RentalLedger.SetRange("Invoice Month", StartDate, EndDate);
    if RentalLedger.FindSet() then
        repeat
            QuarterlyTotal += RentalLedger."Total Amount";
            UtilityTotal += RentalLedger."Utility Charges";
            RecordCount += 1;
        until RentalLedger.Next() = 0;
        
    exit(QuarterlyTotal);
end;
```

#### **Job 5: Building Performance Analysis**
```al
procedure AnalyzeBuildingPerformance(): Integer
var
    RentalUnit: Record "Rental Unit";
    RentalLedger: Record "Monthly Rental Ledger";
    BuildingRevenue: Decimal;
    UnitCount: Integer;
    CurrentBuilding: Code[20];
    UnitTotal: Decimal;
    TotalBuildingsProcessed: Integer;
begin
    if RentalUnit.FindSet() then
        repeat
            if CurrentBuilding <> RentalUnit."Building Code" then begin
                if CurrentBuilding <> '' then
                    TotalBuildingsProcessed += 1;
                        
                CurrentBuilding := RentalUnit."Building Code";
                BuildingRevenue := 0;
                UnitCount := 0;
            end;
            
            UnitCount += 1;
            UnitTotal := 0;
            
            RentalLedger.SetRange("Unit No.", RentalUnit."Unit No.");
            if RentalLedger.FindSet() then
                repeat
                    UnitTotal += RentalLedger."Total Amount";
                    UnitTotal += RentalLedger."Utility Charges";
                until RentalLedger.Next() = 0;
                
            BuildingRevenue += UnitTotal;
        until RentalUnit.Next() = 0;
        
    if CurrentBuilding <> '' then
        TotalBuildingsProcessed += 1;
        
    exit(TotalBuildingsProcessed);
end;
```

#### **Job 6: Property KPI Dashboard**
```al
procedure GeneratePropertyKPIs(BuildingCode: Code[20]): Decimal
var
    RentalLedger: Record "Monthly Rental Ledger";
    TotalRevenue: Decimal;
    TotalSquareFeet: Decimal;
    TotalEnergyUsage: Decimal;
    TotalMaintenanceHours: Decimal;
    InvoiceCount: Integer;
    RevenuePerSqFt: Decimal;
    EnergyEfficiency: Decimal;
    AvgMaintenancePerUnit: Decimal;
begin
    RentalLedger.SetRange("Building Code", BuildingCode);
    if RentalLedger.FindSet() then
        repeat
            TotalRevenue += RentalLedger."Total Amount";
            TotalRevenue += RentalLedger."Utility Charges"; 
            TotalRevenue += RentalLedger."Maintenance Fees";
            TotalSquareFeet += RentalLedger."Square Feet";
            TotalEnergyUsage += RentalLedger."Energy Usage KWH";
            TotalMaintenanceHours += RentalLedger."Maintenance Hours";
            InvoiceCount += 1;
        until RentalLedger.Next() = 0;
        
    if TotalSquareFeet <> 0 then begin
        RevenuePerSqFt := TotalRevenue / TotalSquareFeet;
        EnergyEfficiency := TotalSquareFeet / TotalEnergyUsage;
    end;
    
    if InvoiceCount <> 0 then
        AvgMaintenancePerUnit := TotalMaintenanceHours / InvoiceCount;
        
    exit(RevenuePerSqFt);
end;
```

---

## 🎲 **Data Generation Framework**

### **Codeunit 50020: Test Data Generator**

#### **Core Data Generation Procedures**
```al
codeunit 50020 "Test Data Generator"
{
    procedure GenerateAllTestData(): Boolean
    begin
        GenerateRentalUnits();
        GenerateMonthlyLedgerEntries();
        GeneratePerformanceStats();
        exit(true); // Returns success status
    end;
    
    procedure GenerateRentalUnits()
    var
        RentalUnit: Record "Rental Unit";
        BuildingCode: Code[20];
        UnitCount: Integer;
        BuildingCount: Integer;
    begin
        RentalUnit.DeleteAll();
        
        for BuildingCount := 1 to 50 do begin
            BuildingCode := 'BLDG-' + Format(BuildingCount);
            
            for UnitCount := 1 to 100 do begin
                RentalUnit.Init();
                RentalUnit."Unit No." := BuildingCode + '-' + Format(UnitCount, 0, '<Integer,3><Filler Character,0>');
                RentalUnit.Description := GenerateUnitDescription(RentalUnit."Unit Type");
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
    
    procedure GenerateMonthlyLedgerEntries()
    var
        RentalUnit: Record "Rental Unit";
        RentalLedger: Record "Monthly Rental Ledger";
        InvoiceDate: Date;
        EntryNo: Integer;
    begin
        RentalLedger.DeleteAll();
        EntryNo := 1;
        
        if RentalUnit.FindSet() then
            repeat
                InvoiceDate := 20190101D; // Start from January 2019
                
                while InvoiceDate <= 20231201D do begin // Through December 2023
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
                    InvoiceDate := CalcDate('<+1M>', InvoiceDate);
                end;
            until RentalUnit.Next() = 0;
    end;
    
    procedure GeneratePerformanceStats()
    var
        RentalUnit: Record "Rental Unit";
        PerformanceStats: Record "Rental Unit Performance Stats";
    begin
        PerformanceStats.DeleteAll();
        
        if RentalUnit.FindSet() then
            repeat
                PerformanceStats.Init();
                PerformanceStats."Unit No." := RentalUnit."Unit No.";
                PerformanceStats.Insert();
            until RentalUnit.Next() = 0;
    end;
}
```

#### **Supporting Data Generation Functions**
```al
local procedure GenerateRandomUnitType(): Enum "Rental Unit Type"
var
    RandomValue: Integer;
begin
    RandomValue := Random(100);
    case true of
        RandomValue <= 60: exit("Rental Unit Type"::Office);        // 60% Office
        RandomValue <= 80: exit("Rental Unit Type"::Retail);        // 20% Retail  
        RandomValue <= 90: exit("Rental Unit Type"::Warehouse);     // 10% Warehouse
        RandomValue <= 95: exit("Rental Unit Type"::Conference);    // 5% Conference
        else exit("Rental Unit Type"::Coworking);                   // 5% Co-working
    end;
end;

local procedure GenerateSquareFeet(UnitType: Enum "Rental Unit Type"): Decimal
begin
    case UnitType of
        "Rental Unit Type"::Office: exit(Random(2000) + 500);        // 500-2500 sq ft
        "Rental Unit Type"::Retail: exit(Random(4000) + 1000);       // 1000-5000 sq ft  
        "Rental Unit Type"::Warehouse: exit(Random(8000) + 2000);    // 2000-10000 sq ft
        "Rental Unit Type"::Conference: exit(Random(500) + 200);     // 200-700 sq ft
        "Rental Unit Type"::Coworking: exit(Random(1500) + 800);     // 800-2300 sq ft
    end;
end;

local procedure CalculateBaseRent(UnitType: Enum "Rental Unit Type"; SquareFeet: Decimal): Decimal
var
    RentPerSqFt: Decimal;
begin
    case UnitType of
        "Rental Unit Type"::Office: RentPerSqFt := 2.5 + (Random(200) / 100);      // $2.50-$4.50 per sq ft
        "Rental Unit Type"::Retail: RentPerSqFt := 3.0 + (Random(300) / 100);      // $3.00-$6.00 per sq ft
        "Rental Unit Type"::Warehouse: RentPerSqFt := 1.0 + (Random(150) / 100);   // $1.00-$2.50 per sq ft
        "Rental Unit Type"::Conference: RentPerSqFt := 4.0 + (Random(400) / 100);  // $4.00-$8.00 per sq ft
        "Rental Unit Type"::Coworking: RentPerSqFt := 2.0 + (Random(250) / 100);   // $2.00-$4.50 per sq ft
    end;
    exit(Round(SquareFeet * RentPerSqFt, 0.01));
end;

local procedure GenerateBaseRentAmount(BaseRent: Decimal; InvoiceDate: Date): Decimal
var
    SeasonalVariation: Decimal;
    RandomVariation: Decimal;
begin
    // Add 5-15% seasonal variation (higher in Q4, lower in Q2)
    case Date2DMY(InvoiceDate, 2) of
        1,2,3: SeasonalVariation := 0.95 + (Random(10) / 100);      // Q1: 95-105%
        4,5,6: SeasonalVariation := 0.90 + (Random(15) / 100);      // Q2: 90-105%  
        7,8,9: SeasonalVariation := 0.95 + (Random(10) / 100);      // Q3: 95-105%
        10,11,12: SeasonalVariation := 1.00 + (Random(15) / 100);   // Q4: 100-115%
    end;
    
    // Add small random month-to-month variation
    RandomVariation := 0.98 + (Random(4) / 100);  // 98-102%
    
    exit(Round(BaseRent * SeasonalVariation * RandomVariation, 0.01));
end;

local procedure GenerateUtilityCharges(SquareFeet: Decimal; InvoiceDate: Date): Decimal
var
    BaseUtilityCost: Decimal;
    SeasonalMultiplier: Decimal;
begin
    BaseUtilityCost := SquareFeet * 0.15;  // $0.15 per sq ft base
    
    // Higher utilities in summer (AC) and winter (heating)
    case Date2DMY(InvoiceDate, 2) of
        12,1,2: SeasonalMultiplier := 1.3 + (Random(20) / 100);     // Winter: 130-150%
        3,4,5: SeasonalMultiplier := 0.8 + (Random(20) / 100);      // Spring: 80-100%
        6,7,8: SeasonalMultiplier := 1.4 + (Random(30) / 100);      // Summer: 140-170%
        9,10,11: SeasonalMultiplier := 0.9 + (Random(20) / 100);    // Fall: 90-110%
    end;
    
    exit(Round(BaseUtilityCost * SeasonalMultiplier, 0.01));
end;

local procedure GenerateEnergyUsage(SquareFeet: Decimal; InvoiceDate: Date): Decimal
var
    BaseUsage: Decimal;
    SeasonalMultiplier: Decimal;
begin
    BaseUsage := SquareFeet * 8;  // 8 KWH per sq ft per month base
    
    case Date2DMY(InvoiceDate, 2) of
        12,1,2: SeasonalMultiplier := 1.2 + (Random(15) / 100);
        3,4,5: SeasonalMultiplier := 0.8 + (Random(15) / 100);
        6,7,8: SeasonalMultiplier := 1.5 + (Random(25) / 100);
        9,10,11: SeasonalMultiplier := 0.9 + (Random(15) / 100);
    end;
    
    exit(Round(BaseUsage * SeasonalMultiplier, 0.1));
end;

local procedure GeneratePropertyManager(BuildingNumber: Integer): Code[20]
begin
    // 10 buildings per property manager (5 managers total)
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
        RandomValue <= 85: exit("Payment Status"::Paid);           // 85% Paid
        RandomValue <= 90: exit("Payment Status"::Pending);        // 5% Pending
        RandomValue <= 97: exit("Payment Status"::Overdue);        // 7% Overdue
        else exit("Payment Status"::PartialPaid);                  // 3% Partial
    end;
end;
```

#### **Data Generation Parameters**
- **Rental Units**: 5,000 units (100 units × 50 buildings)
- **Property Managers**: 5 managers (10 buildings each)
- **Date Range**: January 2019 - December 2023 (60 months)
- **Monthly Ledger Entries**: 3,000,000+ records (5,000 units × 60 months)
- **Revenue Variation**: Seasonal patterns, random fluctuations, unit type differences
- **Usage Metrics**: Realistic energy/water consumption based on size and season

---

## 📊 **Performance Test Scenarios**

### **Scenario 1: Portfolio Summary Dashboard**
- **Challenge**: Executive wants overview of entire property portfolio performance
- **Business Context**: Monthly board meeting requiring portfolio-wide revenue summary
- **Input Code**: `GeneratePortfolioSummary`
- **Performance Impact**: Processes 5,000 units with individual FlowField calculations

### **Scenario 2: Unit Revenue Analysis**
- **Challenge**: Property manager needs total revenue for specific rental unit
- **Business Context**: Tenant lease renewal negotiation requiring historical revenue data
- **Input Code**: `CalculateUnitRevenue`
- **Performance Impact**: Manual summation across 60 monthly ledger entries per unit

### **Scenario 3: Financial Export Requirements**
- **Challenge**: Accounting team needs monthly ledger export for external reporting
- **Business Context**: Year-end audit requiring detailed transaction export
- **Input Code**: `ExportMonthlyLedgerData`
- **Performance Impact**: Processes 3M+ records accessing all fields for CSV export

### **Scenario 4: Quarterly Performance Reporting**
- **Challenge**: Investors require quarterly revenue analysis with date filtering
- **Business Context**: Quarterly earnings call requiring filtered revenue totals
- **Input Code**: `GenerateQuarterlyReport`
- **Performance Impact**: Date range filtering on 750,000+ quarterly records

### **Scenario 5: Building Comparison Analysis**
- **Challenge**: Regional manager comparing performance across buildings
- **Business Context**: Budget planning requiring building-by-building revenue analysis
- **Input Code**: `AnalyzeBuildingPerformance`
- **Performance Impact**: Nested loops processing units and their historical ledger entries

### **Scenario 6: Property KPI Calculation**
- **Challenge**: Operations team calculating building efficiency metrics
- **Business Context**: Performance optimization requiring multiple aggregated KPIs
- **Input Code**: `GeneratePropertyKPIs`
- **Performance Impact**: Multiple manual aggregations across all building transactions

---

## 🎯 **Success Criteria for Each Tier**

### **Tier 1 (Baseline) - Expected Suggestions**
- Generic programming advice (use indexes, avoid nested loops)
- Basic database optimization concepts
- No BC-specific knowledge

### **Tier 2 (Community) - Expected Improvements**
- Some BC awareness (FindSet, SetRange patterns)
- Basic understanding of BC record operations
- Limited knowledge of BC-specific optimizations

### **Tier 3 (Atomic) - Expected Excellence**
- **SetLoadFields Usage**: Suggests SetLoadFields in 90%+ of beneficial scenarios
- **SIFT Optimization**: Recommends SIFT over manual calculation in 95%+ of cases
- **FlowField Patterns**: Identifies FlowField opportunities in 85%+ of aggregation scenarios
- **Key Selection**: Suggests optimal keys for filtering/sorting in 80%+ of cases

### **Tier 4 (MCP-Enhanced) - Expected Intelligence**
- **Real-Time Analysis**: Contextual optimization suggestions within 2-3 seconds
- **Topic Relevance**: Suggests correct atomic topics for code context in 95%+ of cases
- **Cross-Domain Connections**: Finds related validation/architecture topics in 85%+ of scenarios
- **Progressive Guidance**: Provides step-by-step optimization workflows

---

## 🔧 **Implementation Notes**

### **ID Range Allocation**

#### **Common Extension (50000-50099)**
- **50001-50003**: Data storage tables (Rental Unit, Monthly Rental Ledger, Performance Stats)
- **50010-50015**: Shared enums (Unit Type, Payment Status, etc.)
- **50020-50025**: Infrastructure codeunits (Test Data Generator, Setup, etc.)
- **50030-50040**: Master data pages (for data verification and management)

#### **Tier Extensions**
- **Tier 0**: 50100-50199 → T0 prefixed objects
- **Tier 1**: 50200-50299 → T1 prefixed objects
- **Tier 2**: 50300-50399 → T2 prefixed objects  
- **Tier 3**: 50400-50499 → T3 prefixed objects
- **Tier 4**: 50500-50599 → T4 prefixed objects

### **Tier Object Structure (Per Tier)**
Each tier contains tier-prefixed objects for isolated optimization testing:

#### **Core Testing Codeunits**
- **50T01**: "TX Rental Analytics" (6 inefficient procedures - primary optimization target)
- **50T02**: "TX Lease Management" (3-4 inefficient procedures)  
- **50T03**: "TX Property Operations" (2-3 inefficient procedures)
- **50T04**: "TX Financial Processing" (4-5 inefficient procedures)
- **50T05**: "TX Portfolio Analytics" (3-4 inefficient procedures)

#### **Camouflage Objects (Good Code)**
- **50T06-50T10**: Properly optimized codeunits (Integration, Setup, Import/Export)
- **50T11-50T30**: Camouflage tables (Property, Tenant, Work Orders, etc.)
- **50T31-50T50**: UI objects (Pages, Reports)
- **50T51-60**: Supporting objects (Enums, Page Extensions)

*Where T = tier number (1,2,3,4,5) for ID ranges*

### **Data Population Strategy**
- **Rental Units**: 5,000 units across 50 buildings (100 units per building average)
- **Monthly Rental Ledger**: 3,000,000+ records (5 years × 12 months × 5,000 units)
- **Property Mix**: 60% Office, 20% Retail, 10% Warehouse, 5% Conference, 5% Co-working
- **Realistic date ranges**: January 2019 - December 2023 (5 years of monthly data)
- **Revenue variation**: $500-$10,000 monthly rent per unit based on type and size
- **Utility metrics**: Realistic energy/water usage based on square footage and unit type
- **Building distribution**: 10 buildings per property manager for management hierarchy testing

### **Measurement Infrastructure**
- Use Performance Toolkit for accurate timing
- Measure: execution time, memory usage, database calls
- Log results for cross-tier comparison
- SQL Server query analysis for key usage validation

---

---

## 🌲 **Camouflage Object Forest - Full BC Extension Structure**

**Purpose**: Create realistic enterprise-grade BC extension complexity to prevent Copilot from easily spotting the 15-20 inefficient procedures buried within authentic business logic.

### **Master Data Tables**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X04 | Table | Property | Real estate properties (buildings, land, facilities) |
| 50X05 | Table | Tenant | Rental tenants and lessees with contact information |
| 50X06 | Table | Vendor - Property Services | Property maintenance and service vendors |
| 50X07 | Table | Unit Features | Unit amenities and features (parking, storage, etc.) |
| 50X08 | Table | Property Manager | Property management staff and assignments |
| 50X09 | Table | Lease Template | Standard lease agreement templates and terms |
| 50X10 | Table | Utility Provider | Electric, gas, water, internet service providers |

### **Transaction Data Tables**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X11 | Table | Lease Agreement | Active and historical lease contracts |
| 50X12 | Table | Work Order | Maintenance and repair requests |
| 50X13 | Table | Property Expense | Operating expenses by property and category |
| 50X14 | Table | Utility Reading | Monthly utility meter readings and consumption |
| 50X15 | Table | Property Inspection | Scheduled and ad-hoc property condition assessments |
| 50X16 | Table | Rent Roll History | Historical rent amounts and adjustments |

### **Setup and Configuration Tables**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X17 | Table | Property Management Setup | Global configuration and default values |
| 50X18 | Table | Expense Category | Classification for operating expenses and maintenance |
| 50X19 | Table | Property Type Category | Property classification (commercial, residential, mixed-use) |
| 50X20 | Table | Unit Type Features | Standard features by unit type |

### **Business Logic Codeunits**

| ID | Type | Name | Purpose | Performance Notes |
|---|---|---|---|---|
| 50X03 | Codeunit | Lease Management | Lease creation, renewals, terminations | **Contains 3-4 inefficient procedures** |
| 50X04 | Codeunit | Property Operations | Maintenance, inspections, work orders | **Contains 2-3 inefficient procedures** |  
| 50X05 | Codeunit | Financial Processing | Rent calculations, expense allocation, reporting | **Contains 4-5 inefficient procedures** |
| 50X06 | Codeunit | Utility Management | Meter readings, usage calculations, billing | **Contains 2-3 inefficient procedures** |
| 50X07 | Codeunit | Portfolio Analytics | Performance metrics, occupancy analysis | **Contains 3-4 inefficient procedures** |
| 50X08 | Codeunit | Integration Management | External system interfaces and data exchange | **Properly optimized - camouflage** |
| 50X09 | Codeunit | Setup and Configuration | System setup, validation, defaults | **Properly optimized - camouflage** |
| 50X10 | Codeunit | Data Import/Export | File processing, data migration | **Mixed quality - some good, some poor** |

### **User Interface Objects**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X01 | Page | Property Card | Property master data entry and maintenance |
| 50X02 | Page | Property List | Browse and search properties |
| 50X03 | Page | Tenant Card | Tenant information and lease history |
| 50X04 | Page | Tenant List | Browse and search tenants |
| 50X05 | Page | Lease Agreement Card | Lease contract details and terms |
| 50X06 | Page | Lease Agreement List | Active and historical leases |
| 50X07 | Page | Work Order Card | Maintenance request details and status |
| 50X08 | Page | Work Order List | Maintenance queue and history |
| 50X09 | Page | Property Performance Dashboard | KPI dashboard and analytics |
| 50X10 | Page | Monthly Rent Roll | Current rent roll and collection status |
| 50X11 | Page | Property Management Setup | System configuration and setup |

### **Reporting Objects**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X01 | Report | Property Portfolio Summary | Executive portfolio overview report |
| 50X02 | Report | Rent Roll Report | Detailed rent roll with tenant information |
| 50X03 | Report | Maintenance Cost Analysis | Maintenance expense analysis by property |
| 50X04 | Report | Occupancy Analysis | Vacancy and occupancy trending report |
| 50X05 | Report | Utility Usage Report | Energy and utility consumption analysis |
| 50X06 | Report | Lease Expiration Report | Upcoming lease renewals and expirations |

### **Supporting Enums**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X03 | Enum | Property Status | Active, Vacant, Under Maintenance, Sold |
| 50X04 | Enum | Lease Status | Draft, Active, Expired, Terminated, Renewed |
| 50X05 | Enum | Work Order Status | Open, Assigned, In Progress, Completed, Cancelled |
| 50X06 | Enum | Expense Category | Maintenance, Utilities, Insurance, Taxes, Management |
| 50X07 | Enum | Unit Condition | Excellent, Good, Fair, Poor, Requires Renovation |

### **Page Extensions (BC Integration)**

| ID | Type | Name | Purpose |
|---|---|---|---|
| 50X01 | PageExt | Customer Card Extension | Add property tenant fields to Customer |
| 50X02 | PageExt | Vendor Card Extension | Add property service provider fields |
| 50X03 | PageExt | G/L Account Extension | Add property accounting classifications |

### **Camouflage Strategy**

#### **Realistic Complexity Distribution**
- **~45 total objects** creating authentic BC extension scope
- **15-20 inefficient procedures** buried across 5 primary codeunits  
- **25-30 properly optimized objects** providing realistic "good code" context
- **Mixed quality patterns** forcing Copilot to discriminate good vs poor code

#### **Business Logic Authenticity**  
- **Complete property management lifecycle** from acquisition to disposal
- **Integrated workflows** spanning leasing, maintenance, financials, reporting
- **Proper BC patterns** in camouflage objects (FlowFields, proper keys, SetLoadFields)
- **Enterprise-grade scope** matching real BC extension complexity

#### **Performance Testing Benefits**
- **Context overload** - Copilot must navigate substantial codebase
- **Pattern discrimination** - Must identify inefficient code among proper implementations  
- **Knowledge differentiation** - Tier 3 atomic knowledge should excel in complex scenarios
- **Real-world validity** - Results transfer to actual BC development environments

---

## 📋 **Next Steps**

1. **Implement Core Testing Objects**: Create the essential tables, inefficient codeunits, and data generator across all 5 tiers
2. **Build Camouflage Forest**: Implement the additional 35+ objects to create realistic BC extension complexity
3. **Data Population**: Generate realistic datasets across all master and transaction tables
4. **Performance Baseline**: Establish measurements across all inefficient procedures
5. **Knowledge Preparation**: Populate tier-specific .copilot folders with appropriate knowledge contexts
6. **Validation Execution**: Run Five-Tier Copilot Testing Protocol with realistic enterprise complexity

---

**Ready for Implementation**: Complete object inventory defined for authentic enterprise BC extension testing environment.