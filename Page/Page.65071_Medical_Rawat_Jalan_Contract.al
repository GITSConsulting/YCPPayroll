page 65071 "Medical Rawat Jalan Contract"
{
    Caption = 'Medical Rawat Jalan';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const("Rawat Jalan"));
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
                ShowCaption = false;
                field("Medical Code"; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; rec.Percentage)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}