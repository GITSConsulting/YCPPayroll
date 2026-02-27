table 60044 "Detailed CTO Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Detailed CTO Ledger Entries";
    LookupPageId = "Detailed CTO Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "CTO Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "CTO Ledger Entry";
        }
        field(3; "Work Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Starting Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Ending Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Duration (Day)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Duration (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Duration (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Reversed By Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Detailed CTO Ledger Entry";
        }
        field(11; "Reversal Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Positive,Negative;
        }
        field(19; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Task ID"; Integer)
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