page 60084 "Detailed CTO Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Detailed CTO Ledger Entry";
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
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Work Description"; Rec."Work Description")
                {
                    ApplicationArea = all;
                }
                field("Task Date"; Rec."Task Date")
                {
                    ApplicationArea = all;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = all;
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = all;
                }
                field("Duration (Hour)"; Rec."Duration (Hour)")
                {
                    ApplicationArea = all;
                }
                field("Duration (Minute)"; Rec."Duration (Minute)")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}