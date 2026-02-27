report 65004 "Attendance Sheet"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65004_ATTENDANCE_SHEET_NEW.rdlc';
    DefaultLayout = RDLC;
    // fadhil TEST 123 haiaiiiiii
    dataset
    {
        dataitem(Employee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(FullName; FullName) { }
            column(Divisi; "Job Title") { }
            column(Tanggal; Tanggal) { }
            column(MSI_HRIS_Shift_Schedule; "MSI_HRIS Shift Schedule") { }
            column(totalHoursMonth; totalHoursMonth) { }
            column(totalMinutesMonth; totalMinutesMonth) { }
            dataitem(DateTable; Date)
            {
                column(frz_JamMasuk; format(frz_JamMasuk_New, 0, '<Hours24>:<Minutes,2>')) { }
                column(frz_JamKeluar; format(frz_JamKeluar_New, 0, '<Hours24>:<Minutes,2>')) { }
                column(Period_Start; "Period Start") { }
                column(Period_Name; "Period Name") { }
                column(Period_No_; "Period No.") { }
                column(intJamCepatDatang; intJamCepatDatang) { }
                column(intJamCepatPulang; intJamCepatPulang) { }
                column(intJamLambatDatang; intJamLambatDatang) { }
                column(intJamLambatPulang; intJamLambatPulang) { }
                column(intMenitCepatDatang; intMenitCepatDatang) { }
                column(intMenitCepatPulang; intMenitCepatPulang) { }
                column(intMenitLambatDatang; intMenitLambatDatang) { }
                column(intMenitLambatPulang; intMenitLambatPulang) { }
                column(Total_Duration_Hours; frz_TotalDurationHours) { }
                column(Total_Duration_Minutes; frz_TotalDurationMinutes) { }
                column(Activity_Description; frz_ActivityDescription) { }
                column(Time_From_Line; format(frz_TimeFrom, 0, '<Hours24>:<Minutes,2>')) { }
                column(Time_To_Line; format(frz_TimeTo, 0, '<Hours24>:<Minutes,2>')) { }
                column(frz_Keterangan; frz_Keterangan) { }
                column(frz_Keterangan_2; frz_Keterangan_2) { }
                column(frz_Weekend; frz_Weekend) { }
                column(frz_Miss; frz_Miss) { }
                column(frz_KeteranganClock; frz_KeteranganClock) { }
                column(frz_KeteranganKosong; frz_KeteranganKosong) { }
                column(frz_KurangjamKeterangan; frz_KurangjamKeterangan) { }
                column(frz_KeteranganWFH; frz_KeteranganWFH) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Period Start", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                end;

                trigger OnAfterGetRecord()
                var
                    jamDatang: Time;
                    jamPulang: Time;
                    frz_AttendanceLine: Record "Employee Absence Line";
                    LeaveRequest: Record "Leave Request";
                    PostedLeaveRequest: Record "Posted Leave Request";
                    frz_Uncunditional: Record "Unconditional Leave Request";
                    frz_PostedUncunditional: Record "Posted Unco Leave Request";
                    frz_CTORealiz: Record "CTO Realization Header";
                    frz_PostCTORealiz: Record "Posted CTO Realization Header";
                    rec_BaseCalendar: Record "Base Calendar Change";
                    rec_BaseCalendar2: Record "Base Calendar Change";
                    rec_PayrollGenSetup: Record "Payroll General Setup";

                    frz_PostedLeaveRequest: Record "Posted Leave Request";
                    frz_PostedUnconditionalLeaveRequest: Record "Posted Unco Leave Request";
                    frz_PostedCTORealization: Record "Posted CTO Realization Header";

                    frz_PostedLeaveRequest_2: Record "Posted Leave Request";
                    frz_PostedUnconditionalLeaveRequest_2: Record "Posted Unco Leave Request";
                    frz_PostedCTORealization_2: Record "Posted CTO Realization Header";

                    frz_paramTime: Time;

                    frz_MasterTypeLeave: Record "Master Leave Unconditional";
                    frz_ShiftSchedule: Record "Shift Schedules";
                    frz_DoA: Record "Description of attendance";

                    AbsenceManage: Codeunit "Employee Absence Management";
                    frz_ShiftSchedule_Jadwal: Record "Shift Schedules";
                    frz_ClockSchedule: Record "clock schedule";
                    lamaJam: Integer;
                    lamaMenit: Integer;
                    // less working 
                    frz_DatangnyaJam: Integer;
                    frz_DatangnyaMenit: Integer;

                    frz_PulangyaJam: Integer;
                    frz_PulangyaMenit: Integer;

                    format_JamDatang: text;
                    format_MenitDatang: Text;
                    format_JamPulang: text;
                    format_MenitPulang: Text;

                    format_PULANG: Text;
                    format_DATANG: Text;

                    time_PULANG: Time;
                    time_DATANG: Time;
                    time_SELISIHNYA: BigInteger;
                    fr_fieldJam: Integer;
                    fr_fieldMinutes: Integer;
                begin
                    // netral value 
                    intJamLambatDatang := 0;
                    intMenitLambatDatang := 0;
                    intJamCepatDatang := 0;
                    intMenitCepatDatang := 0;
                    intJamLambatPulang := 0;
                    intMenitLambatPulang := 0;
                    intJamCepatPulang := 0;
                    intMenitCepatPulang := 0;

                    // working less hours 
                    frz_DatangnyaJam := 0;
                    frz_DatangnyaMenit := 0;

                    frz_PulangyaJam := 0;
                    frz_PulangyaMenit := 0;
                    fr_fieldJam := 0;
                    fr_fieldMinutes := 0;
                    time_PULANG := 0T;
                    time_DATANG := 0T;

                    lamaJam := 0;
                    lamaMenit := 0;
                    frz_TimeFrom := 0T;
                    frz_TimeTo := 0T;
                    frz_paramTime := 0T;
                    frz_ActivityDescription := '';
                    frz_KeteranganWFH := '';

                    frz_TotalDurationHours := 0;
                    frz_TotalDurationMinutes := 0;

                    frz_Weekend := false;

                    jamDatang := 0T;
                    jamPulang := 0T;

                    frz_JamMasuk_New := frz_JamMasuk;
                    frz_JamKeluar_New := frz_JamKeluar;

                    Clear(frz_KurangjamKeterangan);
                    Clear(frz_KeteranganClock);
                    Clear(frz_Keterangan);
                    Clear(frz_Keterangan_2);

                    if Employee."MSI_HRIS Type Shift" = Employee."MSI_HRIS Type Shift"::"Shift Office Helper" then begin
                        frz_JamMasuk_New := 0T;
                        frz_JamKeluar_New := 0T;
                    end;

                    // if (frz_JamMasuk_New = 0T) or (frz_JamKeluar_New = 0T) then begin
                    if Employee."MSI_HRIS Shift Schedule" = true then begin
                        if Employee."MSI_HRIS Type Shift" = Employee."MSI_HRIS Type Shift"::"Shift Guard" then begin
                            frz_ShiftSchedule_Jadwal.Reset();
                            frz_ShiftSchedule_Jadwal.SetRange("Type Shift", frz_ShiftSchedule_Jadwal."Type Shift"::"Shift Guard");
                            frz_ShiftSchedule_Jadwal.SetRange("Employee No.", Employee."No.");
                            frz_ShiftSchedule_Jadwal.SetRange("Effective Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                            if frz_ShiftSchedule_Jadwal.FindFirst() then begin
                                frz_ClockSchedule.Reset();
                                frz_ClockSchedule.SetFilter("Starting Date", '<= %1', DateTable."Period Start");
                                frz_ClockSchedule.SetFilter("Ending Date", '>= %1', DateTable."Period Start");
                                if frz_ClockSchedule.FindFirst() then begin
                                    frz_JamMasuk_New := frz_ShiftSchedule_Jadwal."Working Start";
                                    frz_JamKeluar_New := frz_ShiftSchedule_Jadwal."Working Out" - frz_ClockSchedule."Total Time Duration";
                                    jamDatang := frz_ShiftSchedule_Jadwal."Working Start";
                                    jamPulang := frz_ShiftSchedule_Jadwal."Working Out" - frz_ClockSchedule."Total Time Duration";
                                end else begin
                                    frz_JamMasuk_New := frz_ShiftSchedule_Jadwal."Working Start";
                                    frz_JamKeluar_New := frz_ShiftSchedule_Jadwal."Working Out";
                                    jamDatang := frz_ShiftSchedule_Jadwal."Working Start";
                                    jamPulang := frz_ShiftSchedule_Jadwal."Working Out";
                                end;
                            end;
                        end;
                        if Employee."MSI_HRIS Type Shift" = Employee."MSI_HRIS Type Shift"::"Shift Office Helper" then begin
                            frz_ShiftSchedule_Jadwal.Reset();
                            frz_ShiftSchedule_Jadwal.SetRange("Type Shift", frz_ShiftSchedule_Jadwal."Type Shift"::"Shift Office Helper");
                            frz_ShiftSchedule_Jadwal.SetRange("Employee No.", Employee."No.");
                            frz_ShiftSchedule_Jadwal.SetRange("Effective Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                            if frz_ShiftSchedule_Jadwal.FindFirst() then begin
                                repeat
                                    if Date2DWY("Period Start", 2) = Date2DWY(frz_ShiftSchedule_Jadwal."Effective Date", 2) then begin
                                        frz_ClockSchedule.Reset();
                                        frz_ClockSchedule.SetFilter("Starting Date", '<= %1', DateTable."Period Start");
                                        frz_ClockSchedule.SetFilter("Ending Date", '>= %1', DateTable."Period Start");
                                        if frz_ClockSchedule.FindFirst() then begin
                                            frz_JamMasuk_New := frz_ShiftSchedule_Jadwal."Working Start";
                                            frz_JamKeluar_New := frz_ShiftSchedule_Jadwal."Working Out" - frz_ClockSchedule."Total Time Duration";
                                            jamDatang := frz_ShiftSchedule_Jadwal."Working Start";
                                            jamPulang := frz_ShiftSchedule_Jadwal."Working Out" - frz_ClockSchedule."Total Time Duration";
                                        end else begin
                                            frz_JamMasuk_New := frz_ShiftSchedule_Jadwal."Working Start";
                                            frz_JamKeluar_New := frz_ShiftSchedule_Jadwal."Working Out";
                                            jamDatang := frz_ShiftSchedule_Jadwal."Working Start";
                                            jamPulang := frz_ShiftSchedule_Jadwal."Working Out";
                                        end;
                                    end;
                                until frz_ShiftSchedule_Jadwal.Next() = 0;
                                if frz_JamMasuk_New = 0T then begin
                                    frz_JamMasuk_New := 080000T;
                                    frz_JamKeluar_New := 160000T;
                                    jamDatang := 080000T;
                                    jamPulang := 160000T;
                                end;
                            end;
                        end;
                    end else begin
                        frz_ClockSchedule.Reset();
                        frz_ClockSchedule.SetFilter("Starting Date", '<= %1', DateTable."Period Start");
                        frz_ClockSchedule.SetFilter("Ending Date", '>= %1', DateTable."Period Start");
                        if frz_ClockSchedule.FindFirst() then begin
                            frz_JamMasuk_New := frz_ClockSchedule."Working Start";
                            frz_JamKeluar_New := frz_ClockSchedule."Working Out";
                            jamDatang := frz_ClockSchedule."Working Start";
                            jamPulang := frz_ClockSchedule."Working Out";
                        end else begin
                            jamDatang := frz_JamMasuk_New;
                            jamPulang := frz_JamKeluar_New;
                        end;
                    end;

                    AbsenceManage.hitungDurasiAbsence(frz_JamMasuk_New, frz_JamKeluar_New, lamaJam, lamaMenit);
                    frz_TotalJamKantor := lamaJam;
                    frz_TotalMenitKantor := lamaMenit;
                    // end else begin

                    //     frz_ClockSchedule.Reset();
                    //     frz_ClockSchedule.SetFilter("Starting Date", '<= %1', DateTable."Period Start");
                    //     frz_ClockSchedule.SetFilter("Ending Date", '>= %1', DateTable."Period Start");
                    //     if frz_ClockSchedule.FindFirst() then begin
                    //         frz_JamMasuk_New := frz_ClockSchedule."Working Start";
                    //         frz_JamKeluar_New := frz_ClockSchedule."Working Out";
                    //         jamDatang := frz_ClockSchedule."Working Start";
                    //         jamPulang := frz_ClockSchedule."Working Out";
                    //     end else begin
                    //         jamDatang := frz_JamMasuk_New;
                    //         jamPulang := frz_JamKeluar_New;
                    //     end;
                    // end;

                    frz_AttendanceLine.Reset();
                    frz_AttendanceLine.SetRange("Employee No.", Employee."No.");
                    frz_AttendanceLine.SetRange(Date, DateTable."Period Start");
                    if frz_AttendanceLine.FindFirst() then begin

                        frz_ActivityDescription := frz_AttendanceLine."Activity Description";
                        frz_TotalDurationHours := frz_AttendanceLine."Total Duration Hours";
                        frz_TotalDurationMinutes := frz_AttendanceLine."Total Duration Minutes";
                        frz_TimeFrom := frz_AttendanceLine."Time From Line";
                        frz_TimeTo := frz_AttendanceLine."Time To Line";

                        if frz_AttendanceLine."Allow non working date" = true then
                            frz_Keterangan := frz_AttendanceLine."Activity Description";

                        if jamDatang = 000000T then jamDatang := 235900T;

                        if frz_TimeFrom <= jamDatang then
                            frz_paramTime := jamDatang else
                            frz_paramTime := frz_TimeFrom;
                        if frz_AttendanceLine.WFH = false then begin

                            if (frz_AttendanceLine."Time From Line" = 0T) or (frz_AttendanceLine."Time To Line" = 0T) then begin
                                if (frz_AttendanceLine."Time From Line" = 0T) and (frz_AttendanceLine."Time To Line" = 0T) then begin
                                    Clear(frz_KeteranganClock);
                                end
                                else begin
                                    if frz_AttendanceLine."Time From Line" = 0T then
                                        frz_KeteranganClock := 'No clock in';
                                    if frz_AttendanceLine."Time To Line" = 0T then
                                        frz_KeteranganClock := 'No clock out';
                                end;
                            end else begin
                                AbsenceManage.hitungDurasiAbsence(frz_paramTime, frz_TimeTo, lamaJam, lamaMenit);
                                // JIKA ADA LEAVE SETANGAH HARI
                                frz_PostedLeaveRequest.Reset();
                                frz_PostedLeaveRequest.SetRange("Starting Date", DateTable."Period Start");
                                frz_PostedLeaveRequest.SetRange("Total Number of Days", 0.5);
                                frz_PostedLeaveRequest.SetRange("Leave-1", true);
                                frz_PostedLeaveRequest.SetRange(Reversed, false);
                                if not frz_PostedLeaveRequest.FindFirst() then begin
                                    frz_PostedUnconditionalLeaveRequest.Reset();
                                    frz_PostedUnconditionalLeaveRequest.SetRange("Starting Date", DateTable."Period Start");
                                    frz_PostedUnconditionalLeaveRequest.SetRange("Total Number of Days", 0.5);
                                    frz_PostedUnconditionalLeaveRequest.SetRange("Leave-1", true);
                                    frz_PostedUnconditionalLeaveRequest.SetRange(Reversed, false);
                                    if not frz_PostedUnconditionalLeaveRequest.FindFirst() then begin
                                        // frz_PostedCTORealization.Reset();
                                        // frz_PostedCTORealization.SetRange("Starting Date", DateTable."Period Start");
                                        // frz_PostedCTORealization.SetRange("Total Number of Days", 0.5);
                                        // frz_PostedCTORealization.SetRange(Reversed, false);
                                        // if not frz_PostedCTORealization.FindFirst() then begin
                                        hitungDurasiTerlambatDatang(jamDatang, frz_AttendanceLine."Time From Line");
                                        hitungDurasiCepatDatang(frz_AttendanceLine."Time From Line", jamDatang);
                                        // end;
                                    end;
                                end;
                                ////////////////
                                // JIKA ADA LEAVE SETANGAH HARI
                                frz_PostedLeaveRequest_2.Reset();
                                frz_PostedLeaveRequest_2.SetRange("Starting Date", DateTable."Period Start");
                                frz_PostedLeaveRequest_2.SetRange("Total Number of Days", 0.5);
                                frz_PostedLeaveRequest_2.SetRange("Leave-2", true);
                                frz_PostedLeaveRequest_2.SetRange(Reversed, false);
                                if not frz_PostedLeaveRequest_2.FindFirst() then begin
                                    frz_PostedUnconditionalLeaveRequest_2.Reset();
                                    frz_PostedUnconditionalLeaveRequest_2.SetRange("Starting Date", DateTable."Period Start");
                                    frz_PostedUnconditionalLeaveRequest_2.SetRange("Total Number of Days", 0.5);
                                    frz_PostedUnconditionalLeaveRequest_2.SetRange("Leave-2", true);
                                    frz_PostedUnconditionalLeaveRequest_2.SetRange(Reversed, false);
                                    if not frz_PostedUnconditionalLeaveRequest_2.FindFirst() then begin
                                        hitungDurasiTerlambatPulang(jamPulang, frz_AttendanceLine."Time To Line");
                                        hitungDurasiCepatPulang(frz_AttendanceLine."Time To Line", jamPulang);
                                    end;
                                end;
                                ////////////////

                                if lamaJam < 10 then
                                    format_JamDatang := '0' + Format(lamaJam) else
                                    format_JamDatang := Format(lamaJam);
                                if lamaMenit < 10 then
                                    format_MenitDatang := '0' + Format(lamaMenit) else
                                    format_MenitDatang := Format(lamaMenit);
                                if frz_TotalJamKantor < 10 then
                                    format_JamPulang := '0' + Format(frz_TotalJamKantor) else
                                    format_JamPulang := Format(frz_TotalJamKantor);
                                if frz_TotalMenitKantor < 10 then
                                    format_MenitPulang := '0' + Format(frz_TotalMenitKantor) else
                                    format_MenitPulang := Format(frz_TotalMenitKantor);

                                format_DATANG := format_JamDatang + format_MenitDatang + '00';
                                format_PULANG := format_JamPulang + format_MenitPulang + '00';

                                Evaluate(time_PULANG, format_PULANG);
                                Evaluate(time_DATANG, format_DATANG);

                                time_SELISIHNYA := time_PULANG - time_DATANG;
                                fr_fieldJam := time_SELISIHNYA div (60 * 60 * 1000);
                                fr_fieldMinutes := (time_SELISIHNYA mod (60 * 60 * 1000)) div (60 * 1000);
                                // less working tutup
                                // end;
                            end;
                        end else
                            // getWFH("Period Start");
                            frz_KeteranganWFH := 'WFH Full';
                    end else
                        getWFH("Period Start");

                    frz_DoA.Reset();
                    frz_DoA.SetRange("Employee No.", Employee."No.");
                    frz_DoA.SetRange(Date, "Period Start");
                    if frz_DoA.FindFirst() then
                        frz_Keterangan := frz_DoA."Activity Description";

                    PostedLeaveRequest.reset;
                    PostedLeaveRequest.SetRange("Employee No.", Employee."No.");
                    PostedLeaveRequest.SetFilter("Starting Date", '<=%1', "Period Start");
                    PostedLeaveRequest.SetFilter("Ending Date", '>=%1', "Period Start");
                    PostedLeaveRequest.SetFilter(Reversed, '= %1', false);
                    if PostedLeaveRequest.FindFirst() then begin
                        frz_MasterTypeLeave.Reset();
                        frz_MasterTypeLeave.SetRange(Code, PostedLeaveRequest."Leave Type Code");
                        frz_MasterTypeLeave.SetRange("Document Type", PostedLeaveRequest."Document Type");
                        if frz_MasterTypeLeave.FindFirst() then begin
                            if PostedLeaveRequest."Total Number of Days" < 1 then
                                frz_Keterangan := frz_MasterTypeLeave.Description + '1/2 Day'
                            else
                                frz_Keterangan := frz_MasterTypeLeave.Description;
                        end;
                    end;

                    frz_PostedUncunditional.Reset();
                    frz_PostedUncunditional.SetRange("Employee No.", Employee."No.");
                    frz_PostedUncunditional.SetFilter("Starting Date", '<=%1', "Period Start");
                    frz_PostedUncunditional.SetFilter("Ending Date", '>=%1', "Period Start");
                    frz_PostedUncunditional.SetFilter(Reversed, '= %1', false);
                    if frz_PostedUncunditional.FindFirst() then begin
                        frz_MasterTypeLeave.Reset();
                        frz_MasterTypeLeave.SetRange(Code, frz_PostedUncunditional."Leave Type Code");
                        frz_MasterTypeLeave.SetRange("Document Type", frz_PostedUncunditional."Document Type");
                        if frz_MasterTypeLeave.FindFirst() then
                            frz_Keterangan := frz_MasterTypeLeave.Description;
                    end;

                    frz_PostCTORealiz.Reset();
                    frz_PostCTORealiz.SetRange("Employee No.", Employee."No.");
                    frz_PostCTORealiz.SetFilter("Starting Date", '<=%1', "Period Start");
                    frz_PostCTORealiz.SetFilter("Ending Date", '>=%1', "Period Start");
                    if frz_PostCTORealiz.FindFirst() then
                        frz_Keterangan_2 := 'CTO';

                    // rec_PayrollGenSetup.FindFirst();

                    if frz_AttendanceLine."Allow non working date" = false then
                        if Employee."MSI_HRIS Shift Schedule" = false then
                            getWeekend(DateTable."Period Start")
                        else
                            if Employee."MSI_HRIS Type Shift" = Employee."MSI_HRIS Type Shift"::"Shift Guard" then
                                getWeekendForShiftSchedule(Employee."No.", DateTable."Period Start")
                            else
                                getWeekend(DateTable."Period Start");

                    Clear(frz_KeteranganKosong);
                    if frz_Weekend = true then begin
                        if (frz_AttendanceLine."Allow non working date" = false) then
                            frz_Miss := 'Red';
                        if (frz_AttendanceLine."Allow non working date" = true) then
                            frz_Miss := 'White';
                    end
                    else begin
                        if (frz_Keterangan_2 = '') and (frz_Keterangan = '') and (frz_Weekend = false) and (frz_AttendanceLine.Date = 0D) and (frz_KeteranganWFH = '') then begin
                            frz_Miss := 'Yellow';
                            frz_KeteranganKosong := 'no clock in no clock out';
                        end else
                            frz_Miss := 'White';
                    end;
                    Clear(frz_KurangjamKeterangan);
                    if (frz_Miss = 'Yellow') or (frz_Weekend = true) or (frz_KeteranganClock <> '') or (frz_Keterangan <> '') then begin
                        Clear(frz_KurangjamKeterangan);
                    end else begin
                        if (frz_AttendanceLine."Time From Line" <> 0T) and (frz_AttendanceLine."Time To Line" <> 0T) then begin

                            if lamaJam < frz_TotalJamKantor then
                                frz_KurangjamKeterangan := 'less working hours: ' + Format(fr_fieldJam) + ':' + Format(fr_fieldMinutes);
                            if lamaJam = frz_TotalJamKantor then begin
                                if lamaMenit < frz_TotalMenitKantor then
                                    frz_KurangjamKeterangan := 'less working hours: ' + Format(fr_fieldJam) + ':' + Format(fr_fieldMinutes);
                            end;

                        end;
                    end;

                end;
            }
            trigger OnAfterGetRecord()
            var
                frz_PayrollSetup: Record "Payroll General Setup";
                AbsenceManage: Codeunit "Employee Absence Management";
                // lamaJam: Integer;
                // lamaMenit: Integer;
                frz_ShiftSchedule: Record "Shift Schedules";
                frz_AttendanceLines: Record "Employee Absence Line";
                TotalHours: Decimal;
                TotalMinutes: Decimal;
            begin
                TotalHours := 0;
                TotalMinutes := 0;
                if "MSI_HRIS Shift Schedule" = false then begin
                    frz_PayrollSetup.FindSet();
                    frz_JamMasuk := frz_PayrollSetup."Working Start";
                    frz_JamKeluar := frz_PayrollSetup."Working Out";
                end;

                frz_AttendanceLines.Reset();
                frz_AttendanceLines.SetRange("Employee No.", Employee."No.");
                frz_AttendanceLines.SetRange(Date, CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
                if frz_AttendanceLines.FindFirst() then
                    repeat
                        TotalHours += frz_AttendanceLines."Total Duration Hours";
                        TotalMinutes += frz_AttendanceLines."Total Duration Minutes";
                    until frz_AttendanceLines.Next() = 0;

                totalTimeMonth(TotalHours, TotalMinutes);
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
                    field(Tanggal; Tanggal)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                }
            }
        }
    }

    var
        frz_KurangjamKeterangan: Text;
        frz_TotalJamKantor: Integer;
        frz_TotalMenitKantor: Integer;
        CompanyInformation: Record "Company Information";
        Employeename: text;
        Tanggal: Date;
        Divisi: text;
        totalTime: Duration;
        // var date
        intJamLambatDatang: Integer;
        intMenitLambatDatang: Integer;
        intJamCepatDatang: Integer;
        intMenitCepatDatang: Integer;
        intJamLambatPulang: Integer;
        intMenitLambatPulang: Integer;
        intJamCepatPulang: Integer;
        intMenitCepatPulang: Integer;
        frz_JamMasuk: Time;
        frz_JamKeluar: Time;
        frz_JamMasuk_New: Time;
        frz_JamKeluar_New: Time;
        // di data item table date 
        frz_ActivityDescription: Text;
        frz_TotalDurationHours: Integer;
        frz_TotalDurationMinutes: Integer;
        frz_TimeFrom: time;
        frz_TimeTo: time;
        frz_Keterangan: text;
        frz_Keterangan_2: Text;
        frz_Weekend: Boolean;
        frz_Miss: Text;
        frz_KeteranganClock: Text;
        frz_KeteranganKosong: text;
        frz_KeteranganWFH: text;
        totalHoursMonth: Decimal;
        totalMinutesMonth: Decimal;

    trigger OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    local procedure GetEmployee(EmployeeNo: Text): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then begin
            Employeename := Employee.FullName();
            Divisi := Employee."Job Title";
        end;
    end;

    local procedure totalTimeMonth(var _Hours: Decimal; _Minutes: Decimal)
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
        totalHoursMonth := _Hours + Round(_jumlahJam, 1, '<');
        totalMinutesMonth := _jumlahMenit;
    end;

    procedure hitungDurasiTerlambatDatang(startingTime: Time; endingTime: Time)
    var
        Selisih: BigInteger;
    begin
        if startingTime = 235900T then begin
            if (startingTime = 235900T) and (endingTime > 000000T) and (endingTime < 050000T) then begin
                startingTime := 000000T;
                Selisih := endingTime - startingTime;
            end;
            if (startingTime = 235900T) and (endingTime < 235900T) then begin
                startingTime := 235900T;
                Selisih := 000000T - 000000T;
            end;
        end else
            Selisih := endingTime - startingTime;

        intJamLambatDatang := Selisih div (60 * 60 * 1000);
        intMenitLambatDatang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);

        if intJamLambatDatang <= 0 then
            intJamLambatDatang := 0 else
            intJamLambatDatang := Selisih div (60 * 60 * 1000);
        if intMenitLambatDatang <= 0 then
            intMenitLambatDatang := 0 else
            intMenitLambatDatang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure hitungDurasiCepatDatang(startingTime: Time; endingTime: Time)
    var
        Selisih: BigInteger;
        Selisih_temp: BigInteger;
        satumenit: BigInteger;
    begin
        if endingTime = 235900T then begin
            if (endingTime = 235900T) and (startingTime > 000000T) and (startingTime < 050000T) then begin
                endingTime := 000000T;
                Selisih := 000000T - 000000T;
            end;
            if (endingTime = 235900T) and (startingTime < 235900T) then begin
                endingTime := 235900T;
                satumenit := 000200T - 000100T;
                Selisih_temp := endingTime - startingTime;
                Selisih := Selisih_temp + satumenit;
            end;
            if startingTime = 000000T then
                Selisih := 000000T - 000000T;
        end else
            Selisih := endingTime - startingTime;

        intJamCepatDatang := Selisih div (60 * 60 * 1000);
        intMenitCepatDatang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);

        if intJamCepatDatang <= 0 then
            intJamCepatDatang := 0 else
            intJamCepatDatang := Selisih div (60 * 60 * 1000);
        if intMenitCepatDatang <= 0 then
            intMenitCepatDatang := 0 else
            intMenitCepatDatang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure hitungDurasiTerlambatPulang(startingTime: Time; endingTime: Time)
    var
        Selisih: BigInteger;
    begin
        Selisih := endingTime - startingTime;

        intJamLambatPulang := Selisih div (60 * 60 * 1000);
        intMenitLambatPulang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);

        if intJamLambatPulang <= 0 then
            intJamLambatPulang := 0 else
            intJamLambatPulang := Selisih div (60 * 60 * 1000);
        if intMenitLambatPulang <= 0 then
            intMenitLambatPulang := 0 else
            intMenitLambatPulang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure hitungDurasiCepatPulang(startingTime: Time; endingTime: Time)
    var
        Selisih: BigInteger;
    begin
        Selisih := endingTime - startingTime;

        intJamCepatPulang := Selisih div (60 * 60 * 1000);
        intMenitCepatPulang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);

        if intJamCepatPulang <= 0 then
            intJamCepatPulang := 0 else
            intJamCepatPulang := Selisih div (60 * 60 * 1000);
        if intMenitCepatPulang <= 0 then
            intMenitCepatPulang := 0 else
            intMenitCepatPulang := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure getWeekend(periodStart: Date)
    var
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";
        rec_BaseCalendar2: Record "Base Calendar Change";
    begin
        rec_PayrollGenSetup.FindFirst();
        rec_BaseCalendar.Reset();
        rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
        rec_BaseCalendar.SetRange(Date, periodStart);
        if rec_BaseCalendar.FindFirst() then begin
            if rec_BaseCalendar.Nonworking = true then
                frz_Weekend := true;
        end else begin
            rec_BaseCalendar2.Reset();
            rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
            rec_BaseCalendar2.SetRange(Day, Date2DWY(periodStart, 1));
            rec_BaseCalendar2.SetRange(Date, 0D);
            if rec_BaseCalendar2.FindFirst() then
                if rec_BaseCalendar2.Nonworking = true then
                    frz_Weekend := true;
        end;
    end;

    procedure getWFH(periodStart: Date)
    var
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";
        rec_BaseCalendar2: Record "Base Calendar Change";
        rec_Employee: Record Employee;
        frz_ShiftSchedule: Record "Shift Schedules";
    begin
        rec_PayrollGenSetup.FindFirst();
        if (Employee."MSI_HRIS Shift Schedule" = false) or (Employee."MSI_HRIS Type Shift" = Employee."MSI_HRIS Type Shift"::"Shift Office Helper") then begin
            rec_BaseCalendar.Reset();
            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
            rec_BaseCalendar.SetRange(Date, periodStart);
            rec_BaseCalendar.SetRange(WFH, true);
            if rec_BaseCalendar.FindFirst() then
                frz_KeteranganWFH := 'WFH Full';
        end else begin
            frz_ShiftSchedule.Reset();
            frz_ShiftSchedule.SetRange("Employee No.", Employee."No.");
            frz_ShiftSchedule.SetRange("Type Shift", frz_ShiftSchedule."Type Shift"::"Shift Guard");
            frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
            if frz_ShiftSchedule.FindFirst() then begin
                if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin
                    rec_BaseCalendar.Reset();
                    rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                    rec_BaseCalendar.SetRange(Date, periodStart);
                    rec_BaseCalendar.SetRange(WFH, true);
                    if rec_BaseCalendar.FindFirst() then
                        frz_KeteranganWFH := 'WFH Full';
                end else begin
                    rec_BaseCalendar.Reset();
                    rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                    rec_BaseCalendar.SetRange(Date, periodStart);
                    rec_BaseCalendar.SetRange(WFH, true);
                    if rec_BaseCalendar.FindFirst() then
                        frz_KeteranganWFH := 'WFH Full';
                end;
            end;
        end;

    end;

    procedure getWeekendForShiftSchedule(EmployeeNo: Code[50]; StartingDate: date)
    var
        rec_BaseCalendar: Record "Base Calendar Change";
        rec_PayrollGenSetup: Record "Payroll General Setup";
        rec_BaseCalendar2: Record "Base Calendar Change";
        frz_ShiftSchedule: Record "Shift Schedules";
    begin
        rec_PayrollGenSetup.FindFirst();
        frz_ShiftSchedule.Reset();
        frz_ShiftSchedule.SetRange("Employee No.", EmployeeNo);
        frz_ShiftSchedule.SetRange("Type Shift", frz_ShiftSchedule."Type Shift"::"Shift Guard");
        frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', Tanggal), CalcDate('CM', Tanggal));
        if frz_ShiftSchedule.FindFirst() then begin
            if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin

                rec_BaseCalendar.Reset();
                rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-1");
                rec_BaseCalendar.SetRange(Date, StartingDate);
                rec_BaseCalendar.SetRange(Nonworking, true);
                if rec_BaseCalendar.FindFirst() then begin
                    frz_Weekend := true;
                end;
            end else begin
                rec_BaseCalendar.Reset();
                rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Shift-2");
                rec_BaseCalendar.SetRange(Date, StartingDate);
                rec_BaseCalendar.SetRange(Nonworking, true);
                if rec_BaseCalendar.FindFirst() then
                    frz_Weekend := true;
            end;
        end;
    end;
}