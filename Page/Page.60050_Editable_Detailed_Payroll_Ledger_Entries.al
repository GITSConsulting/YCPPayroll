page 60050 "Edit Det Payroll Ledg. Entries"
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Detailed Payroll Ledger Entry";
    Caption = 'Detailed Payroll Ledger Entries';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payroll Ledger Entry No."; Rec."Payroll Ledger Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Component Code"; Rec."Component Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Paid by Employee"; Rec."Paid by Employee")
                {
                    ApplicationArea = all;
                }
                field("Marital Status for Tax"; Rec."Marital Status for Tax")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dependent Kids for Tax"; Rec."Dependent Kids for Tax")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Deduction Mandatory for Tax"; Rec."Deduction Mandatory for Tax")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Allowance Mandatory for Tax"; Rec."Allowance Mandatory for Tax")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = all;
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = all;
                }
                field("Dimension No."; Rec."Dimension No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}