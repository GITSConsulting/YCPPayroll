pageextension 65004 "Base Calendar Change" extends "Base Calendar Changes"
{
    layout
    {
        addafter(Nonworking)
        {
            field(WFH; rec.WFH)
            {
                ApplicationArea = all;
            }
        }
    }
}