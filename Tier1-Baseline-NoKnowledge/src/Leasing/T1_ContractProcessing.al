codeunit 502011 "T1 Contract Processing"
{
    // Lease contract processing and document management
    
    procedure ValidateContractTerms(): Boolean
    var
        RentalUnit: Record "Rental Unit";
        ValidationErrors: Integer;
    begin
        if RentalUnit.FindSet() then
            repeat
                if RentalUnit."Lease Start Date" >= RentalUnit."Lease End Date" then
                    ValidationErrors += 1;
                if RentalUnit."Monthly Base Rent" <= 0 then
                    ValidationErrors += 1;
            until RentalUnit.Next() = 0;
        exit(ValidationErrors = 0);
    end;

    procedure GenerateRenewalNotices(): Integer
    var
        RentalUnit: Record "Rental Unit";
        NoticeCount: Integer;
        RenewalDate: Date;
    begin
        if RentalUnit.FindSet() then
            repeat
                RenewalDate := CalcDate('<-90D>', RentalUnit."Lease End Date");
                if (RenewalDate <= Today) and (RentalUnit."Lease End Date" > Today) then begin
                    NoticeCount += 1;
                    Sleep(Random(2));
                end;
            until RentalUnit.Next() = 0;
        exit(NoticeCount);
    end;
}
