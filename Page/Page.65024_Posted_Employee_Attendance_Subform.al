page 65024 "Posted Attendance Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Posted Employee Absence Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                    end;
                }
                field(Date; rec.Date)
                {
                    Caption = 'Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_AttendanceHeader: Record "Employee Attendance Header";
                        rec_BaseCalendar: Record "Base Calendar Change";
                        rec_AttendanceLine: Record "Employee Absence Line";
                        rec_PayrollGenSetup: Record "Payroll General Setup";
                    begin
                        errorModify();
                        rec_AttendanceHeader.SetRange("No.", rec."Document No.");
                        if rec_AttendanceHeader.FindFirst() then
                            if (Date2DMY(rec_AttendanceHeader."Effective Date", 2) <> Date2DMY(rec.Date, 2)) or
                            (Date2DMY(rec_AttendanceHeader."Effective Date", 3) <> Date2DMY(rec.Date, 3)) then
                                Error('the date in the lines is different from the effective date field in the header');

                        rec_AttendanceLine.SetRange("Document No.", rec."Document No.");
                        rec_AttendanceLine.SetRange(Date, rec.Date);
                        if rec_AttendanceLine.FindFirst() then
                            Error('The same date is already in the value lines.');

                        rec_PayrollGenSetup.FindFirst();
                        rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                        rec_BaseCalendar.SetRange(Date, rec.Date);
                        if rec_BaseCalendar.FindFirst() then begin
                            if rec_BaseCalendar.Nonworking = true then
                                error('The Date is Weekend or Not Working');
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Fund Code"; rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                    end;
                }
                field(Activity; rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Activity';
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('ACTIVITY'));
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        Dimen: Record "Dimension Value";
                    begin
                        errorModify();
                        dimen.SetRange("Dimension Code", 'ACTIVITY');
                        dimen.SetRange(code, rec."Shortcut Dimension 2 Code");
                        if dimen.FindFirst() then
                            rec."Activity Description" := dimen.Name;
                    end;
                }
                field("Activity Description"; rec."Activity Description")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                    end;
                }
                field("Time From"; rec."Time From Line")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                    end;
                }
                field("Time To"; rec."Time To Line")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                    end;
                }
                field("Total Hours"; rec."Total Duration Hours")
                {
                    Caption = 'Total Hours';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total Minutes"; rec."Total Duration Minutes")
                {
                    Caption = 'Total Minutes';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    procedure errorModify()
    var
        rec_AttendanceHeader: Record "Employee Attendance Header";
    begin
        rec_AttendanceHeader.SetRange("No.", rec."Document No.");
        if rec_AttendanceHeader.FindFirst() then
            if rec_AttendanceHeader.Status = rec_AttendanceHeader.Status::Released then
                Error('The Document Can Not Update Because Status is Release');
    end;
}
