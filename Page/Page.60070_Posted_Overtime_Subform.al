page 60070 "Posted Overtime Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Overtime Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(FullName; FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Emp. Overtime Starting Date"; Rec."Emp. Overtime Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Emp. Overtime Ending Date"; Rec."Emp. Overtime Ending Date")
                {
                    ApplicationArea = all;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        Employee.Get(Rec."Employee No.");
        FullName := Employee.FullName();
    end;

    var
        Employee: Record Employee;
        FullName: Text;
}