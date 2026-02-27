table 60016 "Dimension Value Employee"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dimension Value Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Dimension Value Code", "Employee No.")
        {
            Clustered = true;
        }
    }
}