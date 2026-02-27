table 60033 "Process Payroll Setup Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; PostingDate; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; DocumentNoOvertime; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger
    OnDelete()
    var
        ProcessPayrollSetupLine: Record "Proc. Payroll Setup Line Table";
    begin
        ProcessPayrollSetupLine.DeleteAll();
    end;
}