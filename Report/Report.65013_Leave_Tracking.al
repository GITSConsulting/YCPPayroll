report 65013 "Leave Tracking"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65013_Leave_Tracking.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(Employee_No_; frz_PositionLedgerTemp."Employee No.") { }
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; frz_PositionLedgerTemp."Employee No.") { }
            column(FullName; frz_NameEmployee) { }
            column(Divisi; frz_Divisi) { }
            column(Office_Location_Code; frz_Location) { }
            column(Tanggal; Year) { }
            // anual leave
            column(AnualMonth_1; AnualMonth[1]) { }
            column(AnualMonth_2; AnualMonth[2]) { }
            column(AnualMonth_3; AnualMonth[3]) { }
            column(AnualMonth_4; AnualMonth[4]) { }
            column(AnualMonth_5; AnualMonth[5]) { }
            column(AnualMonth_6; AnualMonth[6]) { }
            column(AnualMonth_7; AnualMonth[7]) { }
            column(AnualMonth_8; AnualMonth[8]) { }
            column(AnualMonth_9; AnualMonth[9]) { }
            column(AnualMonth_10; AnualMonth[10]) { }
            column(AnualMonth_11; AnualMonth[11]) { }
            column(AnualMonth_12; AnualMonth[12]) { }
            column(frz_totalAnual; frz_totalAnual) { }
            // sick leave
            column(S1; SickMonth[1]) { }
            column(S2; SickMonth[2]) { }
            column(S3; SickMonth[3]) { }
            column(S4; SickMonth[4]) { }
            column(S5; SickMonth[5]) { }
            column(S6; SickMonth[6]) { }
            column(S7; SickMonth[7]) { }
            column(S8; SickMonth[8]) { }
            column(S9; SickMonth[9]) { }
            column(S10; SickMonth[10]) { }
            column(S11; SickMonth[11]) { }
            column(S12; SickMonth[12]) { }
            column(frz_totalSick; frz_totalSick) { }
            column(Contract_Start_Date; frz_PositionLedgerTemp."Contract Start Date") { }
            column(Contract_End_Date; frz_PositionLedgerTemp."Contract End Date") { }
            column(Entry_No_; frz_EntryNoContrack) { }
            trigger OnAfterGetRecord()
            var
                frz_LeaveLedgerEntry: Record "Leave Ledger Entry";
                frz_LeaveLedgerEntry2: Record "Leave Ledger Entry";

                frz_PositionEmployee: Record Employee;
                frz_Starting: Date;
                frz_Ending: date;
            begin
                if Number = 1 then
                    frz_PositionLedgerTemp.FindFirst()
                else
                    frz_PositionLedgerTemp.next;

                frz_Divisi := '';
                frz_Location := '';
                frz_NameEmployee := '';
                frz_PositionEmployee.Reset();
                frz_PositionEmployee.SetRange("No.", frz_PositionLedgerTemp."Employee No.");
                if frz_PositionEmployee.FindFirst() then begin
                    frz_Divisi := frz_PositionEmployee."Job Title";
                    frz_Location := frz_PositionEmployee."Office Location Code";
                    frz_NameEmployee := frz_PositionEmployee.FullName();
                end;

                // default value anual month
                AnualMonth[1] := 0;
                AnualMonth[2] := 0;
                AnualMonth[3] := 0;
                AnualMonth[4] := 0;
                AnualMonth[5] := 0;
                AnualMonth[6] := 0;
                AnualMonth[7] := 0;
                AnualMonth[8] := 0;
                AnualMonth[9] := 0;
                AnualMonth[10] := 0;
                AnualMonth[11] := 0;
                AnualMonth[12] := 0;
                // default value Sick month
                SickMonth[1] := 0;
                SickMonth[2] := 0;
                SickMonth[3] := 0;
                SickMonth[4] := 0;
                SickMonth[5] := 0;
                SickMonth[6] := 0;
                SickMonth[7] := 0;
                SickMonth[8] := 0;
                SickMonth[9] := 0;
                SickMonth[10] := 0;
                SickMonth[11] := 0;
                SickMonth[12] := 0;
                // Anual leave
                frz_Starting := 0D;
                frz_Ending := 0D;
                if (frz_PositionLedgerTemp."Contract Start Date" < CalcDate('-CY', DMY2DATE(1, 1, Year))) then
                    frz_Starting := CalcDate('-CY', DMY2DATE(1, 1, Year)) else
                    frz_Starting := frz_PositionLedgerTemp."Contract Start Date";

                if (frz_PositionLedgerTemp."Contract End Date" > CalcDate('CY', DMY2DATE(1, 1, Year))) then
                    frz_Ending := CalcDate('CY', DMY2DATE(1, 1, Year)) else
                    frz_Ending := frz_PositionLedgerTemp."Contract Start Date";

                frz_LeaveLedgerEntry.Reset();
                frz_LeaveLedgerEntry.SetRange("Employee No.", frz_PositionLedgerTemp."Employee No.");
                frz_LeaveLedgerEntry.SetRange("Leave Type", frz_LeaveLedgerEntry."Leave Type"::Paid);
                frz_LeaveLedgerEntry.SetRange("Paid Leave Type", frz_LeaveLedgerEntry."Paid Leave Type"::Annual);
                frz_LeaveLedgerEntry.SetRange("Posting Date", frz_Starting, frz_Ending);
                if frz_LeaveLedgerEntry.FindFirst() then begin

                    repeat
                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 1, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 1, Year))) then
                            AnualMonth[1] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 2, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 2, Year))) then
                            AnualMonth[2] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 3, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 3, Year))) then
                            AnualMonth[3] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 4, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 4, Year))) then
                            AnualMonth[4] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 5, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 5, Year))) then
                            AnualMonth[5] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 6, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 6, Year))) then
                            AnualMonth[6] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 7, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 7, Year))) then
                            AnualMonth[7] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 8, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 8, Year))) then
                            AnualMonth[8] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 9, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 9, Year))) then
                            AnualMonth[9] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 10, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 10, Year))) then
                            AnualMonth[10] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 11, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 11, Year))) then
                            AnualMonth[11] += frz_LeaveLedgerEntry.Quantity;

                        if (frz_LeaveLedgerEntry."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 12, Year))) and
                        (frz_LeaveLedgerEntry."Posting Date" <= CalcDate('CM', DMY2DATE(1, 12, Year))) then
                            AnualMonth[12] += frz_LeaveLedgerEntry.Quantity;

                    until frz_LeaveLedgerEntry.Next = 0;
                    if AnualMonth[1] < 0 then
                        AnualMonth[1] := 0;
                    if AnualMonth[2] < 0 then
                        AnualMonth[2] := 0;
                    if AnualMonth[3] < 0 then
                        AnualMonth[3] := 0;
                    if AnualMonth[4] < 0 then
                        AnualMonth[4] := 0;
                    if AnualMonth[5] < 0 then
                        AnualMonth[5] := 0;
                    if AnualMonth[6] < 0 then
                        AnualMonth[6] := 0;
                    if AnualMonth[7] < 0 then
                        AnualMonth[7] := 0;
                    if AnualMonth[8] < 0 then
                        AnualMonth[8] := 0;
                    if AnualMonth[9] < 0 then
                        AnualMonth[9] := 0;
                    if AnualMonth[10] < 0 then
                        AnualMonth[10] := 0;
                    if AnualMonth[11] < 0 then
                        AnualMonth[11] := 0;
                    if AnualMonth[12] < 0 then
                        AnualMonth[12] := 0;

                    frz_totalAnual := AnualMonth[1] + AnualMonth[2] + AnualMonth[3] + AnualMonth[4] + AnualMonth[5] + AnualMonth[6] + AnualMonth[7] +
                    AnualMonth[8] + AnualMonth[9] + AnualMonth[10] + AnualMonth[11] + AnualMonth[12];
                end;

                // sick leave
                frz_LeaveLedgerEntry2.Reset();
                frz_LeaveLedgerEntry2.SetRange("Employee No.", frz_PositionLedgerTemp."Employee No.");
                frz_LeaveLedgerEntry2.SetRange("Leave Type", frz_LeaveLedgerEntry."Leave Type"::Paid);
                frz_LeaveLedgerEntry2.SetRange("Paid Leave Type", frz_LeaveLedgerEntry."Paid Leave Type"::Sick);
                frz_LeaveLedgerEntry2.SetRange("Posting Date", frz_Starting, frz_Ending);
                if frz_LeaveLedgerEntry2.FindFirst() then begin
                    repeat
                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 1, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 1, Year))) then
                            SickMonth[1] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 2, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 2, Year))) then
                            SickMonth[2] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 3, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 3, Year))) then
                            SickMonth[3] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 4, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 4, Year))) then
                            SickMonth[4] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 5, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 5, Year))) then
                            SickMonth[5] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 6, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 6, Year))) then
                            SickMonth[6] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 7, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 7, Year))) then
                            SickMonth[7] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 8, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 8, Year))) then
                            SickMonth[8] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 9, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 9, Year))) then
                            SickMonth[9] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 10, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 10, Year))) then
                            SickMonth[10] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 11, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 11, Year))) then
                            SickMonth[11] += frz_LeaveLedgerEntry2.Quantity;

                        if (frz_LeaveLedgerEntry2."Posting Date" >= CalcDate('-CM', DMY2DATE(1, 12, Year))) and
                        (frz_LeaveLedgerEntry2."Posting Date" <= CalcDate('CM', DMY2DATE(1, 12, Year))) then
                            SickMonth[12] += frz_LeaveLedgerEntry2.Quantity;

                    until frz_LeaveLedgerEntry2.Next = 0;
                    if SickMonth[1] < 0 then
                        SickMonth[1] := 0;
                    if SickMonth[2] < 0 then
                        SickMonth[2] := 0;
                    if SickMonth[3] < 0 then
                        SickMonth[3] := 0;
                    if SickMonth[4] < 0 then
                        SickMonth[4] := 0;
                    if SickMonth[5] < 0 then
                        SickMonth[5] := 0;
                    if SickMonth[6] < 0 then
                        SickMonth[6] := 0;
                    if SickMonth[7] < 0 then
                        SickMonth[7] := 0;
                    if SickMonth[8] < 0 then
                        SickMonth[8] := 0;
                    if SickMonth[9] < 0 then
                        SickMonth[9] := 0;
                    if SickMonth[10] < 0 then
                        SickMonth[10] := 0;
                    if SickMonth[11] < 0 then
                        SickMonth[11] := 0;
                    if SickMonth[12] < 0 then
                        SickMonth[12] := 0;

                    frz_totalSick := SickMonth[1] + SickMonth[2] + SickMonth[3] + SickMonth[4] + SickMonth[5] + SickMonth[6] + SickMonth[7] +
                    SickMonth[8] + SickMonth[9] + SickMonth[10] + SickMonth[11] + SickMonth[12];
                end;
            end;

            trigger OnPreDataItem()
            var
                frz_Positionledger: Record "Position Ledger Entry";
                frz_Positionledger2: Record "Position Ledger Entry";
            begin
                frz_Positionledger.Reset();
                frz_Positionledger.FilterGroup := -1;
                frz_Positionledger.SetFilter("Contract Start Date", '>= %1 & <= %2', CalcDate('-CY', DMY2DATE(1, 1, Year)), CalcDate('CY', DMY2DATE(1, 1, Year)));
                frz_Positionledger.SetFilter("Contract End Date", '>= %1 & <= %2', CalcDate('-CY', DMY2DATE(1, 1, Year)), CalcDate('CY', DMY2DATE(1, 1, Year)));
                if frz_Positionledger.FindFirst() then begin
                    repeat
                        frz_PositionLedgerTemp.Init();
                        frz_PositionLedgerTemp."Entry No." += 1;
                        frz_PositionLedgerTemp."Employee No." := frz_Positionledger."Employee No.";
                        frz_PositionLedgerTemp."Contract Start Date" := frz_Positionledger."Contract Start Date";
                        frz_PositionLedgerTemp."Contract End Date" := frz_Positionledger."Contract End Date";
                        frz_PositionLedgerTemp.Insert();
                    until frz_Positionledger.Next = 0;
                end;
                frz_Positionledger2.reset;
                frz_Positionledger2.setFilter("Contract Start Date", '< %1', CalcDate('-CY', DMY2DATE(1, 1, Year)));
                frz_Positionledger2.SetFilter("Contract End Date", '> %1', CalcDate('CY', DMY2DATE(1, 1, Year)));
                if frz_Positionledger2.FindFirst() then begin
                    repeat
                        frz_PositionLedgerTemp.Init();
                        if frz_PositionLedgerTemp.FindLast() then
                            frz_PositionLedgerTemp."Entry No." := frz_PositionLedgerTemp."Entry No." + 1 else
                            frz_PositionLedgerTemp."Entry No." := 1;
                        frz_PositionLedgerTemp."Employee No." := frz_Positionledger2."Employee No.";
                        frz_PositionLedgerTemp."Contract Start Date" := frz_Positionledger2."Contract Start Date";
                        frz_PositionLedgerTemp."Contract End Date" := frz_Positionledger2."Contract End Date";
                        frz_PositionLedgerTemp.Insert();
                    until frz_Positionledger2.Next = 0;

                end;
                SetRange(Number, 1, frz_PositionLedgerTemp.Count);
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
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                    }
                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Employeename: text;
        Year: Integer;
        Divisi: text;
        // sick variable
        SickMonth: array[12] of Decimal;
        frz_totalSick: Decimal;
        // anual variable
        AnualMonth: array[12] of Decimal;
        frz_totalAnual: Decimal;
        // contrak table
        frz_EntryNoContrack: Integer;
        frz_Divisi: text;
        frz_Location: Code[50];
        frz_NameEmployee: Text;
        frz_PositionLedgerTemp: Record "Position Ledger Entry" temporary;
        frz_PositionLedgerTemp2: Record "Position Ledger Entry" temporary;


    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}