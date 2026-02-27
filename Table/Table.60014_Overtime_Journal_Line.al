table 60014 "Overtime Journal Line"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Overtime Journal Line List";

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;

            trigger
            OnValidate()
            var
                Employee: Record Employee;
                DimensionValue: Code[20];
            begin
                Employee.Get("Employee No.");
                Employee.TestField("MSI_HRIS Shortcut Dim Code");
                Employee.CalcFields("MSI_HRIS Shortcut Dim No.");

                Employee.GeneralLedgerDimensionSetup(DimensionValue,
                                                    Employee."MSI_HRIS Shortcut Dim No.");

                Validate("Dimension Value", DimensionValue);
                Validate("Dimension No.", Employee."MSI_HRIS Shortcut Dim No.");
                Validate("Dimension Code", Employee."MSI_HRIS Shortcut Dim Code");
            end;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Dimension Value"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Dimension No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = field("Dimension No."));
        }
    }

    keys
    {
        key(PK; "Posting Date", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger
    OnInsert()
    var
        OvertimeJnlLine: Record "Overtime Journal Line";
    begin
        TestField(Amount);

        OvertimeJnlLine.Reset();
        OvertimeJnlLine.SetRange("Posting Date", "Posting Date");
        OvertimeJnlLine.SetRange("Employee No.", "Employee No.");
        if OvertimeJnlLine.FindSet() then
            Error('Employee no %1 with posting date %2 is already exist', "Employee No.", "Posting Date");
    end;
}