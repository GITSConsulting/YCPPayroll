page 60167 "Editable Unused Leave AccrLedg"
{
    Caption = 'Editable Unused Leave Accrual Ledger Entries';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sisa Cuti Accrual Ledger Entry";

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
                field("Payroll Date"; Rec."Payroll Date")
                {
                    ApplicationArea = all;
                }
                field("Accrual Amount"; Rec."Accrual Amount")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Payroll Ledger Entry No."; Rec."Payroll Ledger Entry No.")
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
                field("Payment Delayed"; Rec."Payment Delayed")
                {
                    ApplicationArea = all;
                }
                field("Actual Payment Date"; Rec."Actual Payment Date")
                {
                    ApplicationArea = all;
                }
                field("GP No."; Rec."GP No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}