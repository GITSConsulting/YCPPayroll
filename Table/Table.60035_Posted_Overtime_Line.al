table 60035 "Posted Overtime Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; "Emp. Overtime Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Emp. Overtime Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Duration"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 1;
            Editable = false;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}