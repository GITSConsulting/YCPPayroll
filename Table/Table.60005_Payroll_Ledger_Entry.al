table 60005 "Payroll Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Payroll Ledger Entries";

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
        }
        field(5; "Periode Penghasilan"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Total Income"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Gross Income"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Reguler Setahun"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Bijab Reguler"; Decimal)
        {
            DataClassification = CustomerContent;
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
            CalcFormula = sum("Detailed Payroll Ledger Entry".Amount where
            ("Payroll Ledger Entry No." = field("Entry No."), "Type" = const(Allowance)));
            DecimalPlaces = 0 : 0;
        }
        field(13; "Total Deduction"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Payroll Ledger Entry".Amount where
            ("Payroll Ledger Entry No." = field("Entry No."), "Type" = const(Deduction)));
            DecimalPlaces = 0 : 0;
        }
        field(14; "Jumlah Pengurangan"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Basic Salary"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Pensiun JHT THT Setahun"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Penghasilan Netto Setahun"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "PKP Correct"; Decimal)
        {
            Caption = 'PKP';
            DataClassification = CustomerContent;
        }
        field(20; "Tanggal 20 Processed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Tanggal 31 Processed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Payroll Processed Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Total Working Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Newly Hired"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Unconditional Leave"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Last Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Last Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Less/Over Deduct Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Year End Process"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = ,"Awaiting Process",Processed;
            CalcFormula = lookup("Payroll Processed Entry"."Year End Process"
            where("Entry No." = field("Payroll Processed Entry No.")));
        }
        field(30; "Akhir Tahun (Year)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Akhir Tahun Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Other Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Adjustment Prorate"; Decimal)
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
        key(Key1; "Employee No.", "Posting Date")
        {
            SumIndexFields = "Basic Salary";
        }
        key(key3; "Posting Date")
        {

        }
    }
}