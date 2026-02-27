page 60065 "Overtime Menu"
{
    PageType = List;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = true;
    UsageCategory = Lists;
    //ApplicationArea = all;

    layout
    {
        area(Content)
        {
            field(TextMenu1; TextMenu[1])
            {
                ShowCaption = false;
                ApplicationArea = all;
            }
            field(TextMenu2; TextMenu[2])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    Page.Run(60062);
                end;
            }
            field(TextMenu3; TextMenu[3])
            {
                ApplicationArea = all;
                ShowCaption = false;
                trigger
                OnDrillDown()
                begin
                    Page.Run(60068);
                end;
            }
        }
    }
    var
        TextMenu: Array[10] of text;

    trigger
    OnOpenPage()
    begin
        TextMenu[1] := '';
        TextMenu[2] := 'Overtime';
        TextMenu[3] := 'Posted Overtime';
    end;
}