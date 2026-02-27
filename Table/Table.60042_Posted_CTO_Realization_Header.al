table 60042 "Posted CTO Realization Header"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Posted CTO Realization List";
    LookupPageId = "Posted CTO Realization List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Pending Approval";
        }

        field(6; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }

        field(10; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Total Number of Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }



    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;


}