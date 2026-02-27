table 60070 "Process Severance Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; PostingDate; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Ada Leave"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(4; UnusedLeaveDocNo; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}