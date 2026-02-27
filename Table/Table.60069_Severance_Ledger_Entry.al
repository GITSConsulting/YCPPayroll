table 60069 "Severance Ledger Entry"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Severance Ledger Entries";
    Caption = 'Severance & Unused Leave Ledger Entries';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Severance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Unused Leave Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Severance LoS"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 7 : 7;
        }
        field(12; "Calc. LoS"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 7 : 7;
        }
        field(13; "Severance Reason"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Total Hari LoS Severance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Contract Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Bulan Posting"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Tahun Posting"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Unused Leave Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Applied to Old Basic Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            //FieldClass = FlowField;
            //CalcFormula = lookup("Posted Cuti Dibayar Line"."Applied to Old Basic Salary" where("Employee No." = field("Employee No."),
            //"Document No." = field("Unused Leave Doc. No.")));
        }
        field(20; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; "GP No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Sum of Sev. Ledger Entry No."; Integer)
        {
            Caption = 'Summary of Severance Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(23; Finished; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Basic Salary Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Fix Allowance Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Actual Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Contract Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Contract End Date"; Date)
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