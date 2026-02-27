table 60054 "Severance Accrual Ledger Entry"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Severance Accr. Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Accrual Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; Disbursed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Disbursement Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; "THR Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Contract Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "",Positive,Negative;
        }
        field(17; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Hangus Reversed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Payment Delayed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Actual Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; "GP No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}