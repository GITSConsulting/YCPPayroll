codeunit 65007 "Leave Checking"
{
    procedure TemporaryDate(DateStart: date; DateEnd: date; employeeNya: Code[20]; DocumentNo: code[50])
    var
        frz_DateTable: Record date;
    begin
        frz_DateTable.Reset();
        frz_DateTable.SetRange("Period Start", DateStart, DateEnd);
        if frz_DateTable.FindFirst() then
            repeat
                LeaveCheck(frz_DateTable."Period Start", employeeNya, DocumentNo);
            until frz_DateTable.Next = 0;
    end;

    procedure LeaveCheck(Tanggalnya: Date; EmployeeNo: Code[20]; DocumentNo: code[50])
    var
        frz_PostedUncunditional: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz: Record "Posted CTO Realization Header";
        PostedLeaveRequest: Record "Posted Leave Request";
        PostedLeaveRequest_leave_1: Record "Posted Leave Request";
        PostedLeaveRequest_leave_2: Record "Posted Leave Request";

        frz_PostedUncunditional2: Record "Posted Unco Leave Request";
        frz_PostedCTORealiz2: Record "Posted CTO Realization Header";
        PostedLeaveRequest2: Record "Posted Leave Request";

        frz_Uncunditional: Record "Unconditional Leave Request";
        frz_CTORealiz: Record "CTO Realization Header";
        LeaveRequest: Record "Leave Request";
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";

        rec_AttendanceHeader: Record "Employee Attendance Header";
        rec_AttendanceLine: Record "Employee Absence Line";
    begin
        LeaveRequest.Reset();
        LeaveRequest.SetRange("Employee No.", EmployeeNo);
        LeaveRequest.SetFilter("No.", '<> %1', DocumentNo);
        LeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        LeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if LeaveRequest.FindSet() then
            Error('There is a leave request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, EmployeeNo, LeaveRequest."No.");

        // dia sebagai yg cuti
        PostedLeaveRequest.Reset();
        PostedLeaveRequest.SetRange("Employee No.", EmployeeNo);
        // PostedLeaveRequest.SetFilter("Document Type", '<> %1', PostedLeaveRequest."Document Type"::"Other Attendance");
        PostedLeaveRequest.SetFilter("No.", '<> %1', DocumentNo);
        PostedLeaveRequest.SetFilter("Total Number of Days", '> %1', 0.5);
        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest.FindSet() then
            Error('There is a posted leave request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, PostedLeaveRequest."Employee No.", PostedLeaveRequest."No.");

        PostedLeaveRequest_leave_1.Reset();
        PostedLeaveRequest_leave_1.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest_leave_1.SetFilter("No.", '<> %1', DocumentNo);
        PostedLeaveRequest_leave_1.SetRange("Leave-1", true);
        PostedLeaveRequest_leave_1.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest_leave_1.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest_leave_1.FindSet() then
            Error('There is a posted leave request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, PostedLeaveRequest_leave_1."Employee No.", PostedLeaveRequest_leave_1."No.");
        PostedLeaveRequest_leave_2.Reset();
        PostedLeaveRequest_leave_2.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest_leave_2.SetFilter("No.", '<> %1', DocumentNo);
        PostedLeaveRequest_leave_2.SetRange("Leave-2", true);
        PostedLeaveRequest_leave_2.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest_leave_2.SetFilter("Ending Date", '>=%1', Tanggalnya);
        PostedLeaveRequest_leave_2.SetFilter(Reversed, '<> %1', true);
        if PostedLeaveRequest_leave_2.FindSet() then
            Error('There is a posted leave request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, PostedLeaveRequest_leave_2."Employee No.", PostedLeaveRequest_leave_2."No.");

        frz_PostedUncunditional.Reset();
        frz_PostedUncunditional.SetRange("Employee No.", EmployeeNo);
        frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', Tanggalnya);
        frz_PostedUncunditional.SetFilter(Reversed, '<> %1', true);
        if frz_PostedUncunditional.FindSet() then
            Error('There is a unconditional leave request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, frz_PostedUncunditional."Employee No.", frz_PostedUncunditional."No.");

        frz_PostedCTORealiz.Reset();
        frz_PostedCTORealiz.SetRange("Employee No.", EmployeeNo);
        frz_PostedCTORealiz.SetFilter("Starting Date", '<=%1', Tanggalnya);
        frz_PostedCTORealiz.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if frz_PostedCTORealiz.FindSet() then
            Error('There is a CTO Realization request for this date = %1, Employee No. = %2' +
                  ' Please check Document No. = %3.', Tanggalnya, frz_PostedCTORealiz."Employee No.", frz_PostedCTORealiz."No.");

        // dia sebagai yg replacement cuti
        // PostedLeaveRequest2.Reset();
        // PostedLeaveRequest2.SetRange("Employee No. Replacement", EmployeeNo);
        // PostedLeaveRequest2.SetFilter("No.", '<> %1', DocumentNo);
        // PostedLeaveRequest2.SetFilter("Starting Date", '<=%1', Tanggalnya);
        // PostedLeaveRequest2.SetFilter("Ending Date", '>=%1', Tanggalnya);
        // PostedLeaveRequest2.SetFilter(Reversed, '<> %1', true);
        // if PostedLeaveRequest2.FindSet() then
        //     Error('There is a posted leave request for this date = %1, Employee No. = %2' +
        //           ' Please check Document No. = %3.', Tanggalnya, PostedLeaveRequest2."Employee No. Replacement", PostedLeaveRequest2."No.");

        // frz_PostedUncunditional2.Reset();
        // frz_PostedUncunditional2.SetRange("Employee No. Replacement", EmployeeNo);
        // frz_PostedUncunditional2.SetFilter("Starting Date", '<=%1', Tanggalnya);
        // frz_PostedUncunditional2.SetFilter("Ending Date", '>=%1', Tanggalnya);
        // frz_PostedUncunditional2.SetFilter(Reversed, '<> %1', true);
        // if frz_PostedUncunditional2.FindSet() then
        //     Error('There is a unconditional leave request for this date = %1, Employee No. = %2' +
        //           ' Please check Document No. = %3.', Tanggalnya, frz_PostedUncunditional2."Employee No. Replacement", frz_PostedUncunditional2."No.");

        // frz_PostedCTORealiz2.Reset();
        // frz_PostedCTORealiz2.SetRange("Employee No. Replacement", EmployeeNo);
        // frz_PostedCTORealiz2.SetFilter("Starting Date", '<=%1', Tanggalnya);
        // frz_PostedCTORealiz2.SetFilter("Ending Date", '>=%1', Tanggalnya);
        // if frz_PostedCTORealiz2.FindSet() then
        //     Error('There is a CTO Realization request for this date = %1, Employee No. = %2' +
        //           ' Please check Document No. = %3.', Tanggalnya, frz_PostedCTORealiz2."Employee No. Replacement", frz_PostedCTORealiz2."No.");


        // frz_Uncunditional.Reset();
        // frz_Uncunditional.SetRange("Employee No.", EmployeeNo);
        // frz_Uncunditional.SetFilter("No.", '<> %1', DocumentNo);
        // frz_Uncunditional.SetFilter("Starting Date", '<=%1', Tanggalnya);
        // frz_Uncunditional.SetFilter("Ending Date", '>=%1', Tanggalnya);
        // if frz_Uncunditional.FindSet() then
        //     Error('There is a unconditional leave request for this date = %1, Employee No. = %2' +
        //           ' Please check Document No. = %3.', Tanggalnya, frz_Uncunditional."Employee No.", frz_Uncunditional."No.");

        // frz_CTORealiz.Reset();
        // frz_CTORealiz.SetRange("Employee No.", EmployeeNo);
        // frz_CTORealiz.SetFilter("No.", '<> %1', DocumentNo);
        // frz_CTORealiz.SetFilter("Starting Date", '<=%1', Tanggalnya);
        // frz_CTORealiz.SetFilter("Ending Date", '>=%1', Tanggalnya);
        // if frz_CTORealiz.FindSet() then
        //     Error('There is a CTO Realization request for this date = %1, Employee No. = %2' +
        //           ' Please check Document No. = %3.', Tanggalnya, frz_CTORealiz."Employee No.", frz_CTORealiz."No.");


        // rec_PayrollGenSetup.FindFirst();
        // rec_BaseCalendar.Reset();
        // rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
        // rec_BaseCalendar.SetRange(Date, Tanggalnya);
        // if rec_BaseCalendar.FindFirst() then begin
        //     if rec_BaseCalendar.Nonworking = true then begin
        //         error('The Date %1 is Weekend or Not Working', Tanggalnya);
        //     end;
        // end else begin
        //     rec_BaseCalendar2.Reset();
        //     rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
        //     rec_BaseCalendar2.SetRange(Day, Date2DWY(Tanggalnya, 1));
        //     rec_BaseCalendar2.SetRange(Date, 0D);
        //     if rec_BaseCalendar2.FindFirst() then
        //         if rec_BaseCalendar2.Nonworking = true then
        //             error('The Date %1 is Weekend or Not Working', Tanggalnya);
        // end;

        // rec_AttendanceLine.Reset();
        // rec_AttendanceLine.SetRange("Employee No.", EmployeeNo);
        // rec_AttendanceLine.SetRange(Date, Tanggalnya);
        // if rec_AttendanceLine.FindFirst() then
        //     if rec_AttendanceLine.Count > 1 then
        //         Error('The same date %1 is already in the value lines.', Tanggalnya);
    end;
}