page 65001 "Medical Slot"
{
    Caption = 'Medical Balance';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Medical Slot";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(MyGroup)
            {
                field("Medical Type"; rec."Medical Type")
                {
                    Caption = 'Medical Type';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Medical Code"; rec."Medical Code")
                {
                    Caption = 'Medical Code';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        myInt: Integer;
}