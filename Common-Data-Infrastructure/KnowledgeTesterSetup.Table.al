table 50050 "Knowledge Tester Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Knowledge Tester Setup';
    
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Rental Units Count"; Integer)
        {
            Caption = 'Rental Units Count';
            FieldClass = FlowField;
            CalcFormula = count("Rental Unit");
            Editable = false;
        }
        field(11; "Ledger Entries Count"; Integer)
        {
            Caption = 'Ledger Entries Count';
            FieldClass = FlowField;
            CalcFormula = count("Monthly Rental Ledger");
            Editable = false;
        }
        field(12; "Performance Stats Count"; Integer)
        {
            Caption = 'Performance Stats Count';
            FieldClass = FlowField;
            CalcFormula = count("Rental Unit Performance Stats");
            Editable = false;
        }
        field(20; "Last Data Generation"; DateTime)
        {
            Caption = 'Last Data Generation';
        }
    }
    
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    
    procedure GetInstance(): Record "Knowledge Tester Setup"
    var
        Setup: Record "Knowledge Tester Setup";
    begin
        if not Setup.Get('') then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup.Insert();
        end;
        exit(Setup);
    end;
}