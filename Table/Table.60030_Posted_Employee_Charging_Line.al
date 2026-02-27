table 60030 "Posted Employee Charging Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Posting Date"; Date)
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Global Dimension 1 Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = const(false));
        }
        field(7; "Global Dimension 7 Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = const(false));
        }
        field(4; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            MaxValue = 100;
        }
        field(5; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
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