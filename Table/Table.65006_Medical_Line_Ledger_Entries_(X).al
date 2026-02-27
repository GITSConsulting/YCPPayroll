table 65006 "Medical Line Ledger Entries"
{
    DataClassification = CustomerContent;
    // DrillDownPageId = "Medical Line Ledger Entries";
    // LookupPageId = "Medical Line Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Medical Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "CTO Ledger Entry";
        }
        field(3; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Reversed By Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Detailed CTO Ledger Entry";
        }
        field(5; "Reversal Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Entry Type"; Option)
        {
            OptionMembers = ,Positive,Negative;
        }
        field(7; Reversed; Boolean)
        {
        }
        field(20; "Claim Amount"; Decimal)
        {

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