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