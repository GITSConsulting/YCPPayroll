page 60113 "Editable THR Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "THR Ledger Entry";
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
                field("Payroll Ledger Entry No."; Rec."Payroll Ledger Entry No.")
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
                field("THR Compensation"; Rec."THR Compensation")
                {
                    ApplicationArea = all;
                }
                field(OBAL; Rec.OBAL)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}