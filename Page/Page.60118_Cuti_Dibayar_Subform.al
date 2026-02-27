page 60118 "Cuti Dibayar Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cuti Dibayar Line";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = all;
                }
                field("Maximum Leave Disburtion"; Rec."Maximum Leave Disburtion")
                {
                    ApplicationArea = all;
                }
                field("Jumlah Cuti"; Rec."Jumlah Cuti")
                {
                    ApplicationArea = all;
                }
                field("Cuti Dibayarkan"; Rec."Cuti Dibayarkan")
                {
                    ApplicationArea = all;
                }
                field("Apply to Old Basic Salary"; Rec."Apply to Old Basic Salary")
                {
                    ApplicationArea = all;
                }
                field("Cuti Dibayarkan (Value)"; Rec."Cuti Dibayarkan (Value)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Actual Payment Date"; Rec."Actual Payment Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}