table 60025 "Tarif PKP Ledger Entry Accrue"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Tarif PKP Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Used Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(4; PPh21; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Amount Used"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(6; "Yearly PKP"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(7; "Owed PPh 21"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(8; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(10; "Global Dimension 1 Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
        field(11; "Dimension No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Dimension Code"; Code[20])
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
        key(key1; "Posting Date", "Employee No.", "Global Dimension 1 Code")
        {
            SumIndexFields = PPh21;
        }
    }
}