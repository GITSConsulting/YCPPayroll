page 65044 "Posted MR List"
{
    Caption = 'Posted Medical Reimbursements List';

    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Posted MR Header";
    SourceTableView = where("Posted Document" = filter(false));
    // ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Posted MR Card";
    Editable = false;

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

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
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
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
            frz_CodeUnit.ModuleNotReady();
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
        end;
    end;

    var
        myInt: Integer;
}