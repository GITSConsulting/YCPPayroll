table 60075 "SS Welfare Accr. Ledger Entry"
{
    Caption = 'Safety Security Welfare Accrual Ledger Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "SS Welfare Accr. Ledg. Entries";

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
        field(9; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Safety & Security",Welfare;
        }
        field(17; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Entry No.")
        {
            Clustered = true;
        }
    }
}