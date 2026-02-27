pageextension 65003 "Base Calendar Custome" extends "Base Calendar Entries Subform"
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