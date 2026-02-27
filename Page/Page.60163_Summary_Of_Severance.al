page 60163 "Sum. Of Severance-Unused Leave"
{
    Caption = 'Summaries Of Severances & Unused Leaves';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Summary Of Severance";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}