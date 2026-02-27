page 60168 "Editable SS Welfare AccrLedgEn"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SS Welfare Accr. Ledger Entry";
    Caption = 'Editable Safety Security Welfare Accrual Ledger Entries';

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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = all;
                }
                field("Payroll Date"; Rec."Payroll Date")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}