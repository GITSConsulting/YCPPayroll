table 60036 "Proc. Payroll Setup Line Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Secondary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; LineDocNoOvertime; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Secondary Key", "Line No.")
        {
            Clustered = true;
        }
    }

}