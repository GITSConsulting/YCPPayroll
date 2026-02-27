table 65009 "Employee Absence Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Employee Attendance Header";
        }
        field(13; "Entry No Header"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Shortcut Dimension 1 Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('FUND CODE'));
        }
        field(4; "Shortcut Dimension 2 Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Time From Line"; Time)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                AbsenceManage: Codeunit "Employee Absence Management";
                lamaJam: Integer;
                lamaMenit: Integer;
            begin
                if Rec."Time From Line" <> xRec."Time To Line" then begin
                    // "Time To Line" := 0T;
                    "Total Duration Hours" := 0;
                    "Total Duration Minutes" := 0;
                    if "Time To Line" <> 0T then begin
                        AbsenceManage.hitungDurasiAbsence("Time From Line", "Time To Line", lamaJam, lamaMenit);
                        "Total Duration Hours" := lamaJam;
                        "Total Duration Minutes" := lamaMenit;
                    end;
                end;
            end;
        }
        field(6; "Time To Line"; Time)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                AbsenceManage: Codeunit "Employee Absence Management";
                lamaJam: Integer;
                lamaMenit: Integer;
                varTime: BigInteger;
            begin
                if cekShift() = false then
                    if "Time To Line" <= "Time From Line" then
                        Error('Time To must be bigger than Time From.');

                AbsenceManage.hitungDurasiAbsence("Time From Line", "Time To Line", lamaJam, lamaMenit);
                "Total Duration Hours" := lamaJam;
                "Total Duration Minutes" := lamaMenit;
                // Message(Format("Time To Line", 0, '<Hours24>'));
                // varTime := "Time To Line" - "Time From Line";
                // Message('%1', varTime);
            end;
        }
        field(7; "Total Duration Hours"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Total Duration Minutes"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Activity Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Activity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Employee Name"; Text[100])
        {

        }
        field(16; Month; Text[100])
        {
        }
        field(17; Year; Integer)
        {
        }
        field(18; "Data by Import"; Boolean)
        {
        }
        field(19; "Allow non working date"; Boolean)
        {
        }
        field(20; WFH; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Document No.", "Entry No Header", "Line No.")
        {
            Clustered = true;
        }
        key(PKDate; "Document No.", Date)
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    var
        AbsenceHeader: Record "Employee Attendance Header";
        frz_CodeUnitMonth: Codeunit "Month Picker";
    begin
        AbsenceHeader.Reset();
        AbsenceHeader.SetRange("No.", rec."Document No.");
        if AbsenceHeader.FindFirst() then begin
            rec."Activity Date" := AbsenceHeader."Effective Date";
            rec."Employee No." := AbsenceHeader."Employee No.";
            rec."Employee Name" := AbsenceHeader."Name Employee";
            rec.Year := Date2DMY(AbsenceHeader."Effective Date", 3);
            rec.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(AbsenceHeader."Effective Date", 2));
        end;
    end;

    trigger OnModify()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            if rec."Data by Import" = true then
                Error('Data can not be update, because data input from import system');
        // if rec.SystemCreatedBy <> UserSecurityId() then begin
        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", "Document No.");
        if frz_AttendanceHeader.FindFirst() then begin
            rec."Employee No." := frz_AttendanceHeader."Employee No.";
        end;
        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then begin
            if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
                if frz_employee."No." <> Rec."Employee No." then begin
                    frz_employee_2.Reset();
                    frz_employee_2.SetRange("MSI_HRIS Admin By", UserId);
                    if frz_employee_2.FindFirst() then begin
                        if frz_employee_2."No." <> Rec."Employee No." then
                            Error('This line is not yours');
                    end;
                end;
            end;
        end;
        // end;
    end;

    trigger OnDelete()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            if rec."Data by Import" = true then
                Error('Data can not be update, because data input from import system');

        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", "Document No.");
        if frz_AttendanceHeader.FindFirst() then begin
            rec."Employee No." := frz_AttendanceHeader."Employee No.";
        end;
        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then begin
            if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
                if frz_employee."No." <> Rec."Employee No." then begin
                    frz_employee_2.Reset();
                    frz_employee_2.SetRange("MSI_HRIS Admin By", UserId);
                    if frz_employee_2.FindFirst() then begin
                        if frz_employee_2."No." <> Rec."Employee No." then
                            Error('This line is not yours');
                    end;
                end;
            end;
        end;
        // end;
    end;

    //start -Andre 16 Sep 21
    procedure CheckLeaveSync(Tanggalnya: Date; EmployeeNo: Code[20])
    var
        frz_PostedUncunditional: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz: Record "Posted CTO Realization Header";
        frz_Uncunditional: Record "Unconditional Leave Request";
        frz_CTORealiz: Record "CTO Realization Header";
        LeaveRequest: Record "Leave Request";
        PostedLeaveRequest: Record "Posted Leave Request";
        PostedLeaveRequest_leave_1: Record "Posted Leave Request";
        PostedLeaveRequest_leave_2: Record "Posted Leave Request";
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";

        rec_AttendanceHeader: Record "Employee Attendance Header";
        rec_AttendanceLine: Record "Employee Absence Line";

        frz_EmployeeCheck: Record Employee;
        frz_ShiftSchedule: Record "Shift Schedules";
        TypeEmployeeShift: Boolean;

        frz_AttendanceLine: Record "Employee Absence Line";
    begin
        frz_EmployeeCheck.reset;
        frz_EmployeeCheck.SetRange("No.", EmployeeNo);
        if frz_EmployeeCheck.FindFirst() then
            TypeEmployeeShift := frz_EmployeeCheck."MSI_HRIS Shift Schedule";

        PostedLeaveRequest.Reset();
        PostedLeaveRequest.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest.SetRange("Leave-1", false);
        PostedLeaveRequest.SetRange("Leave-2", false);
        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest.FindSet() then
            Error('There is a posted leave request for this date = %1, Employee No. = %2' +
                  'Please check.', Tanggalnya, PostedLeaveRequest."Employee No.");

        PostedLeaveRequest_leave_1.Reset();
        PostedLeaveRequest_leave_1.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest_leave_1.SetRange("Leave-1", true);
        PostedLeaveRequest_leave_1.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest_leave_1.FindFirst() then begin

            PostedLeaveRequest_leave_2.Reset();
            PostedLeaveRequest_leave_2.SetRange("Employee No.", EmployeeNo);
            PostedLeaveRequest_leave_2.SetRange("Leave-2", true);
            PostedLeaveRequest_leave_2.SetFilter("Starting Date", '<=%1', Tanggalnya);
            PostedLeaveRequest_leave_2.SetFilter("Ending Date", '>=%1', Tanggalnya);
            PostedLeaveRequest_leave_2.SetFilter(Reversed, '<> %1', true);
            if PostedLeaveRequest_leave_2.FindFirst() then
                Error('There is a posted leave request for this date = %1, Employee No. = %2' +
                      'Please check.', Tanggalnya, PostedLeaveRequest_leave_2."Employee No.");

        end;

        frz_PostedUncunditional.Reset();
        frz_PostedUncunditional.SetRange("Employee No.", EmployeeNo);
        frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
        if frz_PostedUncunditional.FindSet() then
            Error('There is a unconditional leave request for this date = %1, Employee No. = %2' +
                  'Please check.', Tanggalnya, frz_PostedUncunditional."Employee No.");

        frz_PostedCTORealiz.Reset();
        frz_PostedCTORealiz.SetRange("Employee No.", EmployeeNo);
        frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if frz_PostedCTORealiz.FindSet() then
            Error('There is a CTO Realization request for this date = %1, Employee No. = %2' +
                  'Please check.', Tanggalnya, frz_PostedCTORealiz."Employee No.");


        rec_PayrollGenSetup.FindFirst();

        frz_AttendanceLine.Reset();
        frz_AttendanceLine.SetRange("Employee No.", EmployeeNo);
        frz_AttendanceLine.SetRange(Date, Tanggalnya);
        if frz_AttendanceLine.FindFirst() then
            frz_AttendanceLine.FindFirst();

        if frz_AttendanceLine."Allow non working date" = false then begin

            if (TypeEmployeeShift = false) or (frz_EmployeeCheck."MSI_HRIS Type Shift" = frz_EmployeeCheck."MSI_HRIS Type Shift"::"Shift Office Helper") then begin

                rec_BaseCalendar.Reset();
                rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                rec_BaseCalendar.SetRange(Date, Tanggalnya);
                if rec_BaseCalendar.FindFirst() then begin
                    if rec_BaseCalendar.Nonworking = true then
                        error('The Date %1 is Weekend or Not Working for Employee No. = %2', Tanggalnya, EmployeeNo);
                end else begin
                    rec_BaseCalendar2.Reset();
                    rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                    rec_BaseCalendar2.SetRange(Day, Date2DWY(Tanggalnya, 1));
                    rec_BaseCalendar2.SetRange(Date, 0D);
                    if rec_BaseCalendar2.FindFirst() then
                        if rec_BaseCalendar2.Nonworking = true then
                            error('The Date %1 is Weekend or Not Working for Employee No. = %2', Tanggalnya, EmployeeNo);
                end;

            end else begin
                if frz_EmployeeCheck."MSI_HRIS Type Shift" = frz_EmployeeCheck."MSI_HRIS Type Shift"::"Shift Guard" then begin
                    frz_ShiftSchedule.Reset();
                    frz_ShiftSchedule.SetRange("Employee No.", EmployeeNo);
                    frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggalnya), CalcDate('CM', Tanggalnya));
                    if frz_ShiftSchedule.FindFirst() then begin
                        if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin

                            rec_BaseCalendar.Reset();
                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                            rec_BaseCalendar.SetRange(Date, Tanggalnya);
                            if rec_BaseCalendar.FindFirst() then
                                if rec_BaseCalendar.Nonworking = true then
                                    error('The Date %1 is Weekend or Not Working for Employee No. = %2', Tanggalnya, EmployeeNo);

                        end else begin

                            rec_BaseCalendar.Reset();
                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                            rec_BaseCalendar.SetRange(Date, Tanggalnya);
                            if rec_BaseCalendar.FindFirst() then
                                if rec_BaseCalendar.Nonworking = true then
                                    error('The Date %1 is Weekend or Not Working for Employee No. = %2', Tanggalnya, EmployeeNo);

                        end;
                    end;
                end;
            end;
        end;

        rec_AttendanceHeader.Reset();
        rec_AttendanceHeader.SetRange("No.", rec."Document No.");
        if rec_AttendanceHeader.FindFirst() then
            if (Date2DMY(rec_AttendanceHeader."Effective Date", 2) <> Date2DMY(Tanggalnya, 2)) or
            (Date2DMY(rec_AttendanceHeader."Effective Date", 3) <> Date2DMY(Tanggalnya, 3)) then
                Error('the date in the lines is different from the effective date field in the header');

        rec_AttendanceLine.Reset();
        rec_AttendanceLine.SetRange("Document No.", rec."Document No.");
        rec_AttendanceLine.SetRange("Employee No.", rec."Employee No.");
        rec_AttendanceLine.SetRange(Date, Tanggalnya);
        if rec_AttendanceLine.FindFirst() then
            if rec_AttendanceLine.Count > 1 then
                Error('The same date %1 is already in the value lines.', Tanggalnya);
    end;
    //end -Andre

    procedure CheckLeaveSyncForRelase(Tanggalnya: Date; EmployeeNo: Code[20]): Boolean
    var
        frz_PostedUncunditional: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz: Record "Posted CTO Realization Header";
        frz_Uncunditional: Record "Unconditional Leave Request";
        frz_CTORealiz: Record "CTO Realization Header";
        LeaveRequest: Record "Leave Request";
        PostedLeaveRequest_leave_1: Record "Posted Leave Request";
        PostedLeaveRequest_leave_2: Record "Posted Leave Request";
        PostedLeaveRequest: Record "Posted Leave Request";
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";

        rec_AttendanceHeader: Record "Employee Attendance Header";
        rec_AttendanceLine: Record "Employee Absence Line";

        frz_EmployeeCheck: Record Employee;
        frz_ShiftSchedule: Record "Shift Schedules";
        TypeEmployeeShift: Boolean;

        frz_AttendanceLine: Record "Employee Absence Line";
    begin
        frz_EmployeeCheck.reset;
        frz_EmployeeCheck.SetRange("No.", EmployeeNo);
        if frz_EmployeeCheck.FindFirst() then
            TypeEmployeeShift := frz_EmployeeCheck."MSI_HRIS Shift Schedule";

        PostedLeaveRequest.Reset();
        PostedLeaveRequest.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest.SetRange("Leave-1", false);
        PostedLeaveRequest.SetRange("Leave-2", false);
        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest.FindSet() then
            exit(true);

        PostedLeaveRequest_leave_1.Reset();
        PostedLeaveRequest_leave_1.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest_leave_1.SetRange("Leave-1", true);
        PostedLeaveRequest_leave_1.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest_leave_1.FindFirst() then begin

            PostedLeaveRequest_leave_2.Reset();
            PostedLeaveRequest_leave_2.SetRange("Employee No.", EmployeeNo);
            PostedLeaveRequest_leave_2.SetRange("Leave-2", true);
            PostedLeaveRequest_leave_2.SetFilter("Starting Date", '<=%1', Tanggalnya);
            PostedLeaveRequest_leave_2.SetFilter("Ending Date", '>=%1', Tanggalnya);
            PostedLeaveRequest_leave_2.SetFilter(Reversed, '<> %1', true);
            if PostedLeaveRequest_leave_2.FindFirst() then
                exit(true);

        end;

        frz_PostedUncunditional.Reset();
        frz_PostedUncunditional.SetRange("Employee No.", EmployeeNo);
        frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
        if frz_PostedUncunditional.FindSet() then
            exit(true);

        frz_PostedCTORealiz.Reset();
        frz_PostedCTORealiz.SetRange("Employee No.", EmployeeNo);
        frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if frz_PostedCTORealiz.FindSet() then
            exit(true);

        rec_PayrollGenSetup.FindFirst();

        frz_AttendanceLine.Reset();
        frz_AttendanceLine.SetRange("Employee No.", EmployeeNo);
        frz_AttendanceLine.SetRange(Date, Tanggalnya);
        if frz_AttendanceLine.FindFirst() then
            frz_AttendanceLine.FindFirst();

        if frz_AttendanceLine."Allow non working date" = false then begin
            if TypeEmployeeShift = false then begin
                rec_BaseCalendar.Reset();
                rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                rec_BaseCalendar.SetRange(Date, Tanggalnya);
                if rec_BaseCalendar.FindFirst() then begin
                    if rec_BaseCalendar.Nonworking = true then begin
                        exit(true);
                    end;
                end else begin
                    rec_BaseCalendar2.Reset();
                    rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                    rec_BaseCalendar2.SetRange(Day, Date2DWY(Tanggalnya, 1));
                    rec_BaseCalendar2.SetRange(Date, 0D);
                    if rec_BaseCalendar2.FindFirst() then
                        if rec_BaseCalendar2.Nonworking = true then
                            exit(true);
                end;
            end else begin
                frz_ShiftSchedule.Reset();
                frz_ShiftSchedule.SetRange("Employee No.", EmployeeNo);
                frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggalnya), CalcDate('CM', Tanggalnya));
                if frz_ShiftSchedule.FindFirst() then begin
                    if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin

                        rec_BaseCalendar.Reset();
                        rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                        rec_BaseCalendar.SetRange(Date, Tanggalnya);
                        if rec_BaseCalendar.FindFirst() then
                            if rec_BaseCalendar.Nonworking = true then
                                exit(true);

                    end else begin

                        rec_BaseCalendar.Reset();
                        rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                        rec_BaseCalendar.SetRange(Date, Tanggalnya);
                        if rec_BaseCalendar.FindFirst() then
                            if rec_BaseCalendar.Nonworking = true then
                                exit(true);
                    end;
                end;
            end;
        end;

        rec_AttendanceHeader.Reset();
        rec_AttendanceHeader.SetRange("No.", rec."Document No.");
        if rec_AttendanceHeader.FindFirst() then
            if (Date2DMY(rec_AttendanceHeader."Effective Date", 2) <> Date2DMY(Tanggalnya, 2)) or
            (Date2DMY(rec_AttendanceHeader."Effective Date", 3) <> Date2DMY(Tanggalnya, 3)) then
                exit(true);

        rec_AttendanceLine.Reset();
        rec_AttendanceLine.SetRange("Document No.", rec."Document No.");
        rec_AttendanceLine.SetRange("Employee No.", rec."Employee No.");
        rec_AttendanceLine.SetRange(Date, Tanggalnya);
        if rec_AttendanceLine.FindFirst() then
            if rec_AttendanceLine.Count > 1 then
                exit(true);
    end;

    procedure cekUser()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then
            if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
                if frz_employee."No." <> Rec."Employee No." then begin
                    frz_employee_2.Reset();
                    frz_employee_2.SetRange("MSI_HRIS Admin By", UserId);
                    if frz_employee_2.FindFirst() then begin
                        if frz_employee_2."No." <> Rec."Employee No." then
                            Error('This line is not yours');
                    end;
                end;
    end;

    procedure cekOfficeLocation()
    var
        frz_employee: Record Employee;
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", rec."Document No.");
        frz_AttendanceHeader.FindFirst();

        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then
            if frz_employee."Office Location Code" <> frz_AttendanceHeader."Office Location Code" then
                Error('Office Location Employee does not match with the Office Location in the document header');
    end;

    procedure cekShift(): Boolean
    var
        frz_Employee: record employee;
    begin
        frz_Employee.Reset();
        frz_Employee.SetRange("No.", rec."Employee No.");
        if frz_Employee.FindFirst() then
            exit(frz_Employee."MSI_HRIS Shift Schedule");
    end;
}