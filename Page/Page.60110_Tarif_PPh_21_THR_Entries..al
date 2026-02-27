page 60110 "Tarif PPh21 THR Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tarif PPh21 THR Entry";

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
                field("Posting Date THR"; Rec."Posting Date THR")
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