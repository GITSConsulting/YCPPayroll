page 60121 "THR Ledger Entries USER VIEW"
{
    Caption = 'THR Historical Transactions';
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "THR Ledger Entry";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    //SourceTableView = where("Opening Balance" = const(true));

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
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = all;
                }
                field("Disbursement Type"; Rec."Disbursement Type")
                {
                    ApplicationArea = all;
                }
                field(LoS; Rec.LoS)
                {
                    ApplicationArea = all;
                }
                field("Calc. LoS"; Rec."Calc. LoS")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}