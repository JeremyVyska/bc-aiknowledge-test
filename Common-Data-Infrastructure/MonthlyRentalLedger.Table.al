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