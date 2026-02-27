page 65041 "MR Line Rawat Inap"
{
    Caption = 'Medical Rawat Inap';
    PageType = ListPart;
    SourceTable = "Medical Reimbursement Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    RefreshOnActivate = true;
    // MultipleNewLines = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
            }
            repeater(Line)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type"::"Rawat Inap")
                {
                    Editable = false;
                    Caption = 'Medical Claim Type';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        recHeader: Record "Medical Reimbursement Header";
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    Editable = false;
                    ApplicationArea = All;
                    TableRelation = "Medical Values".Code where("Medical Type" = const("Rawat Inap"));
                    trigger OnValidate()
                    var
                        recMedicalSlot: Record "Medical Values";
                    begin
                        // get deskripsi medical values
                        recMedicalSlot.SetRange(Code, Rec."Medical Value");
                        if recMedicalSlot.FindFirst() then
                            rec.Description := recMedicalSlot.Description;

                        CurrPage.Update();
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_MEdicalHeader: Record "Medical Reimbursement Header";
                    begin
                        frz_MEdicalHeader.Reset();
                        frz_MEdicalHeader.SetRange("No.", rec."Document No.");
                        if frz_MEdicalHeader.FindFirst() then begin
                            if Rec.Date > frz_MEdicalHeader."Posting Date" then
                                Error('The date must be less than equal to Posting Date header');
                        end;
                    end;
                }
                field(frz_Days; frz_Days)
                {
                    Caption = 'Basic Days';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(frz_CurrentBalance_ledger_room_days; frz_CurrentBalance_ledger_room_days)
                {
                    Caption = 'Days Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_Days_prosess; frz_Days_prosess)
                {
                    Caption = 'Days in Process';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_DaysBalance; frz_DaysBalance)
                {
                    Caption = 'Total Days Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Basic Plafon"; frz_BasicPlafon)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(frz_CurrentBalance; frz_CurrentBalance)
                {
                    Caption = 'Balance Plafon';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(Plafon; frz_Plafon)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(Day; rec."Quantity 2")
                {
                    ApplicationArea = all;
                    Editable = frz_DailyRoom;
                    trigger OnValidate()
                    var
                        frz_PersentaseStatusPasien: Record "Percentage Status Patient";
                        frz_MedicalHeder: Record "Medical Reimbursement Header";
                        frz_persentasinya: Decimal;
                        frz_MedicalLines: Record "Medical Reimbursement Line";
                    begin
                        rec.TestField(Date);

                        if frz_DaysBalance = 0 then begin
                            if (rec."Quantity 2" = 0) or (rec."Quantity 2" <= xRec."Quantity 2") then
                                rec."Quantity 2" := rec."Quantity 2"
                            else
                                Error('Balance Days = 0');
                        end else begin
                            if rec."Quantity 2" >= frz_DaysBalance then begin
                                rec."Quantity 2" := frz_DaysBalance + xRec."Quantity 2";
                            end else begin
                                rec."Quantity 2" := rec."Quantity 2";
                            end;
                        end;
                        frz_DaysBalance := frz_DaysBalance - rec."Quantity 2";


                        // CheckClaimAmount();
                        if rec."Quantity 2" <> xRec."Quantity 2" then begin
                            rec."Claim Amount" := 0;
                            rec."Paid Amount" := 0;
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Claim Amount"; rec."Claim Amount")
                {
                    Caption = 'Claim Amount per-Day';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.TestField(Date);
                        CheckClaimAmount();
                        CurrPage.Update();
                    end;
                }
                field("Paid Amount Per-Day"; frz_PaidAmountDay)
                {
                    Caption = 'Paid Amount per-Day';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Paid Amount"; rec."Paid Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('FUND CODE'));
                    trigger OnValidate()
                    begin
                        // medicalTypeNotBlank();
                    end;
                }
            }
            group(Total)
            {
                // ShowCaption = false;
                Caption = 'Balance Except Daily - Rate Room';
                field(frz_BasicPlafon22; frz_BasicPlafon22)
                {
                    Caption = 'Basic Plafon';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(amountLedger; amountLedger)
                {
                    Caption = 'Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_CurrentBalance_prosess; frz_CurrentBalance_prosess)
                {
                    Caption = 'Plafon in Process';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BalanceAL; frz_CurrentBalance)
                {
                    Caption = 'Total Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            group("Daily - Rate Room")
            {
                // ShowCaption = false;
                field(frz_Dayss; frz_Days)
                {
                    Caption = 'Basic Days';
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field(frz_BasicPlafonROOMNYA; frz_BasicPlafonROOMNYA)
                {
                    Caption = 'Basic Plafon';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field(frz_CurrentBalance_ledger_room; frz_CurrentBalance_ledger_room)
                {
                    Caption = 'Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(frz_CurrentBalance_prosess_room; frz_CurrentBalance_prosess_room)
                {
                    Caption = 'Plafon in Process';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BalanceRateRoom2; frz_CurrentBalanceROOM)
                {
                    Caption = 'Total Plafon Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    var
        frz_Plafon: Decimal;
        frz_BasicPlafon: Decimal;
        frz_CurrentBalance: decimal;
        frz_CurrentBalanceROOM: decimal;
        frz_Days: decimal;
        frz_Days_prosess: decimal;
        frz_DaysBalance: Decimal;
        frz_DailyRoom: Boolean;
        frz_PaidAmountDay: Decimal;

        frz_TotalPaidCurrent: Decimal;
        frz_TotalPaidCurrentROOM: Decimal;
        frz_BasicPlafonROOMNYA: Decimal;
        frz_BasicPlafon22: Decimal;
        frz_LedgerMedical: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_2: Record "Medical Reim Ledger Entries";
        frz_LedgerMedical_3: Record "Medical Reim Ledger Entries";
        frz_CurrentBalance_prosess: Decimal;
        frz_CurrentBalance_prosess_room: Decimal;
        frz_CurrentBalance_ledger_room: Decimal;
        frz_CurrentBalance_ledger_room_days: Decimal;
        amountLedger: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues2: Record "Medical Values";
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_MedicalLines2: Record "Medical Reimbursement Line";

        frz_MedicalLinesdibawah: Record "Medical Reimbursement Line";
        frz_MedicalValuesdibawah: Record "Medical Values";

        frz_MedicalLinesdibawah2: Record "Medical Reimbursement Line";
        frz_MedicalValuesdibawah2: Record "Medical Values";

        frz_MedicalLines_proses: Record "Medical Reimbursement Line";
        frz_MedicalHeader_proses: Record "Medical Reimbursement Header";

        frz_MedicalLines_proses_room: Record "Medical Reimbursement Line";
        frz_MedicalHeader_proses_room: Record "Medical Reimbursement Header";
    begin
        frz_DailyRoom := Rec."Daily rate - room";

        // get plafon dan basic plafonnya
        frz_Plafon := 0;
        frz_BasicPlafon := 0;
        frz_PaidAmountDay := 0;
        frz_Days := 0;
        frz_DaysBalance := 0;
        frz_TotalPaidCurrentROOM := 0;
        frz_CurrentBalanceROOM := 0;
        frz_TotalPaidCurrent := 0;
        frz_CurrentBalance := 0;
        amountLedger := 0;

        frz_MedicalLinesdibawah.reset();
        frz_MedicalLinesdibawah.SetRange("Document No.", rec."Document No.");
        frz_MedicalLinesdibawah.SetRange("Daily rate - room", false);
        if frz_MedicalLinesdibawah.FindFirst() then begin
            frz_MedicalValuesdibawah.Reset();
            frz_MedicalValuesdibawah.SetRange(Code, frz_MedicalLinesdibawah."Medical Value");
            frz_MedicalValuesdibawah.SetRange("Rawat Inat Type", frz_MedicalLinesdibawah."Rawat Inat Type");
            frz_MedicalValuesdibawah.SetRange("Daily rate - room", false);
            if frz_MedicalValuesdibawah.FindFirst() then begin
                frz_BasicPlafon22 := frz_MedicalValuesdibawah.Plafon;
            end;
        end;

        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
        frz_MedicalValues.SetRange("Daily rate - room", false);
        if rec."Rawat Inat Type" = rec."Rawat Inat Type"::Pembedahan then begin
            frz_MedicalValues.SetFilter("Rawat Inat Type", '<> %1', rec."Rawat Inat Type"::"Biaya Jasa Perawatan");
        end else begin
            frz_MedicalValues.SetFilter("Rawat Inat Type", '<> %1', rec."Rawat Inat Type"::Pembedahan);
        end;
        if frz_MedicalValues.FindFirst() then begin
            frz_BasicPlafon := frz_MedicalValues.Plafon;

            frz_Plafon := frz_BasicPlafon;

            // total paid current except room
            frz_MedicalLines.Reset();
            frz_MedicalLines.SetRange("Document No.", rec."Document No.");
            frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
            frz_MedicalLines.SetRange("Daily rate - room", false);
            if frz_MedicalLines.FindFirst() then
                repeat
                    frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
                until frz_MedicalLines.Next() = 0;

            // proses balance document
            frz_CurrentBalance_prosess := 0;
            frz_MedicalHeader_proses.Reset();
            frz_MedicalHeader_proses.SetFilter(Status, '<> %1', frz_MedicalHeader_proses.Status::Open);
            frz_MedicalHeader_proses.SetFilter("No.", '<> %1', rec."Document No.");
            frz_MedicalHeader_proses.SetFilter("Employee No.", rec."Employee No.");
            frz_MedicalHeader_proses.SetRange("Medical Type 3", true);
            if frz_MedicalHeader_proses.FindFirst() then
                repeat
                    frz_MedicalLines_proses.Reset();
                    frz_MedicalLines_proses.SetRange("Document No.", frz_MedicalHeader_proses."No.");
                    frz_MedicalLines_proses.SetRange("Medical Type", frz_MedicalLines_proses."Medical Type"::"Rawat Inap");
                    frz_MedicalLines_proses.SetRange("Daily rate - room", false);
                    if frz_MedicalLines_proses.FindFirst() then
                        repeat
                            frz_CurrentBalance_prosess += frz_MedicalLines_proses."Paid Amount";
                        until frz_MedicalLines_proses.Next() = 0;
                until frz_MedicalHeader_proses.Next() = 0;
            // ROOM 
            frz_CurrentBalance_prosess_room := 0;
            frz_Days_prosess := 0;
            frz_MedicalHeader_proses_room.Reset();
            frz_MedicalHeader_proses_room.SetFilter(Status, '<> %1', frz_MedicalHeader_proses_room.Status::Open);
            frz_MedicalHeader_proses_room.SetFilter("No.", '<> %1', rec."Document No.");
            frz_MedicalHeader_proses_room.SetFilter("Employee No.", rec."Employee No.");
            frz_MedicalHeader_proses_room.SetRange("Medical Type 3", true);
            if frz_MedicalHeader_proses_room.FindFirst() then
                repeat
                    frz_MedicalLines_proses_room.Reset();
                    frz_MedicalLines_proses_room.SetRange("Document No.", frz_MedicalHeader_proses_room."No.");
                    frz_MedicalLines_proses_room.SetRange("Medical Type", frz_MedicalLines_proses_room."Medical Type"::"Rawat Inap");
                    frz_MedicalLines_proses_room.SetRange("Daily rate - room", true);
                    if frz_MedicalLines_proses_room.FindFirst() then
                        repeat
                            frz_CurrentBalance_prosess_room += frz_MedicalLines_proses_room."Paid Amount";
                            frz_Days_prosess += frz_MedicalLines_proses_room."Quantity 2";
                        until frz_MedicalLines_proses_room.Next() = 0;
                until frz_MedicalHeader_proses_room.Next() = 0;
            // proses balance document tutup

            frz_LedgerMedical.Reset();
            frz_LedgerMedical.SetRange("Employee No.", rec."Employee No.");
            frz_LedgerMedical.SetRange("Medical Type", frz_LedgerMedical."Medical Type"::"Rawat Inap");
            frz_LedgerMedical.SetRange("Daily rate - room", false);
            frz_LedgerMedical.SetRange("Rawat Inat Type", frz_MedicalValues."Rawat Inat Type");
            frz_LedgerMedical.CalcSums(Amount);
            amountLedger := frz_LedgerMedical.Amount;
        end;
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        frz_CurrentBalance_ledger_room := 0;
        frz_CurrentBalance_ledger_room_days := 0;
        frz_MedicalLinesdibawah2.reset();
        frz_MedicalLinesdibawah2.SetRange("Document No.", rec."Document No.");
        frz_MedicalLinesdibawah2.SetRange("Daily rate - room", true);
        if frz_MedicalLinesdibawah2.FindFirst() then begin
            // get balance dari rate room
            frz_MedicalValues2.Reset();
            frz_MedicalValues2.SetRange("Medical Type", frz_MedicalLinesdibawah2."Medical Type");
            frz_MedicalValues2.SetRange(Code, frz_MedicalLinesdibawah2."Medical Value");
            frz_MedicalValues2.SetRange("Daily rate - room", true);
            if frz_MedicalValues2.FindFirst() then begin
                frz_Days := frz_MedicalValues2."Quantity 2";

                // total paid current room
                frz_MedicalLines2.Reset();
                frz_MedicalLines2.SetRange("Document No.", rec."Document No.");
                frz_MedicalLines2.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
                frz_MedicalLines2.SetRange("Daily rate - room", true);
                if frz_MedicalLines2.FindFirst() then
                    repeat
                        frz_TotalPaidCurrentROOM += frz_MedicalLines2."Paid Amount";
                    until frz_MedicalLines2.Next() = 0;

                frz_LedgerMedical_2.Reset();
                frz_LedgerMedical_2.SetRange("Employee No.", rec."Employee No.");
                frz_LedgerMedical_2.SetRange("Medical Type", frz_LedgerMedical_2."Medical Type"::"Rawat Inap");
                frz_LedgerMedical_2.SetRange("Daily rate - room", true);
                frz_LedgerMedical_2.CalcSums("Quantity 2");
                frz_LedgerMedical_2.CalcSums(Amount);
                frz_CurrentBalance_ledger_room := frz_LedgerMedical_2.Amount;
                frz_CurrentBalance_ledger_room_days := frz_LedgerMedical_2."Quantity 2";

                frz_LedgerMedical_3.Reset();
                frz_LedgerMedical_3.SetRange("Employee No.", rec."Employee No.");
                frz_LedgerMedical_3.SetRange("Medical Type", frz_LedgerMedical_2."Medical Type"::"Rawat Inap");
                frz_LedgerMedical_3.SetRange("Daily rate - room", true);
                frz_LedgerMedical_3.SetFilter("Basic Amount", '<> %1', 0);
                if frz_LedgerMedical_3.FindLast() then
                    frz_BasicPlafonROOMNYA := frz_LedgerMedical_3."Basic Amount";
            end;
        end;
        // itung days balance
        if rec."Daily rate - room" = true then begin

            frz_DaysBalance := frz_LedgerMedical_2."Quantity 2" - rec."Quantity 2" - frz_Days_prosess;
            // Paid Amount Per-Day 
            if rec."Claim Amount" >= frz_BasicPlafonROOMNYA then begin
                frz_PaidAmountDay := frz_BasicPlafonROOMNYA;
            end else begin
                frz_PaidAmountDay := rec."Claim Amount";
            end;

        end else begin
            frz_PaidAmountDay := 0;
            frz_DaysBalance := 0;
        end;

        // amount balance
        frz_CurrentBalance := amountLedger - frz_TotalPaidCurrent - frz_CurrentBalance_prosess;
        frz_CurrentBalanceROOM := frz_LedgerMedical_2.Amount - frz_MedicalLinesdibawah2."Paid Amount" - frz_CurrentBalance_prosess_room;
    end;

    procedure CheckClaimAmount()
    var
        frz_MedicalLines: Record "Medical Reimbursement Line";
        frz_PersentaseStatusPasien: Record "Percentage Status Patient";
        frz_MedicalHeder: Record "Medical Reimbursement Header";
        frz_persentasinya: Decimal;
        frz_DayNya: Decimal;
    begin
        frz_persentasinya := 1;
        frz_MedicalHeder.reset;
        frz_MedicalHeder.SetRange("No.", rec."Document No.");
        if frz_MedicalHeder.FindFirst() then
            frz_MedicalHeder.FindFirst();

        frz_PersentaseStatusPasien.Reset();
        frz_PersentaseStatusPasien.SetRange(Code, frz_MedicalHeder."Status Patient");
        if frz_PersentaseStatusPasien.FindFirst() then begin
            if frz_PersentaseStatusPasien.Percentage > 0 then
                frz_persentasinya := frz_PersentaseStatusPasien.Percentage / 100;
        end else
            frz_persentasinya := 1;

        if rec."Quantity 2" = 0 then frz_DayNya := 1 else frz_DayNya := rec."Quantity 2";

        if rec."Daily rate - room" = false then begin

            if frz_CurrentBalance = 0 then begin
                if (rec."Claim Amount" = 0) or (rec."Claim Amount" < rec."Paid Amount") then begin
                    Rec."Paid Amount" := rec."Claim Amount" * frz_persentasinya;
                end;
            end else begin
                if rec."Claim Amount" >= frz_CurrentBalance + rec."Paid Amount" then begin
                    rec."Paid Amount" := ((frz_CurrentBalance + rec."Paid Amount") * frz_persentasinya);
                end else begin
                    Rec."Paid Amount" := (rec."Claim Amount" * frz_persentasinya);
                end;
            end;

        end else begin

            if rec."Quantity 2" = 0 then
                Error('Your day = 0')
            else begin
                if frz_CurrentBalanceROOM = 0 then begin
                    if (rec."Claim Amount" = 0) or (rec."Claim Amount" < frz_BasicPlafonROOMNYA) then begin
                        Rec."Paid Amount" := (rec."Claim Amount" * frz_persentasinya) * frz_DayNya;
                        frz_PaidAmountDay := (rec."Claim Amount" * frz_persentasinya);
                    end else
                        Rec."Paid Amount" := (frz_BasicPlafonROOMNYA * frz_persentasinya) * frz_DayNya;
                end else begin
                    if rec."Claim Amount" >= frz_BasicPlafonROOMNYA then begin
                        frz_PaidAmountDay := (frz_BasicPlafonROOMNYA * frz_persentasinya);
                        rec."Paid Amount" := (frz_BasicPlafonROOMNYA * frz_persentasinya) * frz_DayNya;
                    end else begin
                        frz_PaidAmountDay := (rec."Claim Amount" * frz_persentasinya);
                        Rec."Paid Amount" := (rec."Claim Amount" * frz_persentasinya) * frz_DayNya;
                    end;
                end;
            end;

        end;

        frz_MedicalLines.Reset();
        frz_MedicalLines.SetRange("Document No.", rec."Document No.");
        frz_MedicalLines.SetRange("Medical Type", Rec."Medical Type"::"Rawat Inap");
        frz_MedicalLines.SetRange("Daily rate - room", false);
        if frz_MedicalLines.FindFirst() then
            repeat
                frz_TotalPaidCurrent += frz_MedicalLines."Paid Amount";
            until frz_MedicalLines.Next() = 0;

        // if rec."Daily rate - room" = false then
        //     frz_CurrentBalance := frz_Plafon - (frz_CurrentBalance + frz_TotalPaidCurrent) else
        //     frz_CurrentBalanceROOM := frz_PlafonROOM - (frz_CurrentBalanceROOM + rec."Paid Amount");
        CurrPage.Update();
    end;
}
