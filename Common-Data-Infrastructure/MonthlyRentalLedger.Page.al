page 50011 "Monthly Rental Ledger"
{
    ApplicationArea = All;
    Caption = 'Monthly Rental Ledger';
    PageType = List;
    SourceTable = "Monthly Rental Ledger";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ToolTip = 'Specifies the value of the Payment Status field.', Comment = '%';
                }
                field("Building Code"; Rec."Building Code")
                {
                    ToolTip = 'Specifies the value of the Building Code field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice Month"; Rec."Invoice Month")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}