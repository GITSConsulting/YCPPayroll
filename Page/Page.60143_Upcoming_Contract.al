page 60143 "Upcoming Contract"
{
    PageType = ListPart;
    UsageCategory = Lists;
    //ApplicationArea = All;
    SourceTable = "Upcoming Contract";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    RefreshOnActivate = true;
    //DelayedInsert = true;
    //AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Effective Date"; format(Rec."Contract Start Date", 0, '<Day> <Month Text> <Year>'))
                {
                    Caption = 'Contract Start Date';
                    ApplicationArea = All;
                }
                field("Contract End Date"; format(Rec."Contract End Date", 0, '<Day> <Month Text> <Year>'))
                {
                    ApplicationArea = all;
                }
                field("Resign Date"; format(Rec."Resign Date", 0, '<Day> <Month Text> <Year>'))
                {
                    Caption = 'Resign/Termination Date';
                    ApplicationArea = all;
                }
            }
        }
    }
}