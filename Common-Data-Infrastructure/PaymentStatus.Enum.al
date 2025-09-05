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