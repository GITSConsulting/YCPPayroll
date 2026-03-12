report 65000 "PAR"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65000_PAR.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(DataItemEmployee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(ActivityPAR; ActivityPAR) { }
            column(getBulanDepan; getBulanDepan) { }
            column(No_Emplyo; "No.") { }
            column(FullName; FullName) { }
            column(gSpvName; gSpvName) { }
            column(gApprovedBy; gApprovedBy) { }
            column(Office_Location_Code; "Office Location Code") { }
            column(Job_Title; "Job Title") { }
            column(FromDate; FromDate) { }
            column(ToDate; ToDate) { }
            column(week1; week1) { }
            column(week2; week2) { }
            column(week3; week3) { }
            column(week4; week4) { }
            column(week5; week5) { }
            column(week6; week6) { }
            column(weekAwal1; weekAwal[1]) { }
            column(weekAwal2; weekAwal[2]) { }
            column(weekAwal3; weekAwal[3]) { }
            column(weekAwal4; weekAwal[4]) { }
            column(weekAwal5; weekAwal[5]) { }
            column(weekAwal6; weekAwal[6]) { }
            column(totalHoursBottom1; totalHoursBottom[1]) { }
            column(totalMinutesBottom1; totalMinutesBottom[1]) { }
            column(totalHoursBottom2; totalHoursBottom[2]) { }
            column(totalMinutesBottom2; totalMinutesBottom[2]) { }
            column(totalHoursBottom3; totalHoursBottom[3]) { }
            column(totalMinutesBottom3; totalMinutesBottom[3]) { }
            column(totalHoursBottom4; totalHoursBottom[4]) { }
            column(totalMinutesBottom4; totalMinutesBottom[4]) { }
            column(totalHoursBottom5; totalHoursBottom[5]) { }
            column(totalMinutesBottom5; totalMinutesBottom[5]) { }
            column(totalHoursBottom6; totalHoursBottom[6]) { }
            column(totalMinutesBottom6; totalMinutesBottom[6]) { }
            column(TotalMontHoursBot; TotalMontHoursBot) { }
            column(TotalMontMinutesBot; TotalMontMinutesBot) { }
            column(totalLeaveBotHours1; totalLeaveBotHours[1]) { }
            column(totalLeaveBotHours2; totalLeaveBotHours[2]) { }
            column(totalLeaveBotHours3; totalLeaveBotHours[3]) { }
            column(totalLeaveBotHours4; totalLeaveBotHours[4]) { }
            column(totalLeaveBotHours5; totalLeaveBotHours[5]) { }
            column(totalLeaveBotHours6; totalLeaveBotHours[6]) { }
            column(totalLeaveBotMinutes1; totalLeaveBotMinutes[1]) { }
            column(totalLeaveBotMinutes2; totalLeaveBotMinutes[2]) { }
            column(totalLeaveBotMinutes3; totalLeaveBotMinutes[3]) { }
            column(totalLeaveBotMinutes4; totalLeaveBotMinutes[4]) { }
            column(totalLeaveBotMinutes5; totalLeaveBotMinutes[5]) { }
            column(totalLeaveBotMinutes6; totalLeaveBotMinutes[6]) { }
            column(TotalLeaveMonthHours; TotalLeaveMonthHours) { }
            column(TotalLeaveMonthMinutes; TotalLeaveMonthMinutes) { }
            column(AllHours1; AllHours[1]) { }
            column(AllHours2; AllHours[2]) { }
            column(AllHours3; AllHours[3]) { }
            column(AllHours4; AllHours[4]) { }
            column(AllHours5; AllHours[5]) { }
            column(AllHours6; AllHours[6]) { }
            column(AllMinutes1; AllMinutes[1]) { }
            column(AllMinutes2; AllMinutes[2]) { }
            column(AllMinutes3; AllMinutes[3]) { }
            column(AllMinutes4; AllMinutes[4]) { }
            column(AllMinutes5; AllMinutes[5]) { }
            column(AllMinutes6; AllMinutes[6]) { }
            column(keseluruhanAllHours; keseluruhanAllHours) { }
            column(keseluruhanAllMinutes; keseluruhanAllMinutes) { }
            column(TotalPersentaseDisbursh; TotalPersentaseDisbursh) { }
            column(Supervisor_ID; "Supervisor ID") { }
            dataitem("Posted Employee Charging Line"; "Posted Employee Charging Line")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Shortcut_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Employee_No_Charging; "Employee No.") { }
                column(FundCodeTitle; FundCodeTitle) { }
                column(Percentage; Percentage) { }
                column(DescriptionActivity; DescriptionActivity) { }
                column(timeWeek1; _timeWeek1[1]) { }
                column(timeWeek2; _timeWeek1[2]) { }
                column(timeWeek3; _timeWeek1[3]) { }
                column(timeWeek4; _timeWeek1[4]) { }
                column(timeWeek5; _timeWeek1[5]) { }
                column(timeWeek6; _timeWeek1[6]) { }
                column(timeMinutes1; _timeMinutes[1]) { }
                column(timeMinutes2; _timeMinutes[2]) { }
                column(timeMinutes3; _timeMinutes[3]) { }
                column(timeMinutes4; _timeMinutes[4]) { }
                column(timeMinutes5; _timeMinutes[5]) { }
                column(timeMinutes6; _timeMinutes[6]) { }
                column(totalHoursMonth; totalHoursMonth) { }
                column(totalMinutesMonth; totalMinutesMonth) { }
                column(persentaseDis; persentaseDis) { }
                column(Persentasenya; Persentasenya) { }

                trigger OnAfterGetRecord()
                var
                    recEmpAbsenceLine: Record "Employee Absence Line";
                    frz_LeaveHalfDay: Record "Posted Leave Request";
                    Minutes_1: array[10] of Decimal;
                    i2: array[10] of integer;
                    rec_FundCode: Record "Dimension Value";
                    DecimalConvert: array[10] of Decimal;
                    BuangKoma: array[10] of Decimal;
                    // VAR FOR PERCENTAGE DISTRIBUTION
                    minutesConvert: Decimal;
                    TotalTimeWorkdiKurangSejam: Integer;
                begin
                    TotalTimeWorkdiKurangSejam := 0;
                    DecimalConvert[1] := 0;
                    DecimalConvert[2] := 0;
                    DecimalConvert[3] := 0;
                    DecimalConvert[4] := 0;
                    DecimalConvert[5] := 0;
                    DecimalConvert[6] := 0;
                    BuangKoma[1] := 0;
                    BuangKoma[2] := 0;
                    BuangKoma[3] := 0;
                    BuangKoma[4] := 0;
                    BuangKoma[5] := 0;
                    BuangKoma[6] := 0;
                    _timeWeek1[1] := 0;
                    _timeWeek1[2] := 0;
                    _timeWeek1[3] := 0;
                    _timeWeek1[4] := 0;
                    _timeWeek1[5] := 0;
                    _timeWeek1[6] := 0;
                    _timeMinutes[1] := 0;
                    _timeMinutes[2] := 0;
                    _timeMinutes[3] := 0;
                    _timeMinutes[4] := 0;
                    _timeMinutes[5] := 0;
                    _timeMinutes[6] := 0;
                    // get project title 
                    rec_FundCode.SetRange("Dimension Code", 'FUND CODE');
                    rec_FundCode.SetRange(Code, "Global Dimension 1 Code");
                    if rec_FundCode.FindFirst() then
                        FundCodeTitle := rec_FundCode.Name;

                    Minutes_1[1] := 0;
                    Minutes_1[2] := 0;
                    Minutes_1[3] := 0;
                    Minutes_1[4] := 0;
                    Minutes_1[5] := 0;
                    Minutes_1[6] := 0;

                    timeWeek1[1] := 0;
                    timeWeek1[2] := 0;
                    timeWeek1[3] := 0;
                    timeWeek1[4] := 0;
                    timeWeek1[5] := 0;
                    timeWeek1[6] := 0;

                    i2[1] := 1;
                    i2[2] := 2;
                    i2[3] := 3;
                    i2[4] := 4;
                    i2[5] := 5;
                    i2[6] := 6;

                    _totalHoursMonth := 0;
                    _totalMinutesMonth := 0;
                    totalHoursMonth := 0;
                    totalMinutesMonth := 0;

                    // frz_LeaveHalfDay.Reset();
                    // frz_LeaveHalfDay.SetRange("Starting Date", FromDate, ToDate);
                    // frz_LeaveHalfDay.SetRange("Total Number of Days", 0.5);
                    // frz_LeaveHalfDay.SetRange(Reversed, false);
                    // if frz_LeaveHalfDay.FindFirst() then begin

                    // end;

                    recEmpAbsenceLine.Reset();
                    recEmpAbsenceLine.SetRange(date, FromDate, ToDate);
                    recEmpAbsenceLine.SetRange("Employee No.", DataItemEmployee."No.");
                    if recEmpAbsenceLine.FindFirst() then begin
                        repeat
                            if recEmpAbsenceLine."Total Duration Hours" > 0 then
                                TotalTimeWorkdiKurangSejam := recEmpAbsenceLine."Total Duration Hours" - 1;

                            DescriptionActivity := recEmpAbsenceLine."Activity Description";
                            // _totalHoursMonth += recEmpAbsenceLine."Total Duration Hours";
                            // _totalMinutesMonth += recEmpAbsenceLine."Total Duration Minutes";
                            if recEmpAbsenceLine.Date <= week1 then begin
                                timeWeek1[1] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[1] += recEmpAbsenceLine."Total Duration Minutes";
                                // totalTime(i2[1], timeWeek1[1], Minutes_1[1]);
                            end;
                            if (recEmpAbsenceLine.Date > week1) AND (recEmpAbsenceLine.Date <= week2) then begin
                                timeWeek1[2] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[2] += recEmpAbsenceLine."Total Duration Minutes";
                                // totalTime(i2[2], timeWeek1[2], Minutes_1[2]);
                            end;
                            if (recEmpAbsenceLine.Date > week2) AND (recEmpAbsenceLine.Date <= week3) then begin
                                timeWeek1[3] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[3] += recEmpAbsenceLine."Total Duration Minutes";
                                // totalTime(i2[3], timeWeek1[3], Minutes_1[3]);
                            end;
                            if (recEmpAbsenceLine.Date > week3) AND (recEmpAbsenceLine.Date <= week4) then begin
                                timeWeek1[4] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[4] += recEmpAbsenceLine."Total Duration Minutes";
                                // totalTime(i2[4], timeWeek1[4], Minutes_1[4]);
                            end;
                            if (recEmpAbsenceLine.Date > week4) AND (recEmpAbsenceLine.Date <= week5) then begin
                                timeWeek1[5] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[5] += recEmpAbsenceLine."Total Duration Minutes";
                                // totalTime(i2[5], timeWeek1[5], Minutes_1[5]);
                            end;
                            if week5 < CalcDate('CM', Bulan) then
                                if (recEmpAbsenceLine.Date > week5) AND (recEmpAbsenceLine.Date <= week6) then begin
                                    timeWeek1[6] += TotalTimeWorkdiKurangSejam;
                                    Minutes_1[6] += recEmpAbsenceLine."Total Duration Minutes";
                                    // totalTime(i2[6], timeWeek1[6], Minutes_1[6]);
                                end;
                        until recEmpAbsenceLine.Next = 0;

                        DecimalConvert[1] := (((timeWeek1[1] * 60) + Minutes_1[1]) * (Percentage / 100)) / 60;
                        DecimalConvert[2] := (((timeWeek1[2] * 60) + Minutes_1[2]) * (Percentage / 100)) / 60;
                        DecimalConvert[3] := (((timeWeek1[3] * 60) + Minutes_1[3]) * (Percentage / 100)) / 60;
                        DecimalConvert[4] := (((timeWeek1[4] * 60) + Minutes_1[4]) * (Percentage / 100)) / 60;
                        DecimalConvert[5] := (((timeWeek1[5] * 60) + Minutes_1[5]) * (Percentage / 100)) / 60;
                        DecimalConvert[6] := (((timeWeek1[6] * 60) + Minutes_1[6]) * (Percentage / 100)) / 60;
                        _timeWeek1[1] := Round(DecimalConvert[1], 1, '<');
                        _timeMinutes[1] := (((timeWeek1[1] * 60) + Minutes_1[1]) * (Percentage / 100)) - (_timeWeek1[1] * 60);
                        _timeWeek1[2] := Round(DecimalConvert[2], 1, '<');
                        _timeMinutes[2] := (((timeWeek1[2] * 60) + Minutes_1[2]) * (Percentage / 100)) - (_timeWeek1[2] * 60);
                        _timeWeek1[3] := Round(DecimalConvert[3], 1, '<');
                        _timeMinutes[3] := (((timeWeek1[3] * 60) + Minutes_1[3]) * (Percentage / 100)) - (_timeWeek1[3] * 60);
                        _timeWeek1[4] := Round(DecimalConvert[4], 1, '<');
                        _timeMinutes[4] := (((timeWeek1[4] * 60) + Minutes_1[4]) * (Percentage / 100)) - (_timeWeek1[4] * 60);
                        _timeWeek1[5] := Round(DecimalConvert[5], 1, '<');
                        _timeMinutes[5] := (((timeWeek1[5] * 60) + Minutes_1[5]) * (Percentage / 100)) - (_timeWeek1[5] * 60);
                        _timeWeek1[6] := Round(DecimalConvert[6], 1, '<');
                        _timeMinutes[6] := (((timeWeek1[6] * 60) + Minutes_1[6]) * (Percentage / 100)) - (_timeWeek1[6] * 60);
                        _totalHoursMonth := _timeWeek1[1] + _timeWeek1[2] + _timeWeek1[3] + _timeWeek1[4] + _timeWeek1[5] + _timeWeek1[6];
                        _totalMinutesMonth := _timeMinutes[1] + _timeMinutes[2] + _timeMinutes[3] + _timeMinutes[4] + _timeMinutes[5] + _timeMinutes[6];
                        totalTimeMonth(_totalHoursMonth, _totalMinutesMonth);
                    end;
                    Persentasenya := 0;
                    Persentasenya := (((_totalHoursMonth * 60) + _totalMinutesMonth) / ((keseluruhanAllHours * 60) + keseluruhanAllMinutes)) * 100;
                    Persentasenya := round(Persentasenya, 0.01, '=');

                    // PERCENTAGE DISTRIBUTION
                    minutesConvert := 0;
                    persentaseDis := 0;

                    minutesConvert := totalMinutesMonth / 100;
                    minutesConvertAll := keseluruhanAllMinutes / 100;
                    persentaseDis := (totalHoursMonth + minutesConvert) / (keseluruhanAllHours + minutesConvertAll) * 100;

                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", Bulan);
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(Number; Number) { }
                column(DocNo; DocNo) { }
                column(LeaveType; frz_PostedLeaveTemporaryHeader."Leave Type") { }
                column(LeaveTypeCode; frz_PostedLeaveTemporaryHeader."Leave Type Code") { }
                column(StartingDate; frz_PostedLeaveTemporaryHeader."Starting Date") { }
                column(EndingDate; frz_PostedLeaveTemporaryHeader."Ending Date") { }
                column(TotalDays; frz_PostedLeaveTemporaryHeader."Total Number of Days") { }
                column(leaveWeek1; leaveWeek[1]) { }
                column(leaveWeek2; leaveWeek[2]) { }
                column(leaveWeek3; leaveWeek[3]) { }
                column(leaveWeek4; leaveWeek[4]) { }
                column(leaveWeek5; leaveWeek[5]) { }
                column(leaveWeek6; leaveWeek[6]) { }
                column(leaveWeekMinutes1; leaveWeekMinutes[1]) { }
                column(leaveWeekMinutes2; leaveWeekMinutes[2]) { }
                column(leaveWeekMinutes3; leaveWeekMinutes[3]) { }
                column(leaveWeekMinutes4; leaveWeekMinutes[4]) { }
                column(leaveWeekMinutes5; leaveWeekMinutes[5]) { }
                column(leaveWeekMinutes6; leaveWeekMinutes[6]) { }
                column(totalLeaveHoursBln; totalLeaveHoursBln) { }
                column(totalLeaveMinutesBln; totalLeaveMinutesBln) { }
                column(persentaseDis2; persentaseDis2) { }
                trigger OnAfterGetRecord()
                var
                    i3: array[10] of Integer;
                    Hours_2: array[10] of Decimal;
                    Minutes_2: array[10] of Decimal;
                    HoursBulan: decimal;
                    MinutesBulan: decimal;
                    MinutesConvertLeave: decimal;
                begin
                    IF Number = 1 THEN
                        frz_PostedLeaveTemporaryHeader.FINDFIRST
                    ELSE
                        frz_PostedLeaveTemporaryHeader.NEXT;

                    DocNo := frz_PostedLeaveTemporaryHeader."No.";

                    i3[1] := 1;
                    i3[2] := 2;
                    i3[3] := 3;
                    i3[4] := 4;
                    i3[5] := 5;
                    i3[6] := 5;

                    leaveWeek[1] := 0;
                    leaveWeek[2] := 0;
                    leaveWeek[3] := 0;
                    leaveWeek[4] := 0;
                    leaveWeek[5] := 0;
                    leaveWeek[6] := 0;

                    leaveWeekMinutes[1] := 0;
                    leaveWeekMinutes[2] := 0;
                    leaveWeekMinutes[3] := 0;
                    leaveWeekMinutes[4] := 0;
                    leaveWeekMinutes[5] := 0;
                    leaveWeekMinutes[6] := 0;

                    Minutes_2[1] := 0;
                    Minutes_2[2] := 0;
                    Minutes_2[3] := 0;
                    Minutes_2[4] := 0;
                    Minutes_2[5] := 0;

                    Hours_2[1] := 0;
                    Hours_2[2] := 0;
                    Hours_2[3] := 0;
                    Hours_2[4] := 0;
                    Hours_2[5] := 0;

                    // HoursBulan := lamaJam;
                    // MinutesBulan := lamaMenit;
                    // totalLeaveBulan(HoursBulan, MinutesBulan);

                    if frz_PostedLeaveTemporaryHeader."Starting Date" <= week1 then begin
                        if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                            Hours_2[1] := lamaJam / 2;
                            Minutes_2[1] := lamaMenit / 2;
                        end else begin
                            Hours_2[1] := lamaJam;
                            Minutes_2[1] := lamaMenit;
                        end;
                        totalWeekLeave(i3[1], Hours_2[1], Minutes_2[1]);
                    end;
                    if (frz_PostedLeaveTemporaryHeader."Starting Date" > week1) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week2) then begin
                        if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                            Hours_2[2] := lamaJam / 2;
                            Minutes_2[2] := lamaMenit / 2;
                        end else begin
                            Hours_2[2] := lamaJam;
                            Minutes_2[2] := lamaMenit;
                        end;
                        totalWeekLeave(i3[2], Hours_2[2], Minutes_2[2]);
                    end;
                    if (frz_PostedLeaveTemporaryHeader."Starting Date" > week2) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week3) then begin
                        if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                            Hours_2[3] := lamaJam / 2;
                            Minutes_2[3] := lamaMenit / 2;
                        end else begin
                            Hours_2[3] := lamaJam;
                            Minutes_2[3] := lamaMenit;
                        end;
                        totalWeekLeave(i3[3], Hours_2[3], Minutes_2[3]);
                    end;
                    if (frz_PostedLeaveTemporaryHeader."Starting Date" > week3) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week4) then begin
                        if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                            Hours_2[4] := lamaJam / 2;
                            Minutes_2[4] := lamaMenit / 2;
                        end else begin
                            Hours_2[4] := lamaJam;
                            Minutes_2[4] := lamaMenit;
                        end;
                        totalWeekLeave(i3[4], Hours_2[4], Minutes_2[4]);
                    end;
                    if (frz_PostedLeaveTemporaryHeader."Starting Date" > week4) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week5) then begin
                        if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                            Hours_2[5] := lamaJam / 2;
                            Minutes_2[5] := lamaMenit / 2;
                        end else begin
                            Hours_2[5] := lamaJam;
                            Minutes_2[5] := lamaMenit;
                        end;
                        totalWeekLeave(i3[5], Hours_2[5], Minutes_2[5]);
                    end;
                    if week5 < CalcDate('CM', Bulan) then
                        if (frz_PostedLeaveTemporaryHeader."Starting Date" > week5) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week6) then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                Hours_2[6] := lamaJam / 2;
                                Minutes_2[6] := lamaMenit / 2;
                            end else begin
                                Hours_2[6] := lamaJam;
                                Minutes_2[6] := lamaMenit;
                            end;
                            totalWeekLeave(i3[6], Hours_2[6], Minutes_2[6]);
                        end;

                    HoursBulan := Hours_2[1] + Hours_2[2] + Hours_2[3] + Hours_2[4] + Hours_2[5] + Hours_2[6];
                    MinutesBulan := Minutes_2[1] + Minutes_2[2] + Minutes_2[3] + Minutes_2[4] + Minutes_2[5] + Minutes_2[6];
                    totalLeaveBulan(HoursBulan, MinutesBulan);
                    // PERCENTAGE DISTRIBUTION
                    MinutesConvertLeave := totalLeaveMinutesBln / 100;
                    minutesConvertAll := keseluruhanAllMinutes / 100;
                    persentaseDis2 := (((totalLeaveHoursBln * 60) + totalLeaveMinutesBln) / ((keseluruhanAllHours * 60) + keseluruhanAllMinutes)) * 100;
                    persentaseDis2 := round(persentaseDis2, 0.01, '=');
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, frz_PostedLeaveTemporaryHeader.Count);
                end;
            }
            trigger OnAfterGetRecord()
            var
                recLeaveRequest: Record "Posted Leave Request";
                Leavehours: Decimal;
                LeaveMinutes: Decimal;
                hourseLeave: array[10] of Decimal;
                minutesLeave: array[10] of Decimal;
                // absence line
                recEmpAbsenceLine2: Record "Employee Absence Line";
                Minutes_1: array[10] of Decimal;
                Hours_1: array[10] of Decimal;
                _totalHoursMonthBot: Decimal;
                _totalMinutesMonthBot: Decimal;
                i: array[10] of integer;
                // total all 
                keseluruhanJam: decimal;
                keseluruhanMenit: decimal;
                TotalTimeWorkdiKurangSejam: Integer;
                frz_PayrollGenSetup: Record "Payroll General Setup";
                AbsenceManage: Codeunit "Employee Absence Management";
                TotalAllMinutesPersentase: Decimal;
                TotalMasukMinutesPersentase: Decimal;

                frz_Dimension: Record "Dimension Value";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                TotalTimeWorkdiKurangSejam := 0;

                hourseLeave[1] := 0;
                hourseLeave[2] := 0;
                hourseLeave[3] := 0;
                hourseLeave[4] := 0;
                hourseLeave[5] := 0;
                hourseLeave[6] := 0;

                minutesLeave[1] := 0;
                minutesLeave[2] := 0;
                minutesLeave[3] := 0;
                minutesLeave[4] := 0;
                minutesLeave[5] := 0;
                minutesLeave[6] := 0;

                Hours_1[1] := 0;
                Hours_1[2] := 0;
                Hours_1[3] := 0;
                Hours_1[4] := 0;
                Hours_1[5] := 0;
                Hours_1[6] := 0;

                Minutes_1[1] := 0;
                Minutes_1[2] := 0;
                Minutes_1[3] := 0;
                Minutes_1[4] := 0;
                Minutes_1[5] := 0;
                Minutes_1[6] := 0;

                i[1] := 1;
                i[2] := 2;
                i[3] := 3;
                i[4] := 4;
                i[5] := 5;
                i[6] := 6;

                weekAwal[1] := CalcDate('-CM', week1);
                weekAwal[2] := CalcDate('+1D', week1);
                weekAwal[3] := CalcDate('+1D', week2);
                weekAwal[4] := CalcDate('+1D', week3);
                weekAwal[5] := CalcDate('+1D', week4);
                if week5 < CalcDate('CM', Bulan) then
                    weekAwal[6] := CalcDate('+1D', week5);

                totalLeaveBotHours[1] := 0;
                totalLeaveBotHours[2] := 0;
                totalLeaveBotHours[3] := 0;
                totalLeaveBotHours[4] := 0;
                totalLeaveBotHours[5] := 0;
                totalLeaveBotHours[6] := 0;

                totalLeaveBotMinutes[1] := 0;
                totalLeaveBotMinutes[2] := 0;
                totalLeaveBotMinutes[3] := 0;
                totalLeaveBotMinutes[4] := 0;
                totalLeaveBotMinutes[5] := 0;
                totalLeaveBotMinutes[6] := 0;

                getBulanDepan := CalcDate('1M', Bulan);

                frz_PayrollGenSetup.FindSet();
                // if DataItemEmployee."MSI_HRIS Shift Schedule" = false then begin
                AbsenceManage.hitungDurasiAbsence(frz_PayrollGenSetup."Working Start", frz_PayrollGenSetup."Working Out", lamaJam, lamaMenit);
                lamaJam := lamaJam - 1;
                // end else begin
                //     if DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Guard" then begin
                //         // ---- //
                //         lamaJam := lamaJam - 1;
                //     end;
                //     if DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Office Helper" then begin
                //         // ---- //
                //         lamaJam := lamaJam - 1;
                //     end;
                // end;
                //leave baru
                insertDateTemporaryLeave(DataItemEmployee."No.", FromDate, ToDate);
                //leave baru tutup

                frz_Dimension.Reset();
                frz_Dimension.SetRange(Code, DataItemEmployee."MSI_HRIS Department");
                frz_Dimension.SetRange("Dimension Code", frz_PayrollGenSetup.Department);
                if frz_Dimension.FindFirst() then begin
                    ActivityPAR := format(frz_Dimension."MSI_HRIS Activity PAR");
                end;


                if frz_PostedLeaveTemporaryHeader.FindFirst() then begin
                    repeat
                        Leavehours += lamaJam;
                        LeaveMinutes += lamaMenit;
                        totalMonthLeave(Leavehours, LeaveMinutes);
                        if frz_PostedLeaveTemporaryHeader."Starting Date" <= week1 then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                hourseLeave[1] += lamaJam / 2;
                                minutesLeave[1] += lamaMenit / 2;
                            end else begin
                                hourseLeave[1] += lamaJam;
                                minutesLeave[1] += lamaMenit;
                            end;
                            totalWeekBottomLeave(i[1], hourseLeave[1], minutesLeave[1]);
                        end;
                        if (frz_PostedLeaveTemporaryHeader."Starting Date" > week1) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week2) then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                minutesLeave[2] += lamaMenit / 2;
                                hourseLeave[2] += lamaJam / 2;
                            end else begin
                                minutesLeave[2] += lamaMenit;
                                hourseLeave[2] += lamaJam;
                            end;
                            totalWeekBottomLeave(i[2], hourseLeave[2], minutesLeave[2]);
                        end;
                        if (frz_PostedLeaveTemporaryHeader."Starting Date" > week2) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week3) then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                minutesLeave[3] += lamaMenit / 2;
                                hourseLeave[3] += lamaJam / 2;
                            end else begin
                                minutesLeave[3] += lamaMenit;
                                hourseLeave[3] += lamaJam;
                            end;
                            totalWeekBottomLeave(i[3], hourseLeave[3], minutesLeave[3]);
                        end;
                        if (frz_PostedLeaveTemporaryHeader."Starting Date" > week3) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week4) then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                minutesLeave[4] += lamaMenit / 2;
                                hourseLeave[4] += lamaJam / 2;
                                // Message('hai = %1 = %2', lamaJam / 2, frz_PostedLeaveTemporaryHeader."Total Number of Days");
                            end else begin
                                minutesLeave[4] += lamaMenit;
                                hourseLeave[4] += lamaJam;
                            end;
                            totalWeekBottomLeave(i[4], hourseLeave[4], minutesLeave[4]);
                        end;
                        if (frz_PostedLeaveTemporaryHeader."Starting Date" > week4) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week5) then begin
                            if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                minutesLeave[5] += (lamaMenit / 2);
                                hourseLeave[5] += (lamaJam / 2);
                            end else begin
                                minutesLeave[5] += lamaMenit;
                                hourseLeave[5] += lamaJam;
                            end;
                            totalWeekBottomLeave(i[5], hourseLeave[5], minutesLeave[5]);
                        end;
                        if week5 < CalcDate('CM', Bulan) then
                            if (frz_PostedLeaveTemporaryHeader."Starting Date" > week5) AND (frz_PostedLeaveTemporaryHeader."Starting Date" <= week6) then begin
                                if frz_PostedLeaveTemporaryHeader."Total Number of Days" = 0.5 then begin
                                    minutesLeave[6] += lamaMenit / 2;
                                    hourseLeave[6] += lamaJam / 2;
                                end else begin
                                    minutesLeave[6] += lamaMenit;
                                    hourseLeave[6] += lamaJam;
                                end;
                                totalWeekBottomLeave(i[6], hourseLeave[6], minutesLeave[6]);
                            end;

                    until frz_PostedLeaveTemporaryHeader.Next = 0;

                end;
                // employee attendance line
                recEmpAbsenceLine2.Reset();
                recEmpAbsenceLine2.SetRange("Employee No.", "No.");
                recEmpAbsenceLine2.SetRange(date, FromDate, ToDate);
                if recEmpAbsenceLine2.FindFirst() then begin
                    repeat
                        if recEmpAbsenceLine2."Total Duration Hours" > 0 then
                            TotalTimeWorkdiKurangSejam := recEmpAbsenceLine2."Total Duration Hours" - 1;

                        _totalHoursMonthBot += TotalTimeWorkdiKurangSejam;
                        _totalMinutesMonthBot += recEmpAbsenceLine2."Total Duration Minutes";
                        totalTimeMonthBottom(_totalHoursMonthBot, _totalMinutesMonthBot);
                        if recEmpAbsenceLine2.date <= week1 then begin
                            Hours_1[1] += TotalTimeWorkdiKurangSejam;
                            Minutes_1[1] += recEmpAbsenceLine2."Total Duration Minutes";
                            totalTimeBottom(i[1], Hours_1[1], Minutes_1[1]);
                        end;
                        if (recEmpAbsenceLine2.Date > week1) AND (recEmpAbsenceLine2.Date <= week2) then begin
                            Hours_1[2] += TotalTimeWorkdiKurangSejam;
                            Minutes_1[2] += recEmpAbsenceLine2."Total Duration Minutes";
                            totalTimeBottom(i[2], Hours_1[2], Minutes_1[2]);
                        end;
                        if (recEmpAbsenceLine2.Date > week2) AND (recEmpAbsenceLine2.Date <= week3) then begin
                            Hours_1[3] += TotalTimeWorkdiKurangSejam;
                            Minutes_1[3] += recEmpAbsenceLine2."Total Duration Minutes";
                            totalTimeBottom(i[3], Hours_1[3], Minutes_1[3]);
                        end;
                        if (recEmpAbsenceLine2.Date > week3) AND (recEmpAbsenceLine2.Date <= week4) then begin
                            Hours_1[4] += TotalTimeWorkdiKurangSejam;
                            Minutes_1[4] += recEmpAbsenceLine2."Total Duration Minutes";
                            totalTimeBottom(i[4], Hours_1[4], Minutes_1[4]);
                        end;
                        if (recEmpAbsenceLine2.Date > week4) AND (recEmpAbsenceLine2.Date <= week5) then begin
                            Hours_1[5] += TotalTimeWorkdiKurangSejam;
                            Minutes_1[5] += recEmpAbsenceLine2."Total Duration Minutes";
                            totalTimeBottom(i[5], Hours_1[5], Minutes_1[5]);
                        end;
                        if week5 < CalcDate('CM', Bulan) then
                            if (recEmpAbsenceLine2.Date > week5) AND (recEmpAbsenceLine2.Date <= week6) then begin
                                Hours_1[6] += TotalTimeWorkdiKurangSejam;
                                Minutes_1[6] += recEmpAbsenceLine2."Total Duration Minutes";
                                totalTimeBottom(i[6], Hours_1[6], Minutes_1[6]);
                            end;
                    until recEmpAbsenceLine2.Next = 0;
                end;
                // total paling bawah
                totalAllHours[1] := totalHoursBottom[1] + totalLeaveBotHours[1];
                totalAllMinutes[1] := totalMinutesBottom[1] + totalLeaveBotMinutes[1];
                totalAll(i[1], totalAllHours[1], totalAllMinutes[1]);
                totalAllHours[2] := totalHoursBottom[2] + totalLeaveBotHours[2];
                totalAllMinutes[2] := totalMinutesBottom[2] + totalLeaveBotMinutes[2];
                totalAll(i[2], totalAllHours[2], totalAllMinutes[2]);
                totalAllHours[3] := totalHoursBottom[3] + totalLeaveBotHours[3];
                totalAllMinutes[3] := totalMinutesBottom[3] + totalLeaveBotMinutes[3];
                totalAll(i[3], totalAllHours[3], totalAllMinutes[3]);
                totalAllHours[4] := totalHoursBottom[4] + totalLeaveBotHours[4];
                totalAllMinutes[4] := totalMinutesBottom[4] + totalLeaveBotMinutes[4];
                totalAll(i[4], totalAllHours[4], totalAllMinutes[4]);
                totalAllHours[5] := totalHoursBottom[5] + totalLeaveBotHours[5];
                totalAllMinutes[5] := totalMinutesBottom[5] + totalLeaveBotMinutes[5];
                totalAll(i[5], totalAllHours[5], totalAllMinutes[5]);
                // keseluruhan total
                keseluruhanJam := TotalMontHoursBot + TotalLeaveMonthHours;
                keseluruhanMenit := TotalMontMinutesBot + TotalLeaveMonthMinutes;
                totalKeseluruhan(keseluruhanJam, keseluruhanMenit);

                TotalMasukMinutesPersentase := (TotalMontHoursBot * 60) + TotalMontMinutesBot;
                TotalAllMinutesPersentase := (keseluruhanAllHours * 60) + keseluruhanAllMinutes;

                if TotalAllMinutesPersentase > 0 then
                    TotalPersentaseDisbursh := Round((TotalMasukMinutesPersentase / TotalAllMinutesPersentase) * 100, 0.01, '=') else
                    TotalPersentaseDisbursh := 0;
            end;

            trigger OnPreDataItem()
            var
                _Employee: Record Employee;
                _User: Record User;
            begin
                FromDate := CalcDate('-CM', Bulan);
                ToDate := CalcDate('CM', Bulan);
                // procedure get month
                selectBln(FromDate);
                if _Employee.Get("No.") then begin
                    if _User.Get(_Employee."Supervisor ID") then
                        gSpvName := _User."User Name";
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(Bulan; Bulan)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter Month';
                    }
                    field(gApprovedBy; gApprovedBy)
                    {
                        ApplicationArea = All;
                        Caption = 'Approved By';
                    }
                }
            }
        }
    }

    var
        // ATTENDANCE VARIABLE
        ActivityPAR: Text;
        lamaJam: Integer;
        lamaMenit: Integer;
        frz_PostedLeaveTemporaryHeader: Record "Posted Leave Request" temporary;
        DescriptionActivity, gSpvName, gApprovedBy : text;
        timeWeek1: array[10] of Decimal;
        _timeWeek1: array[10] of Decimal;
        _totalHoursMonth: Decimal;
        _totalMinutesMonth: Decimal;
        totalHoursMonth: Decimal;
        totalMinutesMonth: Decimal;
        _timeMinutes: array[10] of Decimal;
        totalHoursBottom: array[10] of decimal;
        totalMinutesBottom: array[10] of decimal;
        TotalMontHoursBot: Decimal;
        TotalMontMinutesBot: Decimal;
        FundCodeTitle: Text;
        // var for time week
        // get month
        Bulan: Date;
        DocNo: Code[50];
        FromDate: Date;
        ToDate: Date;
        CompanyInformation: Record "Company Information";
        // filter week
        weekAwal: array[10] of date;
        week1: Date;
        week2: date;
        week3: date;
        week4: date;
        week5: date;
        week6: date;
        // POSTED LEAVE REQUEST VARIABLE
        // var leave employee
        leaveWeek: array[10] of Decimal;
        leaveWeekMinutes: array[10] of Decimal;
        TotalLeaveMonthHours: Decimal;
        TotalLeaveMonthMinutes: Decimal;
        totalLeaveBotHours: array[10] of decimal;
        totalLeaveBotMinutes: array[10] of decimal;
        totalAllHours: array[10] of Decimal;
        totalAllMinutes: array[10] of Decimal;
        AllHours: array[10] of Decimal;
        AllMinutes: array[10] of Decimal;
        keseluruhanAllHours: Decimal;
        keseluruhanAllMinutes: Decimal;
        // g1
        totalLeaveHoursBln: decimal;
        totalLeaveMinutesBln: decimal;
        // PERCENTAGE DISTRIBUTION
        minutesConvertAll: Decimal;
        persentaseDis: Decimal;
        persentaseDis2: Decimal;
        getBulanDepan: date;
        TotalPersentaseDisbursh: Decimal;
        Persentasenya: Decimal;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    // get localprocedure
    local procedure selectBln(DatePro: Date): Date;
    var
        bulanKe: Integer;
    begin
        bulanKe := Date2DMY(DatePro, 2);
        case bulanKe of
            1:
                exit(bln1(DatePro));
            2:
                exit(bln2(DatePro));
            3:
                exit(bln3(DatePro));
            4:
                exit(bln4(DatePro));
            5:
                exit(bln5(DatePro));
            6:
                exit(bln6(DatePro));
            7:
                exit(bln7(DatePro));
            8:
                exit(bln8(DatePro));
            9:
                exit(bln9(DatePro));
            10:
                exit(bln10(DatePro));
            11:
                exit(bln11(DatePro));
            12:
                exit(bln12(DatePro));
        end;
    end;

    local procedure bln1(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 01, paramInteger);
        week2 := DMY2Date(paramHari + 7, 01, paramInteger);
        week3 := DMY2Date(paramHari + 14, 01, paramInteger);
        week4 := DMY2Date(paramHari + 21, 01, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln2(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
        // khusus februari
        tahun: Decimal;
        tahunBulat: Decimal;
        hasilBagi: Decimal;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 02, paramInteger);
        week2 := DMY2Date(paramHari + 7, 02, paramInteger);
        week3 := DMY2Date(paramHari + 14, 02, paramInteger);
        week4 := DMY2Date(paramHari + 21, 02, paramInteger);
        week5 := CalcDate('CM', param);
    end;

    local procedure bln3(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 03, paramInteger);
        week2 := DMY2Date(paramHari + 7, 03, paramInteger);
        week3 := DMY2Date(paramHari + 14, 03, paramInteger);
        week4 := DMY2Date(paramHari + 21, 03, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln4(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 04, paramInteger);
        week2 := DMY2Date(paramHari + 7, 04, paramInteger);
        week3 := DMY2Date(paramHari + 14, 04, paramInteger);
        week4 := DMY2Date(paramHari + 21, 04, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln5(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 05, paramInteger);
        week2 := DMY2Date(paramHari + 7, 05, paramInteger);
        week3 := DMY2Date(paramHari + 14, 05, paramInteger);
        week4 := DMY2Date(paramHari + 21, 05, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln6(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 06, paramInteger);
        week2 := DMY2Date(paramHari + 7, 06, paramInteger);
        week3 := DMY2Date(paramHari + 14, 06, paramInteger);
        week4 := DMY2Date(paramHari + 21, 06, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln7(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 07, paramInteger);
        week2 := DMY2Date(paramHari + 7, 07, paramInteger);
        week3 := DMY2Date(paramHari + 14, 07, paramInteger);
        week4 := DMY2Date(paramHari + 21, 07, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln8(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 08, paramInteger);
        week2 := DMY2Date(paramHari + 7, 08, paramInteger);
        week3 := DMY2Date(paramHari + 14, 08, paramInteger);
        week4 := DMY2Date(paramHari + 21, 08, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln9(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 09, paramInteger);
        week2 := DMY2Date(paramHari + 7, 09, paramInteger);
        week3 := DMY2Date(paramHari + 14, 09, paramInteger);
        week4 := DMY2Date(paramHari + 21, 09, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln10(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 10, paramInteger);
        week2 := DMY2Date(paramHari + 7, 10, paramInteger);
        week3 := DMY2Date(paramHari + 14, 10, paramInteger);
        week4 := DMY2Date(paramHari + 21, 10, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln11(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
        frz_Date: Record Date;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 11, paramInteger);
        week2 := DMY2Date(paramHari + 7, 11, paramInteger);
        week3 := DMY2Date(paramHari + 14, 11, paramInteger);
        week4 := DMY2Date(paramHari + 21, 11, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end;
    end;

    local procedure bln12(param: Date): date;
    var
        paramInteger: Integer;
        paramHarike: integer;
        paramHari: Integer;
    begin
        paramInteger := Date2DMY(param, 3);
        paramHarike := Date2DWY(param, 1);
        paramHari := findDay(paramHarike);
        week1 := DMY2Date(paramHari, 12, paramInteger);
        week2 := DMY2Date(paramHari + 7, 12, paramInteger);
        week3 := DMY2Date(paramHari + 14, 12, paramInteger);
        week4 := DMY2Date(paramHari + 21, 12, paramInteger);
        if CalcDate('+28D', week1) >= CalcDate('CM', param) then
            week5 := CalcDate('CM', param) else begin
            week5 := DMY2Date(paramHari + 28, 01, paramInteger);
            week6 := CalcDate('CM', param);
        end
    end;

    local procedure findDay(param: Integer): integer;
    begin
        case
            param of
            1:
                exit(7);
            2:
                exit(6);
            3:
                exit(5);
            4:
                exit(4);
            5:
                exit(3);
            6:
                exit(2);
            7:
                exit(8);
        end;
    end;

    local procedure totalLeaveBulan(var _Hours: decimal; _Minutes: decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
        _gettotaljambulatText: text;
        _gettotaljambulatDecimal: Decimal;
        _getMinutesJamDecimal: Decimal;
    begin
        // MENCARI NILAI KOMA PADA _Hours
        _gettotaljambulatDecimal := 0;
        _getMinutesJamDecimal := 0;
        if _Hours < 10 then
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10) else
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10);
        Evaluate(_gettotaljambulatDecimal, _gettotaljambulatText);
        _getMinutesJamDecimal := _Hours - _gettotaljambulatDecimal;
        _Minutes += (_getMinutesJamDecimal * 60);
        _Hours := _gettotaljambulatDecimal;

        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes > 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKIHR
        totalLeaveHoursBln := _Hours + Round(_jumlahJam, 1, '<');
        totalLeaveMinutesBln := _jumlahMenit;
    end;
    // totalKeseluruhan
    local procedure totalKeseluruhan(var _Hours: decimal; _Minutes: decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        keseluruhanAllHours := _Hours + Round(_jumlahJam, 1, '<');
        keseluruhanAllMinutes := _jumlahMenit;
    end;
    // total keseluruhan 
    local procedure totalAll(var i: integer; _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        AllHours[i] := _Hours + Round(_jumlahJam, 1, '<');
        AllMinutes[i] := _jumlahMenit;
    end;

    // total week bottom leave
    local procedure totalWeekBottomLeave(var i: integer; _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
        _gettotaljambulatText: text;
        _gettotaljambulatDecimal: Decimal;
        _getMinutesJamDecimal: Decimal;
    begin
        // MENCARI NILAI KOMA PADA _Hours
        _gettotaljambulatDecimal := 0;
        _getMinutesJamDecimal := 0;
        if _Hours < 10 then
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10) else
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10);
        Evaluate(_gettotaljambulatDecimal, _gettotaljambulatText);
        _getMinutesJamDecimal := _Hours - _gettotaljambulatDecimal;
        _Minutes += (_getMinutesJamDecimal * 60);
        _Hours := _gettotaljambulatDecimal;
        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        totalLeaveBotHours[i] := _Hours + Round(_jumlahJam, 1, '<');
        totalLeaveBotMinutes[i] := _jumlahMenit;
    end;

    // total month
    local procedure totalMonthLeave(var _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        TotalLeaveMonthHours := _Hours + Round(_jumlahJam, 1, '<');
        TotalLeaveMonthMinutes := _jumlahMenit;
    end;

    // total week leave
    local procedure totalWeekLeave(var i: integer; _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
        _gettotaljambulatText: text;
        _gettotaljambulatDecimal: Decimal;
        _getMinutesJamDecimal: Decimal;
    begin
        // MENCARI NILAI KOMA PADA _Hours
        _gettotaljambulatDecimal := 0;
        _getMinutesJamDecimal := 0;
        if _Hours < 10 then
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10) else
            _gettotaljambulatText := DelStr(Format(_Hours), 2, 10);
        Evaluate(_gettotaljambulatDecimal, _gettotaljambulatText);
        _getMinutesJamDecimal := _Hours - _gettotaljambulatDecimal;
        _Minutes := _Minutes + (_getMinutesJamDecimal * 60);
        _Hours := _gettotaljambulatDecimal;
        // Message('%1 = %2 = %3', _Minutes, _Hours, _gettotaljambulatDecimal);

        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        leaveWeek[i] := _Hours + Round(_jumlahJam, 1, '<');
        leaveWeekMinutes[i] := _jumlahMenit;
    end;

    // total time month bottom 
    local procedure totalTimeMonthBottom(var _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        TotalMontHoursBot := _Hours + Round(_jumlahJam, 1, '<');
        TotalMontMinutesBot := _jumlahMenit;
    end;

    // TOTAL WAKTU PALING BAWAH 
    local procedure totalTimeBottom(var i: integer; _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        totalHoursBottom[i] := _Hours + Round(_jumlahJam, 1, '<');
        totalMinutesBottom[i] := _jumlahMenit;
    end;

    // TOTAL BULAN SEBELAH KANAN
    local procedure totalTimeMonth(var _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        totalHoursMonth := _Hours + Round(_jumlahJam, 1, '<');
        totalMinutesMonth := _jumlahMenit;
    end;
    // total per week 
    local procedure totalTime(var i: Integer; _Hours: Decimal; _Minutes: Decimal)
    var
        _jumlahMenit: decimal;
        _jumlahJam: Decimal;
        _kurangin: Decimal;
        _jumlahWords: text;
        _jumlahDec: Decimal;
    begin
        // MENCARI NILAI MINUTES, JIKA DIA LEBIH DARI 60 MINUTES
        if _Minutes >= 60 then begin
            _jumlahJam := _Minutes / 60;
            _kurangin := Round(_jumlahJam, 0.001, '=');
            if _kurangin < 10 then
                _jumlahWords := DelStr(Format(_kurangin), 2, 10)
            else
                _jumlahWords := DelStr(Format(_kurangin), 3, 10);

            Evaluate(_jumlahDec, _jumlahWords);
            _jumlahMenit := (_jumlahJam - _jumlahDec) * 60;
        end else begin
            _jumlahMenit := _Minutes;
            _jumlahJam := 0;
        end;
        // HASIL AKHIR
        _timeWeek1[i] := _Hours + Round(_jumlahJam, 1, '<');
        _timeMinutes[i] := _jumlahMenit;
    end;

    local procedure insertDateTemporaryLeave(EmployeeNo: Code[50]; FromDate: date; ToDate: date)
    var
        frz_PostedLeave_1: Record "Posted Leave Request";
        frz_PostedLeave_2: Record "Posted Leave Request";
        frz_PostedUnconditional_1: Record "Posted Unco Leave Request";
        frz_PostedUnconditional_2: Record "Posted Unco Leave Request";
        ai: Integer;
        forInt: Integer;
        forInt_2: Integer;
        forInt_3: Integer;
        forInt_4: Integer;
        frz_Date_1: Record date;
        frz_Date_2: Record date;
        frz_Date_3: Record date;
        frz_Date_4: Record date;
        jumlahHari_1: Decimal;
        jumlahHari_2: Decimal;
        jumlahHari_3: Decimal;
        jumlahHari_4: Decimal;
        jumlahHariCuti_1: Decimal;
        jumlahHariCuti_2: Decimal;
        jumlahHariCuti_3: Decimal;
        jumlahHariCuti_4: Decimal;
        frz_BaseCalendar: Record "Base Calendar Change";
        frz_BaseCalendar2: Record "Base Calendar Change";
        frz_ResourceDate: Record Date;
        frz_SabMing: Boolean;
        frz_tglMerah: Boolean;
        frz_PayrollGenSetup: Record "Payroll General Setup";
    begin
        frz_PayrollGenSetup.FindSet();

        jumlahHari_1 := 0;
        jumlahHari_2 := 0;
        jumlahHari_3 := 0;
        jumlahHari_4 := 0;

        jumlahHariCuti_1 := 0;
        jumlahHariCuti_2 := 0;
        jumlahHariCuti_3 := 0;
        jumlahHariCuti_4 := 0;

        frz_PostedLeave_1.Reset();
        frz_PostedLeave_1.SetRange("Employee No.", EmployeeNo);
        frz_PostedLeave_1.SetRange("Starting Date", FromDate, ToDate);
        frz_PostedLeave_1.SetRange(Reversed, false);
        if frz_PostedLeave_1.FindFirst() then
            repeat
                jumlahHariCuti_1 := frz_PostedLeave_1."Total Number of Days";
                frz_Date_1.Reset();
                frz_Date_1.SetRange("Period Type", frz_Date_1."Period Type"::Date);
                frz_Date_1.SetRange("Period Start", frz_PostedLeave_1."Starting Date", frz_PostedLeave_1."Ending Date");
                if frz_Date_1.FindFirst() then
                    jumlahHari_1 := frz_Date_1.Count;

                for forInt := 0 to jumlahHari_1 do begin
                    // if (DataItemEmployee."MSI_HRIS Shift Schedule" = false)
                    // or (DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin
                    //Cari Libur
                    frz_SabMing := false;
                    frz_tglMerah := false;
                    frz_BaseCalendar.Reset();
                    frz_BaseCalendar.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendar.SetRange(Date, CalcDate('+' + Format(forInt) + 'D', frz_PostedLeave_1."Starting Date"));
                    frz_BaseCalendar.SetRange(Nonworking, true);
                    if frz_BaseCalendar.FindFirst() then
                        frz_tglMerah := true;

                    frz_ResourceDate.Reset();
                    frz_ResourceDate.SetRange("Period Start", CalcDate('+' + Format(forInt) + 'D', frz_PostedLeave_1."Starting Date"));
                    frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                    if frz_ResourceDate.FindFirst() then begin
                        frz_BaseCalendar2.Reset();
                        frz_BaseCalendar2.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar2.SetRange(Date, 0D);
                        frz_BaseCalendar2.SetRange(Day, frz_ResourceDate."Period No.");
                        frz_BaseCalendar2.SetRange(Nonworking, true);
                        if frz_BaseCalendar2.FindFirst() then
                            frz_SabMing := true;
                    end;
                    // end;
                    //Cari Libur tutup
                    if forInt < jumlahHari_1 then
                        if (CalcDate('+' + Format(forInt) + 'D', frz_PostedLeave_1."Starting Date") >= FromDate)
                        and (CalcDate(Format(forInt) + 'D', frz_PostedLeave_1."Starting Date") <= ToDate)
                        and (frz_SabMing = false) and (frz_tglMerah = false) then begin

                            frz_PostedLeaveTemporaryHeader.Init();
                            frz_PostedLeaveTemporaryHeader."No." := frz_PostedLeave_1."No." + Format(forInt);
                            frz_PostedLeaveTemporaryHeader."Leave Type Code" := frz_PostedLeave_1."Leave Type Code";
                            frz_PostedLeaveTemporaryHeader."Starting Date" := CalcDate('+' + Format(forInt) + 'D', frz_PostedLeave_1."Starting Date");
                            frz_PostedLeaveTemporaryHeader."Ending Date" := frz_PostedLeave_1."Ending Date";
                            frz_PostedLeaveTemporaryHeader."Posting Date" := frz_PostedLeave_1."Posting Date";
                            frz_PostedLeaveTemporaryHeader."Employee No." := frz_PostedLeave_1."Employee No.";
                            frz_PostedLeaveTemporaryHeader."Leave Type" := frz_PostedLeave_1."Leave Type";
                            frz_PostedLeaveTemporaryHeader."Total Number of Days" := jumlahHariCuti_1;
                            frz_PostedLeaveTemporaryHeader.Insert();

                        end;
                end;
            until frz_PostedLeave_1.Next() = 0;

        frz_PostedLeave_2.Reset();
        frz_PostedLeave_2.SetRange("Employee No.", EmployeeNo);
        frz_PostedLeave_2.SetFilter("Starting Date", '< %1', FromDate);
        frz_PostedLeave_2.SetRange("Ending Date", FromDate, ToDate);
        frz_PostedLeave_2.SetRange(Reversed, false);
        if frz_PostedLeave_2.FindFirst() then
            repeat
                jumlahHariCuti_2 := frz_PostedLeave_2."Total Number of Days";
                frz_Date_2.Reset();
                frz_Date_2.SetRange("Period Type", frz_Date_2."Period Type"::Date);
                frz_Date_2.SetRange("Period Start", frz_PostedLeave_2."Starting Date", frz_PostedLeave_2."Ending Date");
                if frz_Date_2.FindFirst() then
                    jumlahHari_2 := frz_Date_2.Count;

                for forInt_2 := 0 to jumlahHari_2 do begin
                    //Cari Libur
                    // if (DataItemEmployee."MSI_HRIS Shift Schedule" = false)
                    // or (DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin

                    frz_SabMing := false;
                    frz_tglMerah := false;
                    frz_BaseCalendar.Reset();
                    frz_BaseCalendar.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendar.SetRange(Date, CalcDate('+' + Format(forInt_2) + 'D', frz_PostedLeave_2."Starting Date"));
                    frz_BaseCalendar.SetRange(Nonworking, true);
                    if frz_BaseCalendar.FindFirst() then
                        frz_tglMerah := true;

                    frz_ResourceDate.Reset();
                    frz_ResourceDate.SetRange("Period Start", CalcDate('+' + Format(forInt_2) + 'D', frz_PostedLeave_2."Starting Date"));
                    frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                    if frz_ResourceDate.FindFirst() then begin
                        frz_BaseCalendar2.Reset();
                        frz_BaseCalendar2.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar2.SetRange(Date, 0D);
                        frz_BaseCalendar2.SetRange(Day, frz_ResourceDate."Period No.");
                        frz_BaseCalendar2.SetRange(Nonworking, true);
                        if frz_BaseCalendar2.FindFirst() then
                            frz_SabMing := true;
                    end;
                    // end;
                    //Cari Libur tutup
                    if forInt_2 < jumlahHari_2 then begin
                        if (CalcDate('+' + Format(forInt_2) + 'D', frz_PostedLeave_2."Starting Date") >= FromDate)
                        and (CalcDate(Format(forInt_2) + 'D', frz_PostedLeave_2."Starting Date") <= ToDate)
                        and (frz_SabMing = false) and (frz_tglMerah = false) then begin

                            frz_PostedLeaveTemporaryHeader.Init();
                            frz_PostedLeaveTemporaryHeader."No." := frz_PostedLeave_2."No." + Format(forInt_2);
                            frz_PostedLeaveTemporaryHeader."Leave Type Code" := frz_PostedLeave_2."Leave Type Code";
                            frz_PostedLeaveTemporaryHeader."Starting Date" := CalcDate('+' + Format(forInt_2) + 'D', frz_PostedLeave_2."Starting Date");
                            frz_PostedLeaveTemporaryHeader."Ending Date" := frz_PostedLeave_2."Ending Date";
                            frz_PostedLeaveTemporaryHeader."Posting Date" := frz_PostedLeave_2."Posting Date";
                            frz_PostedLeaveTemporaryHeader."Employee No." := frz_PostedLeave_2."Employee No.";
                            frz_PostedLeaveTemporaryHeader."Leave Type" := frz_PostedLeave_2."Leave Type";
                            frz_PostedLeaveTemporaryHeader."Total Number of Days" := jumlahHariCuti_2;
                            frz_PostedLeaveTemporaryHeader.Insert();

                        end;
                    end;
                end;
            until frz_PostedLeave_2.Next() = 0;

        // posted unconditional Leaave
        frz_PostedUnconditional_1.Reset();
        frz_PostedUnconditional_1.SetRange("Employee No.", EmployeeNo);
        frz_PostedUnconditional_1.SetRange("Starting Date", FromDate, ToDate);
        frz_PostedUnconditional_1.SetRange(Reversed, false);
        if frz_PostedUnconditional_1.FindFirst() then
            repeat
                jumlahHariCuti_3 := frz_PostedUnconditional_1."Total Number of Days";
                frz_Date_1.Reset();
                frz_Date_1.SetRange("Period Type", frz_Date_1."Period Type"::Date);
                frz_Date_1.SetRange("Period Start", frz_PostedUnconditional_1."Starting Date", frz_PostedUnconditional_1."Ending Date");
                if frz_Date_1.FindFirst() then
                    jumlahHari_3 := frz_Date_1.Count;

                for forInt := 0 to jumlahHari_3 do begin
                    // if (DataItemEmployee."MSI_HRIS Shift Schedule" = false)
                    // or (DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin
                    //Cari Libur
                    frz_SabMing := false;
                    frz_tglMerah := false;
                    frz_BaseCalendar.Reset();
                    frz_BaseCalendar.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendar.SetRange(Date, CalcDate('+' + Format(forInt) + 'D', frz_PostedUnconditional_1."Starting Date"));
                    frz_BaseCalendar.SetRange(Nonworking, true);
                    if frz_BaseCalendar.FindFirst() then
                        frz_tglMerah := true;

                    frz_ResourceDate.Reset();
                    frz_ResourceDate.SetRange("Period Start", CalcDate('+' + Format(forInt) + 'D', frz_PostedUnconditional_1."Starting Date"));
                    frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                    if frz_ResourceDate.FindFirst() then begin
                        frz_BaseCalendar2.Reset();
                        frz_BaseCalendar2.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar2.SetRange(Date, 0D);
                        frz_BaseCalendar2.SetRange(Day, frz_ResourceDate."Period No.");
                        frz_BaseCalendar2.SetRange(Nonworking, true);
                        if frz_BaseCalendar2.FindFirst() then
                            frz_SabMing := true;
                    end;
                    // end;
                    //Cari Libur tutup
                    if forInt < jumlahHari_3 then
                        if (CalcDate('+' + Format(forInt) + 'D', frz_PostedUnconditional_1."Starting Date") >= FromDate)
                        and (CalcDate(Format(forInt) + 'D', frz_PostedUnconditional_1."Starting Date") <= ToDate)
                        and (frz_SabMing = false) and (frz_tglMerah = false) then begin

                            frz_PostedLeaveTemporaryHeader.Init();
                            frz_PostedLeaveTemporaryHeader."No." := frz_PostedUnconditional_1."No." + Format(forInt);
                            frz_PostedLeaveTemporaryHeader."Leave Type Code" := frz_PostedUnconditional_1."Leave Type Code";
                            frz_PostedLeaveTemporaryHeader."Starting Date" := CalcDate('+' + Format(forInt) + 'D', frz_PostedUnconditional_1."Starting Date");
                            frz_PostedLeaveTemporaryHeader."Ending Date" := frz_PostedUnconditional_1."Ending Date";
                            frz_PostedLeaveTemporaryHeader."Posting Date" := frz_PostedUnconditional_1."Posting Date";
                            frz_PostedLeaveTemporaryHeader."Employee No." := frz_PostedUnconditional_1."Employee No.";
                            frz_PostedLeaveTemporaryHeader."Leave Type" := frz_PostedLeaveTemporaryHeader."Leave Type"::"Other Attendance";
                            frz_PostedLeaveTemporaryHeader."Total Number of Days" := jumlahHariCuti_3;
                            frz_PostedLeaveTemporaryHeader.Insert();

                        end;
                end;
            until frz_PostedLeave_1.Next() = 0;

        frz_PostedUnconditional_2.Reset();
        frz_PostedUnconditional_2.SetRange("Employee No.", EmployeeNo);
        frz_PostedUnconditional_2.SetFilter("Starting Date", '< %1', FromDate);
        frz_PostedUnconditional_2.SetRange("Ending Date", FromDate, ToDate);
        frz_PostedUnconditional_2.SetRange(Reversed, false);
        if frz_PostedUnconditional_2.FindFirst() then
            repeat
                jumlahHariCuti_4 := frz_PostedUnconditional_2."Total Number of Days";
                frz_Date_2.Reset();
                frz_Date_2.SetRange("Period Type", frz_Date_2."Period Type"::Date);
                frz_Date_2.SetRange("Period Start", frz_PostedUnconditional_2."Starting Date", frz_PostedUnconditional_2."Ending Date");
                if frz_Date_2.FindFirst() then
                    jumlahHari_4 := frz_Date_2.Count;

                for forInt_2 := 0 to jumlahHari_4 do begin
                    //Cari Libur
                    // if (DataItemEmployee."MSI_HRIS Shift Schedule" = false)
                    // or (DataItemEmployee."MSI_HRIS Type Shift" = DataItemEmployee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin

                    frz_SabMing := false;
                    frz_tglMerah := false;
                    frz_BaseCalendar.Reset();
                    frz_BaseCalendar.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendar.SetRange(Date, CalcDate('+' + Format(forInt_2) + 'D', frz_PostedUnconditional_2."Starting Date"));
                    frz_BaseCalendar.SetRange(Nonworking, true);
                    if frz_BaseCalendar.FindFirst() then
                        frz_tglMerah := true;

                    frz_ResourceDate.Reset();
                    frz_ResourceDate.SetRange("Period Start", CalcDate('+' + Format(forInt_2) + 'D', frz_PostedUnconditional_2."Starting Date"));
                    frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                    if frz_ResourceDate.FindFirst() then begin
                        frz_BaseCalendar2.Reset();
                        frz_BaseCalendar2.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar2.SetRange(Date, 0D);
                        frz_BaseCalendar2.SetRange(Day, frz_ResourceDate."Period No.");
                        frz_BaseCalendar2.SetRange(Nonworking, true);
                        if frz_BaseCalendar2.FindFirst() then
                            frz_SabMing := true;
                    end;
                    // end;
                    //Cari Libur tutup
                    if forInt_2 < jumlahHari_4 then begin
                        if (CalcDate('+' + Format(forInt_2) + 'D', frz_PostedUnconditional_2."Starting Date") >= FromDate)
                        and (CalcDate(Format(forInt_2) + 'D', frz_PostedUnconditional_2."Starting Date") <= ToDate)
                        and (frz_SabMing = false) and (frz_tglMerah = false) then begin

                            frz_PostedLeaveTemporaryHeader.Init();
                            frz_PostedLeaveTemporaryHeader."No." := frz_PostedUnconditional_2."No." + Format(forInt_2);
                            frz_PostedLeaveTemporaryHeader."Leave Type Code" := frz_PostedUnconditional_2."Leave Type Code";
                            frz_PostedLeaveTemporaryHeader."Starting Date" := CalcDate('+' + Format(forInt_2) + 'D', frz_PostedUnconditional_2."Starting Date");
                            frz_PostedLeaveTemporaryHeader."Ending Date" := frz_PostedUnconditional_2."Ending Date";
                            frz_PostedLeaveTemporaryHeader."Posting Date" := frz_PostedUnconditional_2."Posting Date";
                            frz_PostedLeaveTemporaryHeader."Employee No." := frz_PostedUnconditional_2."Employee No.";
                            frz_PostedLeaveTemporaryHeader."Leave Type" := frz_PostedLeaveTemporaryHeader."Leave Type"::"Other Attendance";
                            frz_PostedLeaveTemporaryHeader."Total Number of Days" := jumlahHariCuti_4;
                            frz_PostedLeaveTemporaryHeader.Insert();

                        end;
                    end;
                end;
            until frz_PostedLeave_2.Next() = 0;
    end;
}