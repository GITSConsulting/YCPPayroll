page 65072 "Medical RI Room Contract"
{
    Caption = 'Rate Room';
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
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}