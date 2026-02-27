page 60025 "Employee List Entry THR"
{
    PageType = List;
    UsageCategory = Lists;
    //ApplicationArea = All;
    SourceTable = Employee;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'THR Entries';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FullName; Rec.FullName)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS THR Amount"; Rec."MSI_HRIS THR Amount")
                {
                    Caption = 'THR Amount';
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }
}