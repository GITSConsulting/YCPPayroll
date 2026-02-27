table 60001 "Allowance Component"
{
    DataClassification = CustomerContent;

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
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting),
            "Direct Posting" = const(true));
        }
        field(12; "Fixed Allowance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Mandatory for Tax"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Indirect Income"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Deduction Code"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Deduction Component";
            trigger
            OnValidate()
            var
                AllowanceComponent: Record "Allowance Component";
                DeductionComponent: Record "Deduction Component";
            begin
                TestField("Indirect Income");

                //Cek data di allowance dan di deduction isinya harus sama persis.
                DeductionComponent.Get("Deduction Code");

                /*
                if AllowanceComponent."Value Type" <> DeductionComponent."Value Type" then
                    Error('Value type on allowance and deduction has to set the same.');

                if AllowanceComponent.Value <> DeductionComponent.Value then
                    Error('Value on allowance and deduction has to set the same');

                if AllowanceComponent."Age Restricted" then
                    if not DeductionComponent."Age Restricted" then
                        Error('Allowance component is set age restricted, adjust the deduction accordingly');

                if not AllowanceComponent."Age Restricted" then
                    if DeductionComponent."Age Restricted" then
                        Error('Allowance component is not set age restricted, adjust the deduction accordingly');

                if AllowanceComponent."Age Lower Limit" <> DeductionComponent."Age Lower Limit" then
                    Error('Age lower limit must be set the same.');

                if AllowanceComponent."Age Upper Limit" <> DeductionComponent."Age Upper Limit" then
                    Error('Age upper limit must be set the same.');
                

                if AllowanceComponent."Salary Restricted" then
                    if not DeductionComponent."Salary Restricted" then
                        Error('Allowance component is set salary restricted, adjust the deduction accordingly');

                if not AllowanceComponent."Salary Restricted" then
                    if DeductionComponent."Salary Restricted" then
                        Error('Allowance component is not set salary restricted, adjust the deduction accordingly');

                if AllowanceComponent."Salary Lower Limit" <> DeductionComponent."Salary Lower Limit" then
                    Error('Salary lower limit must be set the same.');

                if AllowanceComponent."Salary Upper Limit" <> DeductionComponent."Salary Upper Limit" then
                    Error('Salary upper limit must be set the same.');
                */


                //Cek jika deduction yg akan diinputkan sudah pernah dipasangkan dengan allowance lain
                AllowanceComponent.Reset();
                AllowanceComponent.SetRange("Deduction Code", "Deduction Code");
                if AllowanceComponent.FindFirst() then
                    Error('Deduction %1 is already paired with Allowance %2',
                            "Deduction Code", AllowanceComponent.Kode);
            end;
        }
        field(16; "Excel Report"; Boolean)
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
            trigger
            OnValidate()
            begin
                if not Taxed then
                    TestField("Allowance Type", "Allowance Type"::Premium);
            end;
        }
        field(19; "Allowance Type"; Option)
        {
            OptionMembers = ,"Fix","Non Fix","Premium";
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if "Allowance Type" in [1, 2] then
                    Taxed := true
                else
                    Taxed := false;
            end;
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