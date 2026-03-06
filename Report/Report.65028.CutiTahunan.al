report 65028 CutiTahunan
{
    Caption = 'Cuti Tahunan';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65028CutiTahunan.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(FullName; FullName) { }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);

                column(gYear2; gYear2) { }
                column(gNo; gNo) { }
                column(gStartBalance; gStartBalance) { }
                column(gEndingBalance; gEndingBalance) { }
                column(gJan; gJan) { }
                column(gFeb; gFeb) { }
                column(gMar; gMar) { }
                column(gApr; gApr) { }
                column(gMay; gMay) { }
                column(gJun; gJun) { }
                column(gJul; gJul) { }
                column(gAug; gAug) { }
                column(gSep; gSep) { }
                column(gOct; gOct) { }
                column(gNov; gNov) { }
                column(gDec; gDec) { }
                column(gStartPeriode; gStartPeriode) { }
                column(gEndPeriode; gEndPeriode) { }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 3);
                end;

                trigger OnAfterGetRecord()
                var
                    _LeaveLedgerEntry: Record "Leave Ledger Entry";
                    _PositionLedgerEntry: Record "Position Ledger Entry";
                    _StartDate, _EndDate : Date;
                    _Obal: Decimal;
                begin
                    Clear(gJan);
                    Clear(gFeb);
                    Clear(gMar);
                    Clear(gApr);
                    Clear(gMay);
                    Clear(gJun);
                    Clear(gJul);
                    Clear(gAug);
                    Clear(gSep);
                    Clear(gOct);
                    Clear(gNov);
                    Clear(gDec);
                    if (Number = 1) then
                        gYear2 := gYear - 2
                    else if (Number = 2) then
                        gYear2 := gYear - 1
                    else if (Number = 3) then
                        gYear2 := gYear;

                    gStartBalance := gEndingBalance;
                    _StartDate := DMY2Date(1, 1, gYear2);
                    _EndDate := DMY2Date(31, 12, gYear2);

                    _PositionLedgerEntry.SetRange("Employee No.", Employee."No.");
                    _PositionLedgerEntry.SetRange("Contract Start Date", _StartDate, _EndDate);
                    if _PositionLedgerEntry.FindFirst() then begin
                        gStartPeriode := _PositionLedgerEntry."Contract Start Date";
                        gEndPeriode := _PositionLedgerEntry."Contract End Date";
                    end;

                    _LeaveLedgerEntry.SetRange("Employee No.", Employee."No.");
                    _LeaveLedgerEntry.SetRange("Posting Date", _StartDate, _EndDate);

                    if _LeaveLedgerEntry.FindSet() then
                        repeat
                            if _LeaveLedgerEntry."Document No." <> 'OBAL' then begin
                                if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 1 then
                                    gJan += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 2 then
                                    gFeb += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 3 then
                                    gMar += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 4 then
                                    gApr += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 5 then
                                    gMay += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 6 then
                                    gJun += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 7 then
                                    gJul += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 8 then
                                    gAug += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 9 then
                                    gSep += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 10 then
                                    gOct += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 11 then
                                    gNov += Abs(_LeaveLedgerEntry.Quantity)
                                else if Date2DMY(_LeaveLedgerEntry."Posting Date", 2) = 12 then
                                    gDec += Abs(_LeaveLedgerEntry.Quantity);
                            end else if _LeaveLedgerEntry."Document No." = 'OBAL' then begin
                                _Obal := _LeaveLedgerEntry.Quantity;
                            end;
                        until _LeaveLedgerEntry.Next() = 0;
                    gEndingBalance := gEndingBalance + _Obal - gJan - gFeb - gMar - gApr - gMay - gJun - gJul - gAug - gSep - gOct - gNov - gDec;
                end;
            }

            trigger OnAfterGetRecord()
            var
                _LeaveLedgerEntry: Record "Leave Ledger Entry";
                _StartDate: Date;
            begin
                gNo += 1;
                gStartBalance := 0;
                gEndingBalance := 0;
                _StartDate := DMY2Date(1, 1, gYear2 - 2);
                _LeaveLedgerEntry.SetRange("Employee No.", Employee."No.");
                _LeaveLedgerEntry.SetFilter("Posting Date", '<%1', _StartDate);
                _LeaveLedgerEntry.CalcSums(Quantity);
                gStartBalance := _LeaveLedgerEntry.Quantity;
                gEndingBalance := gStartBalance;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Year; gYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }


    var
        gStartBalance, gEndingBalance : Decimal;
        gJan, gFeb, gMar, gApr, gMay, gJun, gJul, gAug, gSep, gOct, gNov, gDec : Decimal;
        gStartPeriode, gEndPeriode : Date;
        gNo, gYear, gYear2 : Integer;
}
