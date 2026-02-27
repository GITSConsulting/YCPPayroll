page 65003 "Medical Reimbursement List"
{
    //dre
    Caption = 'Medical Reimbursements';

    PageType = List;
    RefreshOnActivate = true;
    Editable = false;
    SourceTable = "Medical Reimbursement Header";
    SourceTableView = where("Posted Document" = filter(false), Opbal = filter(false));
    // ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Medical Reimbursement Card";

    layout
    {
        area(Content)
        {
            repeater(MyGroup)
            {
                field(Code; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Name Employee"; EmployeeName)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                }
                //dre
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    var
        EmployeeName: Text;

    trigger OnAfterGetRecord()
    var
        Employeenya: Record Employee;
    begin
        Employeenya.reset;
        Employeenya.setrange("No.", rec."Employee No.");
        if Employeenya.FindFirst() then
            EmployeeName := Employeenya.FullName();
    end;

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();

        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
    end;
}