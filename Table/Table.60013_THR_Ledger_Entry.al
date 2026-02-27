table 60013 "THR Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "THR Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "THR Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "PPh 21 THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Brutto Plus THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Brutto Minus THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "PPh 21 THR Type"; enum "PPh21 THR Type")
        {
            DataClassification = CustomerContent;
        }
        field(10; "PKP Setahun"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "% Tarif Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Dimension Value"; code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
        field(13; "Dimension No."; Enum "Dimension No.")
        {
            DataClassification = CustomerContent;
        }
        field(14; "Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Reguler Setahun With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Gross Income With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Biaya Jabatan With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Bijab Reguler With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Jumlah Pengurangan With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Penghasilan Netto Setahun THR"; Decimal)
        {
            Caption = 'Penghasilan Netto Setahun With THR';
            DataClassification = CustomerContent;
        }
        field(21; "PKP With THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(22; "With Muslim THR Disbursement"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Last Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Less/Over Deduct Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Last Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(24; "PKP Correct THR"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Opening Balance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Disbursement Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","With Muslim Disbursement","With Non Muslim Disbursement","Compensation";
        }
        field(27; "THR Compensation"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; LoS; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Calc. LoS"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Disbursement Date"; date)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Basic Salary"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(34; OBAL; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(35; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(36; "Applied to Old Basic Salary"; Boolean)
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
        key(key1; "Employee No.", "Posting Date")
        {

        }
        key(key2; "PPh 21 THR Type", "Employee No.", "Posting Date")
        {

        }
    }
}