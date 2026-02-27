page 60028 "Overtime Journal"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group("Please fill posting date")
            {
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = All;
                    trigger
                    OnValidate()
                    begin
                        CurrPage.subform.Page.GetPostingDate(PostingDate);
                    end;
                }
            }
            part(subform; "Overtime Journal Line")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        PostingDate: Date;
}