page 50050 "Knowledge Tester Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Knowledge Tester Setup";
    Caption = 'Knowledge Tester Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    
    layout
    {
        area(Content)
        {
            group("Test Data Overview")
            {
                Caption = 'Test Data Overview';
                
                field("Rental Units Count"; Rec."Rental Units Count")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Rental Units");
                    end;
                }
                field("Ledger Entries Count"; Rec."Ledger Entries Count")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Monthly Rental Ledger");
                    end;
                }
                field("Performance Stats Count"; Rec."Performance Stats Count")
                {
                    ApplicationArea = All;
                }
                field("Last Data Generation"; Rec."Last Data Generation")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action("Generate Test Data")
            {
                ApplicationArea = All;
                Caption = 'Generate Test Data';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                
                trigger OnAction()
                var
                    TestDataGenerator: Codeunit "Test Data Generator";
                begin
                    if TestDataGenerator.GenerateAllTestData() then begin
                        Rec."Last Data Generation" := CurrentDateTime;
                        Rec.Modify();
                        CurrPage.Update();
                        Message('Test data generation completed successfully.');
                    end else
                        Message('Test data generation failed.');
                end;
            }
            action("Clear All Data")
            {
                ApplicationArea = All;
                Caption = 'Clear All Data';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                
                trigger OnAction()
                var
                    RentalUnit: Record "Rental Unit";
                    MonthlyRentalLedger: Record "Monthly Rental Ledger";
                    PerformanceStats: Record "Rental Unit Performance Stats";
                begin
                    if Confirm('Are you sure you want to delete all test data?') then begin
                        RentalUnit.DeleteAll();
                        MonthlyRentalLedger.DeleteAll();
                        PerformanceStats.DeleteAll();
                        Rec."Last Data Generation" := 0DT;
                        Rec.Modify();
                        CurrPage.Update();
                        Message('All test data has been cleared.');
                    end;
                end;
            }
        }
    }
    
    trigger OnOpenPage()
    var
        Setup: Record "Knowledge Tester Setup";
    begin
        Rec := Setup.GetInstance();
        if not Rec.Find() then
            CurrPage.Update();
    end;
}