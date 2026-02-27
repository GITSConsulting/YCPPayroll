table 60002 "Deduction Component"
{
    DataClassification = CustomerContent;
    LookupPageId = "Deduction Component List";
    fields
    {
        field(1; Kode; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(3; "Value Type"; enum "Value Type")
        {
            DataClassification = CustomerContent;
        }
        field(4; "Age Restricted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Age Lower Limit"; Integer)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                TestField("Age Restricted");
            end;
        }
        field(6; "Age Upper Limit"; Integer)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                TestField("Age Restricted");
            end;
        }
        field(7; "Salary Restricted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Salary Lower Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            trigger
            OnValidate()
            begin
                TestField("Salary Restricted");
            end;
        }
        field(9; "Salary Upper Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            trigger
            OnValidate()
            begin
                TestField("Salary Restricted");
            end;
        }
        field(10; "Value"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 7;
            trigger
            OnValidate()
            begin
                TestField("Value Type");
            end;
        }
        field(11; "G/L Account No."; code[20])
        {
            TableRelation = "G/L Account" where("Account Type" = const(Posting),
            "Direct Posting" = const(true));
            DataClassification = CustomerContent;
        }
        field(12; "Mandatory For Tax"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Deduction Indirect"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Allowance Component" where("Deduction Code" = field(Kode)));
        }
        field(14; "Excel Report"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Accounting Entry"; Option)
        {
            OptionMembers = ,Debit,Credit;
            DataClassification = CustomerContent;
        }
        field(18; Taxed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "BPJS Kesehatan Staff Portion"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Kode)
        {
            Clustered = true;
        }
    }

}