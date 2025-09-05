codeunit {{BASE_ID}}21 "{{TIER_PREFIX}} System Validation"
{
    // Data validation and system health monitoring

    procedure ValidateUnitConfiguration(): Boolean
    var
        RentalUnit: Record "Rental Unit";
        ValidationErrors: Integer;
    begin
        RentalUnit.SetLoadFields("Unit No.", "Square Feet", "Monthly Base Rent");
        if RentalUnit.FindSet() then
            repeat
                if RentalUnit."Square Feet" <= 0 then
                    ValidationErrors += 1;
                if RentalUnit."Monthly Base Rent" <= 0 then
                    ValidationErrors += 1;
            until RentalUnit.Next() = 0;
        exit(ValidationErrors = 0);
    end;

    procedure CheckSystemHealthMetrics(): Integer
    var
        RentalLedger: Record "Monthly Rental Ledger";
        HealthScore: Integer;
    begin
        RentalLedger.SetLoadFields("Entry No.");
        if RentalLedger.FindLast() then
            HealthScore := RentalLedger."Entry No."
        else
            HealthScore := 0;
        exit(HealthScore);
    end;

    procedure PerformBusinessRuleValidation(): Text
    var
        RentalUnit: Record "Rental Unit";
        ValidationResults: Text;
        RuleViolations: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                case RentalUnit."Unit Type" of
                    RentalUnit."Unit Type"::Office:
                        if RentalUnit."Square Feet" > 3000 then
                            RuleViolations += 1;
                    RentalUnit."Unit Type"::Retail:
                        if RentalUnit."Parking Spaces" < 2 then
                            RuleViolations += 1;
                    RentalUnit."Unit Type"::Warehouse:
                        if RentalUnit."Square Feet" < 1000 then
                            RuleViolations += 1;
                end;
            until RentalUnit.Next() = 0;

        ValidationResults := 'Rule Violations: ' + Format(RuleViolations);
        exit(ValidationResults);
    end;

    procedure GenerateConfigurationReport(): Integer
    var
        RentalUnit: Record "Rental Unit";
        ConfigCount: Integer;
    begin
        RentalUnit.SetLoadFields("Unit No.", "Unit Type");
        if RentalUnit.FindSet() then
            repeat
                ConfigCount += 1;
            until RentalUnit.Next() = 0;
        exit(ConfigCount);
    end;
}