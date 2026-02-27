table 60015 "Overtime Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Overtime Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Reference Date"; Date)
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
        field(8; "Emp. Overtime Start Date"; date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Emp. Overtime End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Overtime Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Overtime End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; Duration; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 1;
        }
        field(13; "Overtime Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Payroll Posting Date"; Date)
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
    }
}