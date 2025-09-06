page 50010 "Rental Units"
{
    ApplicationArea = All;
    Caption = 'Rental Units';
    PageType = List;
    SourceTable = "Rental Unit";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Lease Start Date"; Rec."Lease Start Date")
                {
                    ToolTip = 'Specifies the value of the Lease Start Date field.', Comment = '%';
                }
                field("Lease End Date"; Rec."Lease End Date")
                {
                    ToolTip = 'Specifies the value of the Lease End Date field.', Comment = '%';
                }
                field("Monthly Base Rent"; Rec."Monthly Base Rent")
                {
                    ToolTip = 'Specifies the value of the Monthly Base Rent field.', Comment = '%';
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ToolTip = 'Specifies the value of the Unit Type field.', Comment = '%';
                }
                field("Utilities Included"; Rec."Utilities Included")
                {
                    ToolTip = 'Specifies the value of the Utilities Included field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field("Building Code"; Rec."Building Code")
                {
                    ApplicationArea = All;
                }
                field("Square Feet"; Rec."Square Feet")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}