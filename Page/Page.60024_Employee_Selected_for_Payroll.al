page 60024 "Employee Selected for Payroll"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Temporary";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        EmployeTableTemp: Record "Employee Temporary";
    //EmployeeQueryTemp: Query "Employee Temporary";

    procedure PopulateEmployeeTemp(var EmployeeSent: Record Employee)
    begin
        EmployeTableTemp.DeleteAll();
        EmployeeSent.FindFirst();
        repeat
            EmployeTableTemp.Init();
            EmployeTableTemp.TransferFields(EmployeeSent);
            EmployeTableTemp.Insert();
        until EmployeeSent.Next() = 0;
    end;

    trigger
    OnOpenPage()
    begin
        /*EmployeeQueryTemp.Open();
        while EmployeeQueryTemp.Read() do begin
            "No." := EmployeeQueryTemp.No_;
            "First Name" := EmployeeQueryTemp.First_Name;
            "Last Name" := EmployeeQueryTemp.Last_Name;
            Insert();
        end;
        FindFirst();*/
    end;
}