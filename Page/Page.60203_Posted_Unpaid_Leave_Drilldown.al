page 60203 "Posted Unpaid Leave Drilldown"
{
    Caption = 'Posted Unpaid Leave Requests';
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Leave Request";
    SourceTableView = where("Leave Type" = const(Unpaid));
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Posted Unpaid Leave Request";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(EmployeeName; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Salary Deduction"; Rec."Salary Deduction")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Reversed then Merah := true else Merah := false;

        Employee.Get(Rec."Employee No.");
        EmployeeName := Employee.FullName();
    end;

    var
        Employee: Record Employee;
        EmployeeName: Text;
        Merah: Boolean;

}