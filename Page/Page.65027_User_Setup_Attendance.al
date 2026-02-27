page 65027 "User Setup HRIS"
{
    // ApplicationArea = Basic, Suite;
    Caption = 'User Setup';
    PageType = List;
    SourceTable = "User Setup HRIS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("User ID"; rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = "User Lookup";
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Admin Attendance"; rec."Admin Attendance")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        // area(factboxes)
        // {
        //     systempart(Control1900383207; Links)
        //     {
        //         ApplicationArea = RecordLinks;
        //         Visible = false;
        //     }
        //     systempart(Control1905767507; Notes)
        //     {
        //         ApplicationArea = Notes;
        //         Visible = false;
        //     }
        // }
    }
}

