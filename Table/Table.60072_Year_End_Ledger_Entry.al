table 60072 "Year End Ledger Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Year End Starting"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Year End Ending"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date Year End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Posting Date December Payroll"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "PPh 21 Terutang"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}