table 60047 "Process Payroll Cuti Dibayar"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Secondary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Leave Balance"; Decimal)
        {
            DecimalPlaces = 1 : 1;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Leave Ledger Entry".Quantity where("Employee No." = field("Employee No.")));
        }
        field(5; "Leave Balance (Value)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "To Be Paid"; Decimal)
        {
            DecimalPlaces = 1 : 1;
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                "To Be Paid (Value)" := ValueToBePaid("Employee No.", "To Be Paid");
            end;
        }
        field(7; "To Be Paid (Value)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Secondary Key", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure ValueToBePaid(EmpNo: Code[20]; ToBePaid: Decimal): Decimal;
    var
        DailySalary: Decimal;
        Employee: Record Employee;
    begin
        Employee.Get(EmpNo);
        DailySalary := Employee."MSI_HRIS Basic Salary" / 21;

        exit(DailySalary * ToBePaid);
    end;


    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;
}