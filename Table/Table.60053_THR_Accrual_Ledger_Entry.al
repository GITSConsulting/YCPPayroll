table 60053 "THR Accrual Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "THR Accrual Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
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
        field(7; "With Muslim Disbursement"; Boolean)
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
        field(10; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "",Positive,Negative;
        }
        field(11; Description; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Hangus Reversed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Net THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Charging Processed"; Boolean)
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