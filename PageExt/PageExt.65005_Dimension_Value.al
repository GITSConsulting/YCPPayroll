pageextension 65005 "HRIS Dimension Values Custome" extends "Dimension Values"
{
    layout
    {
        addafter("Dimension Value Type")
        {
            field("MSI_HRIS Activity PAR"; rec."MSI_HRIS Activity PAR")
            {
                ApplicationArea = all;
            }
        }
    }
}