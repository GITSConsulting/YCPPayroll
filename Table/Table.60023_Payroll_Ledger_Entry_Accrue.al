table 60023 "Payroll Ledger Entry Accrue"
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
        field(3; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(4; "Biaya Jabatan"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Total Working Month"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Brutto Income"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(7; "Tax Deduction Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(8; "Monthly Nett Income"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(9; "Yearly Nett Income"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(10; PTKP; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(11; "PPh 21"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Tarif PKP Ledger Entry"."PPh21" where
            ("Payroll Ledger Entry No." = field("Entry No.")));
            DecimalPlaces = 0 : 0;
        }
        field(12; "Total Allowance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Det. Payrol Ledg. Entry Accrue".Amount where
            ("Payroll Ledger Entry No." = field("Entry No."), "Type" = const(Allowance)));
            DecimalPlaces = 0 : 0;
        }
        field(13; "Total Deduction"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Det. Payrol Ledg. Entry Accrue".Amount where
            ("Payroll Ledger Entry No." = field("Entry No."), "Type" = const(Deduction)));
            DecimalPlaces = 0 : 0;
        }
        field(14; "Dimension Value"; code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = 'Dimension Value';
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
        field(15; "Basic Salary"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Brutto Income Taxable"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(17; "Dimension No."; Enum "Dimension No.")
        {
            DataClassification = CustomerContent;
        }
        field(18; "Dimension Code"; Code[20])
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
        key(Key1; "Employee No.", "Posting Date", "Dimension Value")
        {
            SumIndexFields = "Basic Salary";
        }
        key(key3; "Posting Date")
        {

        }
    }
}