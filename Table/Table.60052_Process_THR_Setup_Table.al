table 60052 "Process THR Setup Table"
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
        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"THR Only","Resigned/Contract Termination Only","THR & Resigned/Contract Termination";
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