table 60024 "Overtime Ledger Entry Accrue"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Dimension Value"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
        field(6; "Dimension No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Dimension Code"; Code[20])
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
        key(key1; "Posting Date", "Dimension Code")
        {
            SumIndexFields = Amount;
        }
        key(key3; "Posting Date", "Dimension Code", "Employee No.")
        {

        }
    }
}