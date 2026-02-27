table 65018 "Uncon Leave Ledger Entry"
{
    DrillDownPageId = "Uncon Leave Ledger Entries";
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
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(9; "Document No."; Code[20])
        { DataClassification = CustomerContent; }
        field(11; "Paid Leave Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Master Leave Unconditional";
        }
        field(12; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(15; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Reversed by Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Reverse Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Leave Type Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Master Leave Unconditional";
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