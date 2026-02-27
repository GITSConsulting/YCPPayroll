page 60108 "Tarif PPh21 Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tarif PPh21 Entry";

    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
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