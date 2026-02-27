table 65017 "Master Leave Unconditional"
{
    Caption = 'User Attendance HRIS';
    DrillDownPageID = "Master Leave";
    LookupPageID = "Master Leave";
    ReplicateData = true;

    fields
    {
        field(1; Code; Code[50])
        {
            DataClassification = CustomerContent;

        }
        field(4; "Document Type"; Enum "Document Type Leave")
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(3; "maximum leave"; Integer)
        {
            DataClassification = CustomerContent;
        }
        //dre
        field(5; "No Backdated"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document Type", Code)
        {
            Clustered = true;
        }
    }
}

