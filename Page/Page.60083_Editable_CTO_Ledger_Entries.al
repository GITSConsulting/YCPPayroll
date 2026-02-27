page 60083 "Editable CTO Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "CTO Ledger Entry";

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
                field("CTO Type"; Rec."CTO Type")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Task Date"; Rec."Task Date")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Work Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Day Balance"; Rec."Day Balance")
                {
                    ApplicationArea = all;
                }
                field("Request Approval Date"; Rec."Request Approval Date")
                {
                    ApplicationArea = all;
                }
                field("Request Expired Date"; Rec."Request Expired Date")
                {
                    ApplicationArea = all;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = all;
                }
                field("Reversal Entry"; Rec."Reversal Entry")
                {
                    ApplicationArea = all;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = all;
                }
                field("Reversed By Entry No."; Rec."Reversed By Entry No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}