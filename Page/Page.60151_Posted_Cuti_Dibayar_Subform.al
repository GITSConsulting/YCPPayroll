page 60151 "Posted Cuti Dibayar Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Cuti Dibayar Line";
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
                field("Applied to Old Basic Salary"; Rec."Applied to Old Basic Salary")
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
                    Editable = false;
                }
            }
        }
    }
}