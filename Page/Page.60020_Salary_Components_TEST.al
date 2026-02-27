page 60020 "Salary Components TEST"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Salary Component";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Allowance Component Code"; Rec."Allowance Component Code")
                {
                    ApplicationArea = all;
                }
                field("Deduction Component Code"; Rec."Deduction Component Code")
                {
                    ApplicationArea = all;
                }
                field("Allowance Component Name"; Rec."Allowance Component Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Deduction Component Name"; Rec."Deduction Component Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }
}