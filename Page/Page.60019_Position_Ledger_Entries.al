page 60019 "Position Ledger Entries"
{
    PageType = List;
    UsageCategory = Lists;
    //ApplicationArea = All;
    SourceTable = "Position Ledger Entry";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Career Transition"; Rec."Career Transition")
                {
                    ApplicationArea = all;
                }
                field("Employment Status"; Rec."Employment Status")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}