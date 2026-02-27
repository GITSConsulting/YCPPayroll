page 60062 "Overtime List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Overtime Header";
    Editable = false;
    ModifyAllowed = false;
    CardPageId = Overtime;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime Start Date"; Rec."Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime End Date"; Rec."Overtime End Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = merah;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::"Payroll Process" then
            merah := true
        else
            merah := false;
    end;

    var
        merah: Boolean;
}