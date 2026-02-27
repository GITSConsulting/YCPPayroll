table 60073 "Tax Paid Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Tax Paid Entries";
    LookupPageId = "Tax Paid Entries";

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
        field(3; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Tax Paid"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Retrieve Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; Type; Option)
        {
            OptionMembers = ,Payroll,THR;
            DataClassification = CustomerContent;
        }
        field(8; "THR Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Disbursement Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","With Muslim Disbursement","With Non Muslim Disbursement","Compensation";
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