table 60004 "Headline RC HRIS"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Workdate for computations"; date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Key")
        {
        }
    }

}