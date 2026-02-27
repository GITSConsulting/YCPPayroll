page 60101 "Proc. Pay. Unpaid Leave Subfr."
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Process Payroll Unpaid Leave";
    InsertAllowed = false;
    //Editable = false;
    //ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Process With This Payroll"; Rec."Process With This Payroll")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FullName; FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Salary Deduction"; Rec."Salary Deduction")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        //if Rec.FindFirst() then begin
        Employee.Get(Rec."Employee No.");
        FullName := Employee.FullName();
        //end;
    end;

    var
        Employee: Record Employee;
        FullName: Text[100];
}