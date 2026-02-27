page 60091 "HR Approval Settings"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            part(CTORequest; "HR Approval Setting CTO Req.")
            {
                Caption = 'HR Approval Setting for CTO Request';
                ApplicationArea = all;
            }
            part(CTORealization; "HR Approval Setting CTO Real")
            {
                ApplicationArea = all;
                Caption = 'HR Approval Setting for CTO Realization';
            }
            part(MedicalReimbursement; "HR Approval Setting Medical")
            {
                ApplicationArea = all;
                Caption = 'HR Approval Setting for Medical Reimbursement';
            }
            part(AnnualLeave; "HR Approval Setting Ann. Leave")
            {
                ApplicationArea = all;
                Caption = 'HR Approval Setting for Leave and Other Attendance';
            }
        }
    }
}