page 60102 "Employee Absence Lines"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Absence Line";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = all;
                }
                field("Time From Line"; Rec."Time From Line")
                {
                    ApplicationArea = all;
                }
                field("Time To Line"; Rec."Time To Line")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}