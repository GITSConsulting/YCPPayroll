page 60085 "Edit Det. CTO Ledg. Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Detailed CTO Ledger Entry";

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
                field("CTO Ledger Entry No."; Rec."CTO Ledger Entry No.")
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