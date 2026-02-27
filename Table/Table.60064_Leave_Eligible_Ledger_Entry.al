table 60064 "Leave Eligible Ledger Entry"
{
    DrillDownPageId = "Leave Eligible Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        { DataClassification = CustomerContent; }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        { DataClassification = CustomerContent; }
        field(4; Type; Option)
        {
            OptionMembers = ,Positive,Negative;
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[100])
        { DataClassification = CustomerContent; }
        field(6; Quantity; Decimal)
        { DataClassification = CustomerContent; }
        field(9; "Document No."; Code[20])
        { DataClassification = CustomerContent; }
        field(10; "Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Paid,Unpaid;
        }
        field(11; "Paid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Annual,Sick,Other;
        }
        field(12; "Unpaid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Leave Without Pay","Absence Without Pay";
        }
        field(13; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(16; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Reversed by Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Reverse Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Month Eligible"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Year Eligible"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Hiring Information Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}