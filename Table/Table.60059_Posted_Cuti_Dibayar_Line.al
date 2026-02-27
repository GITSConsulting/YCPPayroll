table 60059 "Posted Cuti Dibayar Line"
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
        field(4; "Jumlah Cuti"; Decimal)
        {
            Caption = 'Unused Leave';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(5; "Jumlah Cuti (Value)"; Decimal)
        {
            Caption = 'Unused Leave (Value)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Cuti Dibayarkan"; Decimal)
        {
            Caption = 'Unused to be Paid';
            DecimalPlaces = 3 : 3;
            DataClassification = CustomerContent;
        }
        field(7; "Cuti Dibayarkan (Value)"; Decimal)
        {
            Caption = 'Unused to be paid (Value)';
            DataClassification = CustomerContent;
        }
        field(8; "Maximum Leave Disburtion"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Posting Date Header"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Cuti Dibayar Header"."Document Date" where("No." = field("Document No.")));
        }
        field(10; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Taxed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Applied to Old Basic Salary"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(16; Nett; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Basic Salary Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Fix Allowance Used"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Actual Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}