page 60030 "Overtime Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Overtime Ledger Entry";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Payroll Posting Date"; Rec."Payroll Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime Doc. No."; Rec."Overtime Doc. No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Emp. Overtime Start Date"; Rec."Emp. Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Emp. Overtime End Date"; Rec."Emp. Overtime End Date")
                {
                    ApplicationArea = all;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}