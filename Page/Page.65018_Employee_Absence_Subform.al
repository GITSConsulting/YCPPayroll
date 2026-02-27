page 65018 "Employee Absence Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Employee Absence Line";
    UsageCategory = Lists;
    // ApplicationArea = all;
    AutoSplitKey = true;
    // DelayedInsert = true;
    // LinksAllowed = false;
    MultipleNewLines = true;
    // RefreshOnActivate = true;
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
                    Visible = false;
                    TableRelation = Employee."No.";
                    trigger OnValidate()
                    var
                        frz_Employee: Record Employee;
                        frz_Employee2: Record Employee;
                        frz_AttendanceHeader: Record "Employee Attendance Header";
                        frz_CodeUnit: Codeunit "User Setup Custome";
                    begin
                        errorModify();
                        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
                            // if rec.SystemCreatedBy <> UserSecurityId() then begin
                            frz_Employee2.Reset();
                            frz_Employee2.SetRange("User ID", UserId);
                            if frz_Employee2.FindFirst() then
                                if Rec."Employee No." <> frz_Employee2."No." then
                                    Error('This Employee different with your User');
                            // end;
                        end;

                        frz_Employee.reset;
                        frz_Employee.setrange("No.", Rec."Employee No.");
                        if frz_Employee.FindFirst() then
                            rec."Employee Name" := frz_Employee.FullName();

                        frz_AttendanceHeader.Reset();
                        frz_AttendanceHeader.SetRange("No.", rec."Document No.");
                        if frz_AttendanceHeader.FindFirst() then
                            if frz_AttendanceHeader."Office Location Code" <> frz_Employee."Office Location Code" then
                                Error('The Office Location Code Employee different with Office Location in header %1, %2', rec."Document No.", frz_AttendanceHeader."Office Location Code");
                        CurrPage.Update();
                    end;
                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Allow non working date"; rec."Allow non working date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if Rec."Allow non working date" <> xRec."Allow non working date" then begin
                            rec.Date := 0D;
                            rec."Time From Line" := 0T;
                            rec."Time To Line" := 0T;
                            rec."Total Duration Hours" := 0;
                            rec."Total Duration Minutes" := 0;
                        end;

                        CurrPage.Update();
                    end;
                }
                field(WFH; rec.WFH)
                {
                    ApplicationArea = all;
                }
                field(Date; rec.Date)
                {
                    Caption = 'Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_BaseCalendar: Record "Base Calendar Change";
                        rec_BaseCalendar2: Record "Base Calendar Change";
                        rec_PayrollGenSetup: Record "Payroll General Setup";
                        frz_CodeUnit: Codeunit "User Setup Custome";
                        frz_Employee: record Employee;
                        frz_AbsenceManage: Codeunit "Employee Absence Management";
                    begin
                        errorModify();
                        testfieldHeader();

                        // rec_AttendanceLine.SetRange("Document No.", rec."Document No.");
                        // rec_AttendanceLine.SetRange(Date, rec.Date);
                        // if rec_AttendanceLine.FindFirst() then
                        //     Error('The same date is already in the value lines.');

                        rec_PayrollGenSetup.FindFirst();

                        frz_Employee.Reset();
                        frz_Employee.SetRange("No.", rec."Employee No.");
                        if frz_Employee.FindFirst() then begin
                            if frz_Employee."MSI_HRIS Shift Schedule" = false then
                                if rec."Allow non working date" = false then begin
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
                                end;
                        end;
                        CurrPage.Update();
                        rec.WFH := frz_AbsenceManage.WFHChek(rec."Employee No.", rec.Date);
                        CurrPage.Update();
                    end;
                }
                field("Fund Code"; rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    Visible = false;
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
                    Visible = false;
                    trigger OnValidate()
                    var
                        Dimen: Record "Dimension Value";
                    begin
                        testfieldHeader();
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
                        testfieldHeader();
                    end;
                }
                field("Time From"; rec."Time From Line")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_CodeUnit: Codeunit "User Setup Custome";
                    begin
                        errorModify();
                        testfieldHeader();
                        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
                            // if rec.SystemCreatedBy <> UserSecurityId() then
                            // rec.cekUser();
                        end;
                    end;
                }
                field("Time To"; rec."Time To Line")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_CodeUnit: Codeunit "User Setup Custome";
                    begin
                        errorModify();
                        testfieldHeader();
                        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
                            // if rec.SystemCreatedBy <> UserSecurityId() then
                            // rec.cekUser();
                        end;
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
                field("Data by Import"; rec."Data by Import")
                {
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

    procedure testfieldHeader()
    var
        AbsenceHeader: Record "Employee Attendance Header";
        rec_AttendanceHeader: Record "Employee Attendance Header";
    begin
        AbsenceHeader.Reset();
        AbsenceHeader.SetRange("No.", rec."Document No.");
        if AbsenceHeader.FindFirst() then begin
            if AbsenceHeader."Effective Date" = 0D then
                Error('Field Effective Date must be value');
        end;

        rec_AttendanceHeader.Reset();
        rec_AttendanceHeader.SetRange("No.", rec."Document No.");
        if rec_AttendanceHeader.FindFirst() then
            if (Date2DMY(rec_AttendanceHeader."Effective Date", 2) <> Date2DMY(rec.Date, 2)) or
            (Date2DMY(rec_AttendanceHeader."Effective Date", 3) <> Date2DMY(rec.Date, 3)) then
                Error('the date in the lines is different from the effective date field in the header');
    end;

    // trigger OnAfterGetRecord()
    // var
    //     frz_Employee: Record Employee;
    //     frz_CodeUnit: Codeunit "User Setup Custome";
    // begin
    //     if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
    //         frz_Employee.Reset();
    //         frz_Employee.SetRange("User ID", UserId);
    //         if frz_Employee.FindFirst() then begin
    //             // rec.FilterGroup := -1;
    //             rec.SetFilter(rec."Employee No.", frz_Employee."No.");
    //             // rec.SetFilter(rec.SystemCreatedBy, UserSecurityId());
    //             // end;
    //         end;
    //     end;
    // end;
}
