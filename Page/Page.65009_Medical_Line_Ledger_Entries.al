page 65009 "Description of attendance"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Description of attendance";
    UsageCategory = Lists;
    ApplicationArea = all;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field(Date; rec.Date)
                {
                    Caption = 'Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_AttendanceHeader: Record "Employee Attendance Header";
                        rec_AttendanceLine: Record "Employee Absence Line";
                        rec_BaseCalendar: Record "Base Calendar Change";
                        rec_BaseCalendar2: Record "Base Calendar Change";
                        rec_PayrollGenSetup: Record "Payroll General Setup";
                        frz_CodeUnit: Codeunit "User Setup Custome";
                    begin
                        errorModify();
                        testfieldHeader();
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
                        rec_BaseCalendar.Reset();
                        rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                        rec_BaseCalendar.SetRange(Date, rec.Date);
                        if rec_BaseCalendar.FindFirst() then begin
                            if rec_BaseCalendar.Nonworking = true then begin
                                error('The Date is Weekend or Not Working');
                            end;
                        end else begin
                            rec_BaseCalendar2.Reset();
                            rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                            rec_BaseCalendar2.SetRange(Day, Date2DWY(rec.Date, 1));
                            rec_BaseCalendar2.SetRange(Date, 0D);
                            if rec_BaseCalendar2.FindFirst() then
                                if rec_BaseCalendar2.Nonworking = true then
                                    error('The Date is Weekend or Not Working');
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Activity Description"; rec."Activity Description")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify();
                        testfieldHeader();
                    end;
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

    procedure testfieldHeader()
    var
        AbsenceHeader: Record "Employee Attendance Header";
    begin
        AbsenceHeader.Reset();
        AbsenceHeader.SetRange("No.", rec."Document No.");
        if AbsenceHeader.FindFirst() then begin
            if AbsenceHeader."Effective Date" = 0D then
                Error('Field Effective Date must be value');
        end;
    end;
}