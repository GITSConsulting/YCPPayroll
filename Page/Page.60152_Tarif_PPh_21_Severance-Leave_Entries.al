page 60152 "Tarif PPh21 Sevr-Leave Entries"
{
    Caption = 'Tarif PPh21 Severance & Unused Leave Entries';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tarif PPh21 Sevr. Leave Entry";

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
                field("Posting Date"; Rec."Posting Date")
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