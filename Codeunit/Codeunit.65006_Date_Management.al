codeunit 65006 "Date Management"
{
    procedure CheckingDate(NoDocument: Code[50]; tanggalnya: date; Location: Code[50])
    var
        frz_Employee: Record Employee;
        frz_DateTable: Record date;
        frz_AttendanceLine: Record "Employee Absence Line";
        frz_AttendanceLine2: Record "Employee Absence Line";
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_BaseCalendar3: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";
        LeaveRequest: Record "Leave Request";
        PostedLeaveRequest: Record "Posted Leave Request";
        frz_Uncunditional: Record "Unconditional Leave Request";
        frz_CTORealiz: Record "CTO Realization Header";

        frz_PostedUncunditional: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz: Record "Posted CTO Realization Header";
        frz_ShiftSchedule: Record "Shift Schedules";
    begin
        frz_AttendanceLine2.Reset();
        frz_AttendanceLine2.SetRange("Document No.", NoDocument);
        frz_AttendanceLine2.SetLoadFields("Employee No.");
        if frz_AttendanceLine2.FindFirst() then
            repeat

                rec_PayrollGenSetup.FindFirst();

                frz_Employee.Reset();
                frz_Employee.SetRange("No.", frz_AttendanceLine2."Employee No.");
                frz_Employee.SetRange(status, frz_Employee.Status::Active);
                if frz_Employee.FindFirst() then begin
                    frz_DateTable.Reset();
                    frz_DateTable.SetRange("Period Start", CalcDate('-CM', tanggalnya), CalcDate('CM', tanggalnya));
                    if frz_DateTable.FindFirst() then
                        repeat
                            if (frz_Employee."MSI_HRIS Shift Schedule" = false) or (frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin
                                frz_AttendanceLine.Reset();
                                frz_AttendanceLine.SetRange(Date, frz_DateTable."Period Start");
                                frz_AttendanceLine.SetRange("Employee No.", frz_Employee."No.");
                                frz_AttendanceLine.SetRange("Document No.", NoDocument);
                                if not frz_AttendanceLine.FindFirst() then begin
                                    rec_BaseCalendar.Reset();
                                    rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                    rec_BaseCalendar.SetRange(WFH, true);
                                    rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                    if not rec_BaseCalendar.FindFirst() then begin
                                        rec_BaseCalendar2.Reset();
                                        rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                        rec_BaseCalendar2.SetRange(Date, 0D);
                                        rec_BaseCalendar2.SetRange(Day, Date2DWY(frz_DateTable."Period Start", 1));
                                        if not rec_BaseCalendar2.FindFirst() then begin
                                            PostedLeaveRequest.Reset();
                                            PostedLeaveRequest.SetRange("Employee No.", frz_Employee."No.");
                                            PostedLeaveRequest.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                            PostedLeaveRequest.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                            PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
                                            if not PostedLeaveRequest.FindFirst() then begin
                                                frz_PostedUncunditional.Reset();
                                                frz_PostedUncunditional.SetRange("Employee No.", frz_Employee."No.");
                                                frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
                                                if not frz_PostedUncunditional.FindFirst() then begin
                                                    frz_PostedCTORealiz.Reset();
                                                    frz_PostedCTORealiz.SetRange("Employee No.", frz_Employee."No.");
                                                    frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                    frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                    if not frz_PostedCTORealiz.FindFirst() then begin
                                                        rec_BaseCalendar3.Reset();
                                                        rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                                        rec_BaseCalendar3.SetRange(Nonworking, true);
                                                        rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                        if not rec_BaseCalendar3.FindFirst() then begin
                                                            Error('For No Employee %1 attendance miss in the date = %2', frz_Employee."No.", frz_DateTable."Period Start");
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end else begin
                                if frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Guard" then begin
                                    frz_AttendanceLine.Reset();
                                    frz_AttendanceLine.SetRange(Date, frz_DateTable."Period Start");
                                    frz_AttendanceLine.SetRange("Employee No.", frz_Employee."No.");
                                    frz_AttendanceLine.SetRange("Document No.", NoDocument);
                                    if not frz_AttendanceLine.FindFirst() then begin
                                        PostedLeaveRequest.Reset();
                                        PostedLeaveRequest.SetRange("Employee No.", frz_Employee."No.");
                                        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                        PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
                                        if not PostedLeaveRequest.FindFirst() then begin
                                            frz_PostedUncunditional.Reset();
                                            frz_PostedUncunditional.SetRange("Employee No.", frz_Employee."No.");
                                            frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                            frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                            frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
                                            if not frz_PostedUncunditional.FindFirst() then begin
                                                frz_PostedCTORealiz.Reset();
                                                frz_PostedCTORealiz.SetRange("Employee No.", frz_Employee."No.");
                                                frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                if not frz_PostedCTORealiz.FindFirst() then begin
                                                    frz_ShiftSchedule.Reset();
                                                    frz_ShiftSchedule.SetRange("Employee No.", frz_Employee."No.");
                                                    frz_ShiftSchedule.SetRange("Type Shift", frz_ShiftSchedule."Type Shift"::"Shift Guard");
                                                    frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggalnya), CalcDate('CM', Tanggalnya));
                                                    if frz_ShiftSchedule.FindFirst() then begin
                                                        if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin
                                                            rec_BaseCalendar.Reset();
                                                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                                                            rec_BaseCalendar.SetRange(WFH, true);
                                                            rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                                            if not rec_BaseCalendar.FindFirst() then begin
                                                                rec_BaseCalendar3.Reset();
                                                                rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                                                                rec_BaseCalendar3.SetRange(Nonworking, true);
                                                                rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                                if not rec_BaseCalendar3.FindFirst() then begin
                                                                    Error('For No Employee %1 attendance miss in the date = %2', frz_Employee."No.", frz_DateTable."Period Start");
                                                                end;
                                                            end;

                                                        end else begin
                                                            rec_BaseCalendar.Reset();
                                                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                                                            rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                                            rec_BaseCalendar.SetRange(WFH, true);
                                                            if not rec_BaseCalendar.FindFirst() then begin
                                                                rec_BaseCalendar3.Reset();
                                                                rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                                                                rec_BaseCalendar3.SetRange(Nonworking, true);
                                                                rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                                if not rec_BaseCalendar3.FindFirst() then begin
                                                                    Error('For No Employee %1 attendance miss in the date = %2', frz_Employee."No.", frz_DateTable."Period Start");
                                                                end;
                                                            end;

                                                        end;
                                                    end;

                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        until frz_DateTable.Next = 0;
                end;
            until frz_AttendanceLine2.Next = 0;
    end;

    procedure CheckingDateForRealease(NoDocument: Code[50]; tanggalnya: date; Location: Code[50]): Boolean
    var
        frz_Employee: Record Employee;
        frz_DateTable: Record date;
        frz_AttendanceLine: Record "Employee Absence Line";
        frz_AttendanceLine2: Record "Employee Absence Line";
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_BaseCalendar3: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";
        LeaveRequest: Record "Leave Request";
        PostedLeaveRequest: Record "Posted Leave Request";
        frz_Uncunditional: Record "Unconditional Leave Request";
        frz_CTORealiz: Record "CTO Realization Header";

        frz_PostedUncunditional: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz: Record "Posted CTO Realization Header";
        frz_ShiftSchedule: Record "Shift Schedules";
    begin
        frz_AttendanceLine2.Reset();
        frz_AttendanceLine2.SetRange("Document No.", NoDocument);
        frz_AttendanceLine2.SetLoadFields("Employee No.");
        if frz_AttendanceLine2.FindFirst() then
            repeat
                rec_PayrollGenSetup.FindFirst();

                frz_Employee.Reset();
                frz_Employee.SetRange("No.", frz_AttendanceLine2."Employee No.");
                frz_Employee.SetRange(status, frz_Employee.Status::Active);
                if frz_Employee.FindFirst() then begin
                    frz_DateTable.Reset();
                    frz_DateTable.SetRange("Period Start", CalcDate('-CM', tanggalnya), CalcDate('CM', tanggalnya));
                    if frz_DateTable.FindFirst() then
                        repeat
                            if (frz_Employee."MSI_HRIS Shift Schedule" = false) or (frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin
                                frz_AttendanceLine.Reset();
                                frz_AttendanceLine.SetRange(Date, frz_DateTable."Period Start");
                                frz_AttendanceLine.SetRange("Employee No.", frz_Employee."No.");
                                frz_AttendanceLine.SetRange("Document No.", NoDocument);
                                if not frz_AttendanceLine.FindFirst() then begin
                                    rec_BaseCalendar.Reset();
                                    rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                    rec_BaseCalendar.SetRange(WFH, true);
                                    rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                    if not rec_BaseCalendar.FindFirst() then begin
                                        rec_BaseCalendar2.Reset();
                                        rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                        rec_BaseCalendar2.SetRange(Date, 0D);
                                        rec_BaseCalendar2.SetRange(Day, Date2DWY(frz_DateTable."Period Start", 1));
                                        if not rec_BaseCalendar2.FindFirst() then begin
                                            LeaveRequest.Reset();
                                            LeaveRequest.SetRange("Employee No.", frz_Employee."No.");
                                            LeaveRequest.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                            LeaveRequest.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                            if not LeaveRequest.FindFirst() then begin
                                                PostedLeaveRequest.Reset();
                                                PostedLeaveRequest.SetRange("Employee No.", frz_Employee."No.");
                                                PostedLeaveRequest.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                PostedLeaveRequest.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
                                                if not PostedLeaveRequest.FindFirst() then begin
                                                    frz_Uncunditional.Reset();
                                                    frz_Uncunditional.SetRange("Employee No.", frz_Employee."No.");
                                                    frz_Uncunditional.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                    frz_Uncunditional.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                    if not frz_Uncunditional.FindFirst() then begin
                                                        frz_CTORealiz.Reset();
                                                        frz_CTORealiz.SetRange("Employee No.", frz_Employee."No.");
                                                        frz_CTORealiz.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                        frz_CTORealiz.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                        if not frz_CTORealiz.FindFirst() then begin
                                                            frz_PostedUncunditional.Reset();
                                                            frz_PostedUncunditional.SetRange("Employee No.", frz_Employee."No.");
                                                            frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                            frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                            frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
                                                            if not frz_PostedUncunditional.FindFirst() then begin
                                                                frz_PostedCTORealiz.Reset();
                                                                frz_PostedCTORealiz.SetRange("Employee No.", frz_Employee."No.");
                                                                frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                                frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                                if not frz_PostedCTORealiz.FindFirst() then begin
                                                                    rec_BaseCalendar3.Reset();
                                                                    rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                                                    rec_BaseCalendar3.SetRange(Nonworking, true);
                                                                    rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                                    if not rec_BaseCalendar3.FindFirst() then begin
                                                                        exit(true);
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end else begin
                                if frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Guard" then begin
                                    frz_AttendanceLine.Reset();
                                    frz_AttendanceLine.SetRange(Date, frz_DateTable."Period Start");
                                    frz_AttendanceLine.SetRange("Employee No.", frz_Employee."No.");
                                    frz_AttendanceLine.SetRange("Document No.", NoDocument);
                                    if not frz_AttendanceLine.FindFirst() then begin
                                        PostedLeaveRequest.Reset();
                                        PostedLeaveRequest.SetRange("Employee No.", frz_Employee."No.");
                                        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                        PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
                                        if not PostedLeaveRequest.FindFirst() then begin
                                            frz_PostedUncunditional.Reset();
                                            frz_PostedUncunditional.SetRange("Employee No.", frz_Employee."No.");
                                            frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                            frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                            frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
                                            if not frz_PostedUncunditional.FindFirst() then begin
                                                frz_PostedCTORealiz.Reset();
                                                frz_PostedCTORealiz.SetRange("Employee No.", frz_Employee."No.");
                                                frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', frz_DateTable."Period Start");
                                                frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', frz_DateTable."Period Start");
                                                if not frz_PostedCTORealiz.FindFirst() then begin
                                                    frz_ShiftSchedule.Reset();
                                                    frz_ShiftSchedule.SetRange("Employee No.", frz_Employee."No.");
                                                    frz_ShiftSchedule.SetRange("Type Shift", frz_ShiftSchedule."Type Shift"::"Shift Guard");
                                                    frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggalnya), CalcDate('CM', Tanggalnya));
                                                    if frz_ShiftSchedule.FindFirst() then begin
                                                        if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin

                                                            rec_BaseCalendar.Reset();
                                                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                                                            rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                                            rec_BaseCalendar.SetRange(WFH, true);
                                                            if not rec_BaseCalendar.FindFirst() then begin
                                                                rec_BaseCalendar3.Reset();
                                                                rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                                                                rec_BaseCalendar3.SetRange(Nonworking, true);
                                                                rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                                if not rec_BaseCalendar3.FindFirst() then begin
                                                                    exit(true);
                                                                end;
                                                            end;

                                                        end else begin

                                                            rec_BaseCalendar.Reset();
                                                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                                                            rec_BaseCalendar.SetRange(Date, frz_DateTable."Period Start");
                                                            rec_BaseCalendar.SetRange(WFH, true);
                                                            if not rec_BaseCalendar.FindFirst() then begin
                                                                rec_BaseCalendar3.Reset();
                                                                rec_BaseCalendar3.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                                                                rec_BaseCalendar3.SetRange(Nonworking, true);
                                                                rec_BaseCalendar3.SetRange(Date, frz_DateTable."Period Start");
                                                                if not rec_BaseCalendar3.FindFirst() then begin
                                                                    exit(true);
                                                                end;
                                                            end;

                                                        end;
                                                    end;

                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        until frz_DateTable.Next = 0;
                end;
            until frz_AttendanceLine2.Next = 0;
    end;
}