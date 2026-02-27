page 60058 "Posted Employee Charging List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Posted Employee Charg. Header";
    CardPageId = "Posted Employee Charging";
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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date Payroll';
                    ApplicationArea = all;
                }
                field("Posting Date Charging"; Rec."Posting Date Charging")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}