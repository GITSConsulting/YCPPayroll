table 60003 "Detailed Payroll Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Detailed Payroll Ledg. Entries";

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
        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Type"; enum "Det. Payroll Ledg. Entry Type")
        {
            DataClassification = CustomerContent;
        }
        field(7; "Component Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Type" = CONST("Allowance")) "Allowance Component".Kode
            ELSE
            IF ("Type" = CONST("Deduction")) "Deduction Component".Kode;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 0;
        }
        field(9; "Marital Status for Tax"; Enum "Marital Status")
        {
            DataClassification = CustomerContent;
        }
        field(10; "Dependent Kids for Tax"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Deduction Mandatory for Tax"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Dimension Value"; code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
        field(14; "Allowance Mandatory for Tax"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Dimension No."; Enum "Dimension No.")
        {
            DataClassification = CustomerContent;
        }
        field(16; "Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Paid by Employee"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; Taxed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Allowance Type"; Option)
        {
            OptionMembers = ,"Fix","Non Fix","Premium";
            DataClassification = CustomerContent;
        }
        field(20; "Indirect Income"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Salary Upper Limit"; Decimal)
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
        key(Key2; "Posting Date")
        {

        }
        key(Key3; "Type", "Employee No.", "Posting Date", "Deduction Mandatory for Tax", "Dimension Value")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Type", "Employee No.", "Posting Date", "Allowance Mandatory for Tax", "Dimension Value")
        {
            SumIndexFields = Amount;
        }
        key(key5; "Posting Date", "Type", "Dimension Code", "Paid by Employee", "Component Code")
        {
            SumIndexFields = Amount;
        }
        key(key6; "Posting Date", "Type", "Dimension Code", "Paid by Employee", "Component Code", "Employee No.")
        {
            SumIndexFields = Amount;
        }
    }
}