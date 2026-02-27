page 60104 "Non Working Dates"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Base Calendar Change";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnOpenPage()
    var
        HRSetup: Record "Payroll General Setup";
    begin
        //HRSetup.Get();
        //HRSetup.TestField("Base Calendar Code");

        //Rec.SetRange("Base Calendar Code", HRSetup."Base Calendar Code");
        //Rec.FindSet();
    end;
}