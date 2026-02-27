codeunit 65001 "Employee Absence Management"
{
    procedure hitungDurasiAbsence(startingTime: Time; endingTime: Time;
    var intJam: Integer; var intMenit: Integer)
    var
        Selisih: BigInteger;

        satumenit: Duration;
        sebelumJam00: Duration;
        dariJam00: Duration;
        totalDuration: Duration;

        intJamnya: Integer;
    begin
        if endingTime = 000000T then
            endingTime := 235900T;
        // if startingTime = 000000T then
        //     startingTime := 235900T;

        if endingTime < startingTime then begin

            Selisih := startingTime - endingTime;

            sebelumJam00 := 235900T - startingTime;
            satumenit := 000200T - 000100T;

            dariJam00 := endingTime - 000000T;
            totalDuration := (sebelumJam00 + satumenit) + dariJam00;

            intJam := totalDuration div (60 * 60 * 1000);
            intMenit := (totalDuration mod (60 * 60 * 1000)) div (60 * 1000);
        end
        else begin
            Selisih := endingTime - startingTime;
            intJam := Selisih div (60 * 60 * 1000);
            intMenit := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
        end;

    end;

    procedure WFHChek(EmployeeNo: Code[50]; DateNya: Date): Boolean
    var
        frz_Employee: Record Employee;
        frz_BaseCalendarChange: Record "Base Calendar Change";
        frz_PayrollGenSetup: Record "Payroll General Setup";
        frz_ShiftSchedule: Record "Shift Schedules";
    begin
        // Message('%1', EmployeeNo);
        frz_PayrollGenSetup.FindFirst();
        frz_Employee.Reset();
        frz_Employee.SetRange("No.", EmployeeNo);
        if frz_Employee.FindFirst() then begin
            if frz_Employee."MSI_HRIS Shift Schedule" = false then begin
                frz_BaseCalendarChange.Reset();
                frz_BaseCalendarChange.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                frz_BaseCalendarChange.SetRange(Date, DateNya);
                if frz_BaseCalendarChange.FindFirst() then
                    exit(frz_BaseCalendarChange.WFH);
            end else begin
                if frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Office Helper" then begin
                    frz_BaseCalendarChange.Reset();
                    frz_BaseCalendarChange.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendarChange.SetRange(Date, DateNya);
                    if frz_BaseCalendarChange.FindFirst() then
                        exit(frz_BaseCalendarChange.WFH);
                end;
                if frz_Employee."MSI_HRIS Type Shift" = frz_Employee."MSI_HRIS Type Shift"::"Shift Guard" then begin
                    frz_ShiftSchedule.Reset();
                    frz_ShiftSchedule.SetRange("Employee No.", EmployeeNo);
                    frz_ShiftSchedule.SetRange("Effective Date", CalcDate('-CM', DateNya), CalcDate('CM', DateNya));
                    if frz_ShiftSchedule.FindFirst() then begin
                        if frz_ShiftSchedule."Base Calendar Shift-1" = true then begin
                            frz_BaseCalendarChange.Reset();
                            frz_BaseCalendarChange.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Shift-1");
                            frz_BaseCalendarChange.SetRange(Date, DateNya);
                            if frz_BaseCalendarChange.FindFirst() then
                                exit(frz_BaseCalendarChange.WFH);
                        end;
                        if frz_ShiftSchedule."Base Calendar Shift-2" = true then begin
                            frz_BaseCalendarChange.Reset();
                            frz_BaseCalendarChange.SetRange("Base Calendar Code", frz_PayrollGenSetup."Base Calendar Shift-2");
                            frz_BaseCalendarChange.SetRange(Date, DateNya);
                            if frz_BaseCalendarChange.FindFirst() then
                                exit(frz_BaseCalendarChange.WFH);
                        end;
                    end;
                end;
            end;
        end;
    end;
}