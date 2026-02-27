table 60048 "Process Payroll Unpaid Leave"
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
        field(4; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Total Number of Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Process With This Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Salary Deduction"; Decimal)
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


    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;
}