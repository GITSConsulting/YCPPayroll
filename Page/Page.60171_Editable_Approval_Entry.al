page 60171 "Editable Approval Entry"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Approval Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = all;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = all;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = all;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = all;
                }
                field("Number of Approved Requests"; Rec."Number of Approved Requests")
                {
                    ApplicationArea = all;
                }
                field("Approval Chain Doc. Type"; Rec."Approval Chain Doc. Type")
                {
                    ApplicationArea = all;
                }
                field("Approval Chain Line No."; Rec."Approval Chain Line No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}