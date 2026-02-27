page 60166 "Editable Sev. Accr. Ledg. Entr"
{
    Caption = 'Editable Severance Accrual Ledger Entries';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Severance Accrual Ledger Entry";

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
                field("Entry Type"; Rec."Entry Type")
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
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}