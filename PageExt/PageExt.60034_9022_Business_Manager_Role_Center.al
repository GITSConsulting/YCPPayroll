pageextension 60034 Ext_Page_BusinessMgrRC extends "Business Manager Role Center"
{
    layout
    {
        addbefore(Control139)
        {
            part(HRCue; "HRIS Cue")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst(Sections)
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
                action("HR - Accounting Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "Accounting Setup";
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