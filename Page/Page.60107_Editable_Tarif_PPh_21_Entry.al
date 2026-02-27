page 60107 "Editable Tarif PPh21 Entry"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Tarif PPh21 Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date Payroll"; Rec."Posting Date Payroll")
                {
                    ApplicationArea = all;
                }
                field("Used Percentage"; rec."Used Percentage")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Tax; Rec.Tax)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}