pageextension 60025 Ext_YCPUSER extends "Role Center User"
{
    layout
    {
        addbefore(CueFinUser)
        {
            part(HRCue; "HRIS Cue")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addbefore("Travel Advance")
        {
            group("Human Resources IS")
            {
                action("HR - Leave Management")
                {
                    ApplicationArea = all;
                    RunObject = page "Leave Request Menu USER";
                }
                action("HR - Medical Reimbursement")
                {
                    ApplicationArea = all;
                    RunObject = page "Medical Reimbursement Menu";
                }
                action("HR - Attendance")
                {
                    ApplicationArea = all;
                    RunObject = page "Attendance Menu USER";
                }
                action("HR - Employee")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee List";
                }
            }
        }
    }
}