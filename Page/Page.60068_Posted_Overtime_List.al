page 60068 "Posted Overtime List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Overtime Header";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Posted Overtime";

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
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime Start Date"; Rec."Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime End Date"; Rec."Overtime End Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}