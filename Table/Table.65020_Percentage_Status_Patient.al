table 65020 "Percentage Status Patient"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Code; Enum "Status Employee")
        {

        }
        field(2; Percentage; Decimal)
        {

        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}