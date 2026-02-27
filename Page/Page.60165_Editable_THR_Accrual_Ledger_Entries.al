page 60165 "Edit THR Accr. Ledg. Entries"
{
    Caption = 'Editable THR Accrual Ledger Entries';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "THR Accrual Ledger Entry";

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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Payroll Date"; Rec."Payroll Date")
                {
                    ApplicationArea = all;
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = all;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = all;
                }
                field("With Muslim Disbursement"; Rec."With Muslim Disbursement")
                {
                    ApplicationArea = all;
                }
                field(Disbursed; Rec.Disbursed)
                {
                    ApplicationArea = all;
                }
                field("THR Ledger Entry No."; Rec."THR Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Payroll Ledger Entry No."; Rec."Payroll Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Hangus Reversed"; Rec."Hangus Reversed")
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