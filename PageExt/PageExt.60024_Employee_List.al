pageextension 60024 Ext_EmployeeList extends "Employee List"
{
    Editable = false;
    layout
    {
        modify("No.")
        {
            Style = Unfavorable;
            StyleExpr = Merah;
        }
        modify("First Name")
        {
            Style = Unfavorable;
            StyleExpr = Merah;
        }
        modify("Last Name")
        {
            Style = Unfavorable;
            StyleExpr = Merah;
        }
        modify("Job Title")
        {
            Style = Unfavorable;
            StyleExpr = Merah;
        }
        modify("Travel Advance (LCY)")
        {
            Visible = false;
        }
        modify("Project Advance (LCY)")
        {
            Visible = false;
        }
        modify("General Advance (LCY)")
        {
            Visible = false;
        }

    }

    actions
    {
        modify(Email)
        {
            Visible = false;
        }
        modify("Absence Registration")
        {
            Visible = false;
        }
        modify(PayEmployee)
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify("Ledger E&ntries")
        {
            Visible = false;
        }
        modify("Sent Emails")
        {
            Visible = false;
        }
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify("&Relatives")
        {
            Visible = false;
        }
        modify("E&mployee")
        {
            Visible = false;
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if (Rec.Status = Rec.Status::Inactive) or (Rec.Status = Rec.Status::Terminated) then
            Merah := true
        else
            Merah := false;

    end;

    trigger
    OnOpenPage()
    begin
        Rec.SetRange(Status, Rec.Status::Active);
    end;

    var
        Merah: Boolean;
}