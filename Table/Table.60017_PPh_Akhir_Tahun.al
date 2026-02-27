table 60017 "PPh Akhir Tahun"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Year; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Kurang Bayar"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; Selisih; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee No.", Year)
        {
            Clustered = true;
        }
    }
}