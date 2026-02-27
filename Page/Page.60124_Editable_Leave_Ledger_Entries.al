page 60124 "Editable Leave Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Leave Ledger Entry";


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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = all;
                }
                field("Period End"; Rec."Period End")
                {
                    ApplicationArea = all;
                }
                field("Maximum Times of Accrual"; Rec."Maximum Times of Accrual")
                {
                    ApplicationArea = all;
                }
                field("Maximum Leave Disburtion"; Rec."Maximum Leave Disburtion")
                {
                    ApplicationArea = all;
                }
                field("Hiring Information Entry No."; Rec."Hiring Information Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Year Period"; Rec."Year Period")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}