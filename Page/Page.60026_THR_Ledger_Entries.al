page 60026 "THR Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "THR Ledger Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("THR Amount"; Rec."THR Amount")
                {
                    ApplicationArea = all;
                }
                field("Disbursement Type"; Rec."Disbursement Type")
                {
                    ApplicationArea = all;
                }
                field(OBAL; Rec.OBAL)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}