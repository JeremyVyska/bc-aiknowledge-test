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