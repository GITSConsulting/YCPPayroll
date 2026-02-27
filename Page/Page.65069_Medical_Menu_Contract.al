page 65069 "Medical List Contract"
{
    PageType = List;
    UsageCategory = Lists;
    // ApplicationArea = All;
    ApplicationArea = all;
    Caption = 'HR - Master Medical';
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = filter('Kacamata|Persalinan'));
    DelayedInsert = true;
    // CardPageId = "Attendance Registration Card";

    layout
    {
        area(Content)
        {
            group(Header)
            {
                ShowCaption = false;
                field("Contract Start Date"; StartingDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End Date"; EndingDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Plafon; rec.Plafon)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; rec."Quantity 2")
                {
                    Caption = 'Per Year';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    Caption = 'Per Year';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount Prorate"; AmountProrate)
                {
                    ApplicationArea = All;
                    editable = false;
                }
            }
            group("Rawat Jalan")
            {
                field(amountPlafonRawatJalan; amountPlafonRawatJalan)
                {
                    Caption = 'Plafon';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(amountPlafonRawatJalan_Prorate; amountPlafonRawatJalan_Prorate)
                {
                    Caption = 'Plafon Prorate';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group("Rawat Inap - Rate Room")
            {
                field(amountPlafonRateRoomDays; amountPlafonRateRoomDays)
                {
                    Caption = 'Days';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(amountPlafonRateRoom; amountPlafonRateRoom)
                {
                    Caption = 'Plafon';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            group("Rawat Inap - Pembedahan")
            {
                field(amountPlafonPembedahan; amountPlafonPembedahan)
                {
                    Caption = 'Plafon';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(amountPlafonPembedahan_Prorate; amountPlafonPembedahan_Prorate)
                {
                    Caption = 'Plafon Prorate';
                    Editable = false;
                    ApplicationArea = all;
                    // Visible = false;
                }
            }
            group("Rawat Inap - Jasa Perawatan")
            {
                field(amountPlafonJasaPerawatan; amountPlafonJasaPerawatan)
                {
                    Caption = 'Plafon';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(amountPlafonJasaPerawatan_Prorate; amountPlafonJasaPerawatan_Prorate)
                {
                    Caption = 'Plafon Prorate';
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Posting Balance Plafon")
            {
                ApplicationArea = all;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    frz_MedicalValues: Record "Medical Values";
                    frz_MedicalValues_2: Record "Medical Values";
                    frz_MedicalValues_3: Record "Medical Values";
                    frz_MedicalValues_4: Record "Medical Values";
                    frz_MedicalValues_5: Record "Medical Values";

                    MedicalLedgEntry: Record "Medical Reim Ledger Entries";
                    MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

                    frz_employee: Record Employee;
                    EntryNo: Integer;

                    statusPoint: Decimal;
                    frz_StatusPoint: Record "Master Point Status";
                    Window: Dialog;

                    frz_MedicalMasterUpdate: Codeunit "Medical Master Update";
                begin
                    Window.Open('Creating Medical Opening Balance Reimbersement Entries...Please wait..');

                    frz_MedicalMasterUpdate.UpdateSlotPerEmployee(EmployeeNoNya);

                    frz_employee.Reset();
                    frz_employee.SetRange("No.", EmployeeNoNya);
                    frz_employee.SetRange(Status, frz_employee.Status::Active);
                    if frz_employee.FindFirst() then begin
                        frz_StatusPoint.Reset();
                        frz_StatusPoint.SetRange(Code, frz_Employee."Status Point Code");
                        if frz_StatusPoint.FindFirst() then begin
                            if frz_StatusPoint.Point > 0 then
                                StatusPoint := frz_StatusPoint.Point else
                                statusPoint := 1;
                        end else
                            statusPoint := 1;
                    end;

                    frz_MedicalValues.Reset();
                    frz_MedicalValues.SetFilter("Medical Type", '%1|%2', frz_MedicalValues."Medical Type"::Kacamata, frz_MedicalValues."Medical Type"::Persalinan);
                    if frz_MedicalValues.FindFirst() then
                        repeat

                            MedicalLedgEntry2.Reset();
                            if MedicalLedgEntry2.FindLast() then
                                EntryNo := MedicalLedgEntry2."Entry No." + 1
                            else
                                EntryNo := 1;

                            MedicalLedgEntry.Init();
                            MedicalLedgEntry."Entry No." := EntryNo;
                            MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                            MedicalLedgEntry."Document No." := 'OPBAL-CONTRACT';
                            MedicalLedgEntry."Document Date" := Today;
                            MedicalLedgEntry."Employee No." := EmployeeNoNya;
                            MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                            NamaEmployee(EmployeeNoNya);
                            MedicalLedgEntry."Request Approval Date" := today;
                            MedicalLedgEntry."Daily rate - room" := frz_MedicalValues."Daily rate - room";
                            MedicalLedgEntry.Amount := (((12 - NumberMonth) + 1) / 12) * frz_MedicalValues.Plafon;
                            MedicalLedgEntry."Quantity 2" := frz_MedicalValues."Quantity 2";
                            MedicalLedgEntry."Medical Value" := frz_MedicalValues.Code;
                            MedicalLedgEntry."Medical Type" := frz_MedicalValues."Medical Type";
                            MedicalLedgEntry.Insert();

                        until frz_MedicalValues.Next() = 0;

                    frz_MedicalValues_2.Reset();
                    frz_MedicalValues_2.SetRange("Medical Type", frz_MedicalValues_2."Medical Type"::"Rawat Jalan");
                    if frz_MedicalValues_2.FindFirst() then begin
                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;

                        MedicalLedgEntry.Init();
                        MedicalLedgEntry."Entry No." := EntryNo;
                        MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                        MedicalLedgEntry."Document No." := 'OPBAL-CONTRACT';
                        MedicalLedgEntry."Document Date" := Today;
                        MedicalLedgEntry."Employee No." := EmployeeNoNya;
                        MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                        NamaEmployee(EmployeeNoNya);
                        MedicalLedgEntry."Request Approval Date" := today;
                        MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_2."Daily rate - room";
                        MedicalLedgEntry."Basic Amount" := frz_MedicalValues_2.Plafon;
                        MedicalLedgEntry.Amount := (((12 - NumberMonth) + 1) / 12) * (frz_MedicalValues_2.Plafon * StatusPoint);
                        MedicalLedgEntry."Quantity 2" := frz_MedicalValues_2."Quantity 2";
                        MedicalLedgEntry."Medical Type" := frz_MedicalValues_2."Medical Type";
                        MedicalLedgEntry.Insert();
                    end;

                    frz_MedicalValues_3.Reset();
                    frz_MedicalValues_3.SetRange("Medical Type", frz_MedicalValues_3."Medical Type"::"Rawat Inap");
                    frz_MedicalValues_3.SetRange("Daily rate - room", true);
                    if frz_MedicalValues_3.FindFirst() then begin

                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;

                        MedicalLedgEntry.Init();
                        MedicalLedgEntry."Entry No." := EntryNo;
                        MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                        MedicalLedgEntry."Document No." := 'OPBAL-CONTRACT';
                        MedicalLedgEntry."Document Date" := Today;
                        MedicalLedgEntry."Employee No." := EmployeeNoNya;
                        MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                        frz_employee.FullName();
                        MedicalLedgEntry."Request Approval Date" := today;
                        MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_3."Daily rate - room";
                        MedicalLedgEntry."Basic Amount" := frz_MedicalValues_3.Plafon;
                        MedicalLedgEntry."Quantity 2" := frz_MedicalValues_3."Quantity 2";
                        MedicalLedgEntry.Amount := frz_MedicalValues_3.Plafon * frz_MedicalValues_3."Quantity 2";
                        MedicalLedgEntry."Medical Type" := frz_MedicalValues_3."Medical Type";
                        MedicalLedgEntry.Insert();

                    end;

                    frz_MedicalValues_4.Reset();
                    frz_MedicalValues_4.SetRange("Medical Type", frz_MedicalValues_4."Medical Type"::"Rawat Inap");
                    frz_MedicalValues_4.SetRange("Rawat Inat Type", frz_MedicalValues_4."Rawat Inat Type"::"Biaya Jasa Perawatan");
                    frz_MedicalValues_4.SetRange("Daily rate - room", false);
                    if frz_MedicalValues_4.FindFirst() then begin

                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;

                        MedicalLedgEntry.Init();
                        MedicalLedgEntry."Entry No." := EntryNo;
                        MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                        MedicalLedgEntry."Document No." := 'OPBAL-CONTRACT';
                        MedicalLedgEntry."Document Date" := Today;
                        MedicalLedgEntry."Employee No." := EmployeeNoNya;
                        MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                        frz_employee.FullName();
                        MedicalLedgEntry."Request Approval Date" := today;
                        MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_4."Daily rate - room";
                        MedicalLedgEntry."Basic Amount" := frz_MedicalValues_4.Plafon;
                        MedicalLedgEntry."Quantity 2" := frz_MedicalValues_4."Quantity 2";
                        MedicalLedgEntry.Amount := (((12 - NumberMonth) + 1) / 12) * frz_MedicalValues_4.Plafon;
                        MedicalLedgEntry."Medical Type" := frz_MedicalValues_4."Medical Type";
                        MedicalLedgEntry."Rawat Inat Type" := frz_MedicalValues_4."Rawat Inat Type";
                        MedicalLedgEntry.Insert();
                    end;

                    frz_MedicalValues_5.Reset();
                    frz_MedicalValues_5.SetRange("Medical Type", frz_MedicalValues_5."Medical Type"::"Rawat Inap");
                    frz_MedicalValues_5.SetRange("Rawat Inat Type", frz_MedicalValues_5."Rawat Inat Type"::Pembedahan);
                    frz_MedicalValues_5.SetRange("Daily rate - room", false);
                    if frz_MedicalValues_5.FindFirst() then begin

                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;

                        MedicalLedgEntry.Init();
                        MedicalLedgEntry."Entry No." := EntryNo;
                        MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                        MedicalLedgEntry."Document No." := 'OPBAL-CONTRACT';
                        MedicalLedgEntry."Document Date" := Today;
                        MedicalLedgEntry."Employee No." := EmployeeNoNya;
                        MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                        frz_employee.FullName();
                        MedicalLedgEntry."Request Approval Date" := today;
                        MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_5."Daily rate - room";
                        MedicalLedgEntry."Basic Amount" := frz_MedicalValues_5.Plafon;
                        MedicalLedgEntry."Quantity 2" := frz_MedicalValues_5."Quantity 2";
                        MedicalLedgEntry.Amount := (((12 - NumberMonth) + 1) / 12) * frz_MedicalValues_5.Plafon;
                        MedicalLedgEntry."Medical Type" := frz_MedicalValues_5."Medical Type";
                        MedicalLedgEntry."Rawat Inat Type" := frz_MedicalValues_5."Rawat Inat Type";
                        MedicalLedgEntry.Insert();

                    end;
                    Window.Close();
                    Message('Opening Balance Medical Reimbursement Ledger successfully.');
                end;
            }
        }
    }
    var
        StartingDate: Date;
        EndingDate: Date;
        EmployeeNoNya: Code[50];
        AmountProrate: Decimal;
        NumberMonth: Integer;
        amountPlafonRawatJalan: Decimal;
        amountPlafonRawatJalan_Prorate: Decimal;
        amountPlafonRateRoom: Decimal;
        amountPlafonRateRoomDays: Integer;
        amountPlafonRateRoom_Prorate: Decimal;
        amountPlafonPembedahan: Decimal;
        amountPlafonPembedahan_Prorate: Decimal;
        amountPlafonJasaPerawatan: Decimal;
        amountPlafonJasaPerawatan_Prorate: Decimal;

    procedure Contract(EmployeeNo: Code[50])
    var
        frz_PositionLedgerEntry: Record "Position Ledger Entry";
    begin
        frz_PositionLedgerEntry.Reset();
        frz_PositionLedgerEntry.SetRange("Employee No.", EmployeeNo);
        if frz_PositionLedgerEntry.FindLast() then begin
            StartingDate := frz_PositionLedgerEntry."Contract Start Date";
            EndingDate := frz_PositionLedgerEntry."Contract End Date";
            //NumberMonth := Date2DMY(frz_PositionLedgerEntry."Contract Start Date", 2);
            NumberMonth := (DATE2DMY(frz_PositionLedgerEntry."Contract End Date", 3) - DATE2DMY(frz_PositionLedgerEntry."Contract Start Date", 3)) * 12 +
                   (DATE2DMY(frz_PositionLedgerEntry."Contract End Date", 2) - DATE2DMY(frz_PositionLedgerEntry."Contract Start Date", 2));
        end else
            NumberMonth := 1;

        EmployeeNoNya := EmployeeNo;
    end;

    trigger OnAfterGetRecord()
    var
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalValues2: Record "Medical Values";
        frz_MedicalValues3: Record "Medical Values";
        frz_MedicalValues4: Record "Medical Values";
    begin
        amountPlafonRateRoom_Prorate := 0;
        amountPlafonRateRoomDays := 0;
        amountPlafonRawatJalan_Prorate := 0;
        AmountProrate := 0;
        AmountProrate := (((12 - NumberMonth) + 1) / 12) * rec.Plafon;
        // RAWAT JALAN
        frz_MedicalValues.Reset();
        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Jalan");
        if frz_MedicalValues.FindFirst() then
            amountPlafonRawatJalan := frz_MedicalValues.Plafon;
        amountPlafonRawatJalan_Prorate := (((12 - NumberMonth) + 1) / 12) * amountPlafonRawatJalan;

        // RATE ROOM 
        frz_MedicalValues2.Reset();
        frz_MedicalValues2.SetRange("Medical Type", frz_MedicalValues2."Medical Type"::"Rawat Inap");
        frz_MedicalValues2.SetRange("Daily rate - room", true);
        if frz_MedicalValues2.FindFirst() then begin
            amountPlafonRateRoomDays := frz_MedicalValues2."Quantity 2";
            amountPlafonRateRoom := frz_MedicalValues2.Plafon;
        end;
        amountPlafonRateRoom_Prorate := amountPlafonRateRoom;

        // PEMBEDAHAN RAWAT INAP 
        frz_MedicalValues3.Reset();
        frz_MedicalValues3.SetRange("Medical Type", frz_MedicalValues3."Medical Type"::"Rawat Inap");
        frz_MedicalValues3.SetRange("Daily rate - room", false);
        frz_MedicalValues3.SetRange("Rawat Inat Type", frz_MedicalValues3."Rawat Inat Type"::Pembedahan);
        if frz_MedicalValues3.FindFirst() then
            amountPlafonPembedahan := frz_MedicalValues3.Plafon;
        amountPlafonPembedahan_Prorate := (((12 - NumberMonth) + 1) / 12) * amountPlafonPembedahan;

        // JASA PERAWATAN RAWAT INAP 
        frz_MedicalValues4.Reset();
        frz_MedicalValues4.SetRange("Medical Type", frz_MedicalValues4."Medical Type"::"Rawat Inap");
        frz_MedicalValues4.SetRange("Daily rate - room", false);
        frz_MedicalValues4.SetRange("Rawat Inat Type", frz_MedicalValues4."Rawat Inat Type"::"Biaya Jasa Perawatan");
        if frz_MedicalValues4.FindFirst() then
            amountPlafonJasaPerawatan := frz_MedicalValues4.Plafon;
        amountPlafonJasaPerawatan_Prorate := (((12 - NumberMonth) + 1) / 12) * amountPlafonJasaPerawatan;
    end;

    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;
}