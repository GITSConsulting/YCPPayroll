page 60056 "Employee Charging List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Charging Header";
    CardPageId = "Employee Charging";
    Editable = false;


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