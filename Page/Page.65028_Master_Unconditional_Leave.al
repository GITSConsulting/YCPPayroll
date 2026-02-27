page 65028 "Master Unconditional Leave"
{
    Caption = 'Master Leave';
    // ApplicationArea = Basic, Suite;
    PageType = List;
    SourceTable = "Master Leave Unconditional";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Code; rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No Backdated"; Rec."No Backdated")
                {
                    ApplicationArea = all;
                }
                field("maximum leave"; rec."maximum leave")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

