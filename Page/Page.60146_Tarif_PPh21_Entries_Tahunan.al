page 60146 "Tarif PPh21 Entries Tahunan"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tarif PPh21 Entry Tahunan";
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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date Payroll"; Rec."Posting Date Payroll")
                {
                    Caption = 'Posting Date Year End';
                    ApplicationArea = all;
                }
                field("Used Percentage"; rec."Used Percentage")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Tax; Rec.Tax)
                {
                    ApplicationArea = all;
                }
                field("Posting Date December Payroll"; Rec."Posting Date December Payroll")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}