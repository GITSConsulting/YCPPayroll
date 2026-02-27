codeunit 65000 "Proses Medical Reimbersement"
{
    procedure PostedMedical(frz_MedicalReimbursement: Record "Medical Reimbursement Header")
    var
        frz_MedicalLine: Record "Medical Reimbursement Line";

        frz_PostedMedicalHeader: Record "Posted MR Header";
        frz_PostedMedicalLine: Record "Posted MR Line";
    begin
        frz_PostedMedicalHeader.Init();
        frz_PostedMedicalHeader.TransferFields(frz_MedicalReimbursement);
        frz_PostedMedicalHeader.Insert();

        frz_MedicalLine.Reset();
        frz_MedicalLine.SetRange("Document No.", frz_MedicalReimbursement."No.");
        if frz_MedicalLine.FindFirst() then begin

            repeat
                frz_PostedMedicalLine.Init();
                frz_PostedMedicalLine.TransferFields(frz_MedicalLine);
                frz_PostedMedicalLine.Insert();
            until frz_MedicalLine.Next() = 0;
        end;

        createMedicalBalance(frz_MedicalReimbursement);
    end;

    procedure createMedicalBalance(MedicalReqHeader: Record "Medical Reimbursement Header")
    var
        MedicalLine: Record "Medical Reimbursement Line";
        MedicalLine2: Record "Medical Reimbursement Line";
        MedicalLedgEntry: Record "Medical Reim Ledger Entries";
        MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

        MediLineLedgEntry: Record "Medical Line Ledger Entries";
        MedicaLineLedgEntry2: Record "Medical Line Ledger Entries";
        frz_LedgerMedical_3: Record "Medical Reim Ledger Entries";
        EntryNoDetailed: Integer;
        StringDate: Text;

        EntryNo: Integer;
        Window: Dialog;
    begin
        Window.Open('Creating Medical Reimbersement Entries...Please wait..');

        MedicalReqHeader."Approval Date" := MedicalReqHeader."Document Date";
        MedicalReqHeader."Expired Date" := MedicalReqHeader."Document Date" + 30;
        MedicalReqHeader.Status := MedicalReqHeader.Status::Released;

        MedicalReqHeader."Posted Document" := true;
        MedicalReqHeader.Modify();

        MedicalLine2.Reset();
        MedicalLine2.SetRange("Document No.", MedicalReqHeader."No.");
        if MedicalLine2.FindFirst() then
            repeat
                MedicalLine2.Reversed := true;
                MedicalLine2.Modify();
            until MedicalLine2.Next() = 0;


        MedicalLine.Reset();
        MedicalLine.SetRange("Document No.", MedicalReqHeader."No.");
        MedicalLine.FindSet();
        repeat
            MedicalLedgEntry2.Reset();
            if MedicalLedgEntry2.FindLast() then
                EntryNo := MedicalLedgEntry2."Entry No." + 1
            else
                EntryNo := 1;

            MedicalLedgEntry.Init();
            MedicalLedgEntry."Entry No." := EntryNo;
            MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
            MedicalLedgEntry."Document No." := MedicalReqHeader."No.";
            MedicalLedgEntry."Document Date" := MedicalLine.Date;

            if MedicalLine."Medical Type" = MedicalLine."Medical Type"::Kacamata then begin
                frz_LedgerMedical_3.Reset();
                frz_LedgerMedical_3.SetRange("Employee No.", MedicalReqHeader."Employee No.");
                frz_LedgerMedical_3.SetRange("Document No.", 'OPBAL');
                frz_LedgerMedical_3.SetRange("Medical Type", frz_LedgerMedical_3."Medical Type"::Kacamata);
                frz_LedgerMedical_3.SetRange("Medical Value", MedicalLine."Medical Value");
                if frz_LedgerMedical_3.FindLast() then begin
                    StringDate := '+' + Format(frz_LedgerMedical_3."Quantity 2") + 'Y';
                    MedicalLedgEntry."expired date optical" := CalcDate(StringDate, MedicalLine.Date);
                end else
                    MedicalLedgEntry."expired date optical" := Today;
            end;

            MedicalLedgEntry."Employee No." := MedicalReqHeader."Employee No.";
            MedicalLedgEntry."Daily rate - room" := MedicalLine."Daily rate - room";
            MedicalLedgEntry."Description" := 'Medical Reimbersement of ' +
            MedicalReqHeader.NamaEmployee(MedicalReqHeader."Employee No.");
            MedicalLedgEntry."Request Approval Date" := MedicalReqHeader."Approval Date";
            MedicalLedgEntry."Request Expired Date" := MedicalReqHeader."Expired Date";
            MedicalLedgEntry.Amount := MedicalLine."Paid Amount" * -1;
            MedicalLedgEntry."Quantity 2" := MedicalLine."Quantity 2" * -1;
            MedicalLedgEntry."Medical Value" := MedicalLine."Medical Value";
            MedicalLedgEntry."Medical Type" := MedicalLine."Medical Type";
            MedicalLedgEntry."Rawat Inat Type" := MedicalLine."Rawat Inat Type";
            MedicalLedgEntry.Insert();
        until MedicalLine.Next() = 0;

        MedicalReqHeader.Delete();
        MedicalLine.DeleteAll();

        Window.Close();
        Message('Medical reimbursement successfully posted.');
    end;

    procedure undoProcessMedicalBalance(DocNo: Code[20])
    var
        MedicalReqHeader: Record "Posted MR Header";
        MedicalLine: Record "Posted MR Line";
        MedicalLine2: Record "Posted MR Line";
        MedicalLedgEntry: Record "Medical Reim Ledger Entries";
        MedicalLedgEntryReversal: Record "Medical Reim Ledger Entries";
        MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

        DetailedMedicalLedgEntry: Record "Medical Line Ledger Entries";
        UpdateDetailedMedicalLedgEntry: Record "Medical Line Ledger Entries";
        DetailedMedicalLedgEntryReversal: Record "Medical Line Ledger Entries";
        DetailedMedicalLedgEntry2: Record "Medical Line Ledger Entries";
        EntryNoDetailed: Integer;

        EntryNo: Integer;
        Window: Dialog;
    begin
        Window.Open('Undoing balance....please wait..');

        MedicalReqHeader.Get(DocNo);
        MedicalReqHeader.Reversed := true;
        MedicalReqHeader.Modify();

        MedicalLine2.Reset();
        MedicalLine2.SetRange("Document No.", MedicalReqHeader."No.");
        if MedicalLine2.FindFirst() then
            repeat
                MedicalLine2.Reversed := true;
                MedicalLine2.Modify();
            until MedicalLine2.Next() = 0;

        MedicalLedgEntry.Reset();
        MedicalLedgEntry.SetRange("Document No.", DocNo);
        MedicalLedgEntry.SetRange("Entry Type", MedicalLedgEntry."Entry Type"::Negative);
        MedicalLedgEntry.FindFirst();
        repeat
            MedicalLedgEntry2.Reset();
            if MedicalLedgEntry2.FindLast() then
                EntryNo := MedicalLedgEntry2."Entry No." + 1
            else
                EntryNo := 1;
            //create record reversal-nya
            MedicalLedgEntryReversal.Init();
            MedicalLedgEntryReversal.TransferFields(MedicalLedgEntry);
            MedicalLedgEntryReversal."Entry No." := EntryNo;
            MedicalLedgEntryReversal."Reversal Entry" := true;
            MedicalLedgEntryReversal."Entry Type" := MedicalLedgEntryReversal."Entry Type"::Positive;
            MedicalLedgEntryReversal.Description := 'REVERSAL ENTRY';
            MedicalLedgEntryReversal.Amount := MedicalLedgEntry.Amount * -1;
            MedicalLedgEntryReversal."Quantity 2" := MedicalLedgEntry."Quantity 2" * -1;
            MedicalLedgEntryReversal.Insert();
        until MedicalLedgEntry.Next() = 0;
        Window.Close();
    end;

    procedure MedicalOpenBalanceNewYear()
    var
        frz_employee: Record Employee;
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalValues_2: Record "Medical Values";
        frz_MedicalValues_3: Record "Medical Values";
        frz_MedicalValues_4: Record "Medical Values";
        frz_MedicalValues_5: Record "Medical Values";
        MedicalLedgEntry: Record "Medical Reim Ledger Entries";
        MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

        frz_LedgerMedicalOld: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_2: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_3: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_4: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_5: Record "Medical Reim Ledger Entries";

        EntryNo: Integer;
        Window: Dialog;

        statusPoint: Decimal;
        frz_StatusPoint: Record "Master Point Status";
    begin
        statusPoint := 1;
        Window.Open('Creating Medical Opening Balance Reimbersement Entries...Please wait..');
        frz_employee.Reset();
        frz_employee.SetRange(Status, frz_employee.Status::Active);
        if frz_employee.FindFirst() then
            repeat
                frz_StatusPoint.Reset();
                frz_StatusPoint.SetRange(Code, frz_Employee."Status Point Code");
                if frz_StatusPoint.FindFirst() then begin
                    if frz_StatusPoint.Point > 0 then
                        StatusPoint := frz_StatusPoint.Point else
                        statusPoint := 1;
                end else
                    statusPoint := 1;

                frz_MedicalValues.Reset();
                frz_MedicalValues.SetFilter("Medical Type", '%1|%2', frz_MedicalValues."Medical Type"::Kacamata, frz_MedicalValues."Medical Type"::Persalinan);
                if frz_MedicalValues.FindFirst() then
                    repeat

                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;

                        frz_LedgerMedicalOld.Reset();
                        frz_LedgerMedicalOld.SetRange("Employee No.", frz_employee."No.");
                        frz_LedgerMedicalOld.SetRange("Medical Type", frz_MedicalValues."Medical Type");
                        frz_LedgerMedicalOld.SetRange("Medical Value", frz_MedicalValues.Code);
                        frz_LedgerMedicalOld.CalcSums(Amount);

                        MedicalLedgEntry.Init();
                        MedicalLedgEntry."Entry No." := EntryNo;
                        MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                        MedicalLedgEntry."Document No." := 'OPBAL';
                        MedicalLedgEntry."Document Date" := Today;
                        MedicalLedgEntry."Employee No." := frz_employee."No.";
                        MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                        frz_employee.FullName();
                        MedicalLedgEntry."Request Approval Date" := today;
                        MedicalLedgEntry."Daily rate - room" := frz_MedicalValues."Daily rate - room";
                        MedicalLedgEntry.Amount := frz_MedicalValues.Plafon - frz_LedgerMedicalOld.Amount;
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

                    frz_LedgerMedicalOld_2.Reset();
                    frz_LedgerMedicalOld_2.SetRange("Employee No.", frz_employee."No.");
                    frz_LedgerMedicalOld_2.SetRange("Medical Type", frz_MedicalValues_2."Medical Type");
                    frz_LedgerMedicalOld_2.CalcSums(Amount);

                    MedicalLedgEntry.Init();
                    MedicalLedgEntry."Entry No." := EntryNo;
                    MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                    MedicalLedgEntry."Document No." := 'OPBAL';
                    MedicalLedgEntry."Document Date" := Today;
                    MedicalLedgEntry."Employee No." := frz_employee."No.";
                    MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                    frz_employee.FullName();
                    MedicalLedgEntry."Request Approval Date" := today;
                    MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_2."Daily rate - room";
                    MedicalLedgEntry."Basic Amount" := frz_MedicalValues_2.Plafon;
                    MedicalLedgEntry.Amount := (frz_MedicalValues_2.Plafon * StatusPoint) - frz_LedgerMedicalOld_2.Amount;
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

                    frz_LedgerMedicalOld_3.Reset();
                    frz_LedgerMedicalOld_3.SetRange("Employee No.", frz_employee."No.");
                    frz_LedgerMedicalOld_3.SetRange("Medical Type", frz_MedicalValues_3."Medical Type");
                    frz_LedgerMedicalOld_3.SetRange("Daily rate - room", true);
                    frz_LedgerMedicalOld_3.CalcSums(Amount);
                    frz_LedgerMedicalOld_3.CalcSums("Quantity 2");

                    MedicalLedgEntry.Init();
                    MedicalLedgEntry."Entry No." := EntryNo;
                    MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                    MedicalLedgEntry."Document No." := 'OPBAL';
                    MedicalLedgEntry."Document Date" := Today;
                    MedicalLedgEntry."Employee No." := frz_employee."No.";
                    MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                    frz_employee.FullName();
                    MedicalLedgEntry."Request Approval Date" := today;
                    MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_3."Daily rate - room";
                    MedicalLedgEntry."Basic Amount" := frz_MedicalValues_3.Plafon;
                    MedicalLedgEntry."Quantity 2" := frz_MedicalValues_3."Quantity 2" - frz_LedgerMedicalOld_3."Quantity 2";
                    MedicalLedgEntry.Amount := (frz_MedicalValues_3.Plafon * frz_MedicalValues_3."Quantity 2") - frz_LedgerMedicalOld_3.Amount;
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

                    frz_LedgerMedicalOld_4.Reset();
                    frz_LedgerMedicalOld_4.SetRange("Employee No.", frz_employee."No.");
                    frz_LedgerMedicalOld_4.SetRange("Medical Type", frz_MedicalValues_4."Medical Type");
                    frz_LedgerMedicalOld_4.SetRange("Rawat Inat Type", frz_MedicalValues_4."Rawat Inat Type");
                    frz_LedgerMedicalOld_4.SetRange("Daily rate - room", false);
                    frz_LedgerMedicalOld_4.CalcSums(Amount);

                    MedicalLedgEntry.Init();
                    MedicalLedgEntry."Entry No." := EntryNo;
                    MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                    MedicalLedgEntry."Document No." := 'OPBAL';
                    MedicalLedgEntry."Document Date" := Today;
                    MedicalLedgEntry."Employee No." := frz_employee."No.";
                    MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                    frz_employee.FullName();
                    MedicalLedgEntry."Request Approval Date" := today;
                    MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_4."Daily rate - room";
                    MedicalLedgEntry."Basic Amount" := frz_MedicalValues_4.Plafon;
                    MedicalLedgEntry."Quantity 2" := frz_MedicalValues_4."Quantity 2";
                    MedicalLedgEntry.Amount := frz_MedicalValues_4.Plafon - frz_LedgerMedicalOld_4.Amount;
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

                    frz_LedgerMedicalOld_5.Reset();
                    frz_LedgerMedicalOld_5.SetRange("Employee No.", frz_employee."No.");
                    frz_LedgerMedicalOld_5.SetRange("Medical Type", frz_MedicalValues_5."Medical Type");
                    frz_LedgerMedicalOld_5.SetRange("Rawat Inat Type", frz_MedicalValues_5."Rawat Inat Type");
                    frz_LedgerMedicalOld_5.SetRange("Daily rate - room", false);
                    frz_LedgerMedicalOld_5.CalcSums(Amount);

                    MedicalLedgEntry.Init();
                    MedicalLedgEntry."Entry No." := EntryNo;
                    MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Positive;
                    MedicalLedgEntry."Document No." := 'OPBAL';
                    MedicalLedgEntry."Document Date" := Today;
                    MedicalLedgEntry."Employee No." := frz_employee."No.";
                    MedicalLedgEntry."Description" := 'Opening Medical Reimbersement of ' +
                    frz_employee.FullName();
                    MedicalLedgEntry."Request Approval Date" := today;
                    MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_5."Daily rate - room";
                    MedicalLedgEntry."Basic Amount" := frz_MedicalValues_5.Plafon;
                    MedicalLedgEntry."Quantity 2" := frz_MedicalValues_5."Quantity 2";
                    MedicalLedgEntry.Amount := frz_MedicalValues_5.Plafon - frz_LedgerMedicalOld_5.Amount;
                    MedicalLedgEntry."Medical Type" := frz_MedicalValues_5."Medical Type";
                    MedicalLedgEntry."Rawat Inat Type" := frz_MedicalValues_5."Rawat Inat Type";
                    MedicalLedgEntry.Insert();

                end;

            until frz_employee.Next() = 0;
        Window.Close();
        Message('Opening Balance Medical Reimbursement Ledger successfully.');
    end;

    // RESET BALANCE EMPLOYEE WHEN CONTRACT ENDED  
    procedure MedicalResetBalanceEmployee(employeeNo: Code[20])
    var
        frz_employee: Record Employee;
        frz_MedicalValues: Record "Medical Values";
        frz_MedicalValues_2: Record "Medical Values";
        frz_MedicalValues_3: Record "Medical Values";
        frz_MedicalValues_4: Record "Medical Values";
        frz_MedicalValues_5: Record "Medical Values";
        MedicalLedgEntry: Record "Medical Reim Ledger Entries";
        MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

        frz_LedgerMedicalOld: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_2: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_3: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_4: Record "Medical Reim Ledger Entries";
        frz_LedgerMedicalOld_5: Record "Medical Reim Ledger Entries";

        EntryNo: Integer;
        Window: Dialog;

        statusPoint: Decimal;
        frz_StatusPoint: Record "Master Point Status";
    begin
        statusPoint := 1;
        Window.Open('Reset Reimbersement Entries...Please wait..');
        frz_employee.Reset();
        frz_employee.SetRange("No.", employeeNo);
        if frz_employee.FindFirst() then begin
            frz_StatusPoint.Reset();
            frz_StatusPoint.SetRange(Code, frz_Employee."Status Point Code");
            if frz_StatusPoint.FindFirst() then begin
                if frz_StatusPoint.Point > 0 then
                    StatusPoint := frz_StatusPoint.Point else
                    statusPoint := 1;
            end else
                statusPoint := 1;

            frz_MedicalValues.Reset();
            frz_MedicalValues.SetFilter("Medical Type", '%1|%2', frz_MedicalValues."Medical Type"::Kacamata, frz_MedicalValues."Medical Type"::Persalinan);
            if frz_MedicalValues.FindFirst() then
                repeat

                    MedicalLedgEntry2.Reset();
                    if MedicalLedgEntry2.FindLast() then
                        EntryNo := MedicalLedgEntry2."Entry No." + 1
                    else
                        EntryNo := 1;

                    frz_LedgerMedicalOld.Reset();
                    frz_LedgerMedicalOld.SetRange("Employee No.", frz_employee."No.");
                    frz_LedgerMedicalOld.SetRange("Medical Type", frz_MedicalValues."Medical Type");
                    frz_LedgerMedicalOld.SetRange("Medical Value", frz_MedicalValues.Code);
                    frz_LedgerMedicalOld.CalcSums(Amount);

                    MedicalLedgEntry.Init();
                    MedicalLedgEntry."Entry No." := EntryNo;
                    MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
                    MedicalLedgEntry."Document No." := 'RESET';
                    MedicalLedgEntry."Document Date" := Today;
                    MedicalLedgEntry."Employee No." := frz_employee."No.";
                    MedicalLedgEntry."Description" := 'Reset Medical Reimbersement of ' +
                    frz_employee.FullName();
                    MedicalLedgEntry."Request Approval Date" := today;
                    MedicalLedgEntry."Daily rate - room" := frz_MedicalValues."Daily rate - room";
                    MedicalLedgEntry.Amount := -frz_LedgerMedicalOld.Amount;
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

                frz_LedgerMedicalOld_2.Reset();
                frz_LedgerMedicalOld_2.SetRange("Employee No.", frz_employee."No.");
                frz_LedgerMedicalOld_2.SetRange("Medical Type", frz_MedicalValues_2."Medical Type");
                frz_LedgerMedicalOld_2.CalcSums(Amount);

                MedicalLedgEntry.Init();
                MedicalLedgEntry."Entry No." := EntryNo;
                MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
                MedicalLedgEntry."Document No." := 'RESET';
                MedicalLedgEntry."Document Date" := Today;
                MedicalLedgEntry."Employee No." := frz_employee."No.";
                MedicalLedgEntry."Description" := 'Reset Medical Reimbersement of ' +
                frz_employee.FullName();
                MedicalLedgEntry."Request Approval Date" := today;
                MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_2."Daily rate - room";
                MedicalLedgEntry."Basic Amount" := frz_MedicalValues_2.Plafon;
                MedicalLedgEntry.Amount := -frz_LedgerMedicalOld_2.Amount;
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

                frz_LedgerMedicalOld_3.Reset();
                frz_LedgerMedicalOld_3.SetRange("Employee No.", frz_employee."No.");
                frz_LedgerMedicalOld_3.SetRange("Medical Type", frz_MedicalValues_3."Medical Type");
                frz_LedgerMedicalOld_3.SetRange("Daily rate - room", true);
                frz_LedgerMedicalOld_3.CalcSums(Amount);
                frz_LedgerMedicalOld_3.CalcSums("Quantity 2");

                MedicalLedgEntry.Init();
                MedicalLedgEntry."Entry No." := EntryNo;
                MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
                MedicalLedgEntry."Document No." := 'RESET';
                MedicalLedgEntry."Document Date" := Today;
                MedicalLedgEntry."Employee No." := frz_employee."No.";
                MedicalLedgEntry."Description" := 'Reset Medical Reimbersement of ' +
                frz_employee.FullName();
                MedicalLedgEntry."Request Approval Date" := today;
                MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_3."Daily rate - room";
                MedicalLedgEntry."Basic Amount" := frz_MedicalValues_3.Plafon;
                MedicalLedgEntry."Quantity 2" := -frz_LedgerMedicalOld_3."Quantity 2";
                MedicalLedgEntry.Amount := -frz_LedgerMedicalOld_3.Amount;
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

                frz_LedgerMedicalOld_4.Reset();
                frz_LedgerMedicalOld_4.SetRange("Employee No.", frz_employee."No.");
                frz_LedgerMedicalOld_4.SetRange("Medical Type", frz_MedicalValues_4."Medical Type");
                frz_LedgerMedicalOld_4.SetRange("Rawat Inat Type", frz_MedicalValues_4."Rawat Inat Type");
                frz_LedgerMedicalOld_4.SetRange("Daily rate - room", false);
                frz_LedgerMedicalOld_4.CalcSums(Amount);

                MedicalLedgEntry.Init();
                MedicalLedgEntry."Entry No." := EntryNo;
                MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
                MedicalLedgEntry."Document No." := 'RESET';
                MedicalLedgEntry."Document Date" := Today;
                MedicalLedgEntry."Employee No." := frz_employee."No.";
                MedicalLedgEntry."Description" := 'Reset Medical Reimbersement of ' +
                frz_employee.FullName();
                MedicalLedgEntry."Request Approval Date" := today;
                MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_4."Daily rate - room";
                MedicalLedgEntry."Basic Amount" := frz_MedicalValues_4.Plafon;
                MedicalLedgEntry."Quantity 2" := -frz_MedicalValues_4."Quantity 2";
                MedicalLedgEntry.Amount := -frz_LedgerMedicalOld_4.Amount;
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

                frz_LedgerMedicalOld_5.Reset();
                frz_LedgerMedicalOld_5.SetRange("Employee No.", frz_employee."No.");
                frz_LedgerMedicalOld_5.SetRange("Medical Type", frz_MedicalValues_5."Medical Type");
                frz_LedgerMedicalOld_5.SetRange("Rawat Inat Type", frz_MedicalValues_5."Rawat Inat Type");
                frz_LedgerMedicalOld_5.SetRange("Daily rate - room", false);
                frz_LedgerMedicalOld_5.CalcSums(Amount);

                MedicalLedgEntry.Init();
                MedicalLedgEntry."Entry No." := EntryNo;
                MedicalLedgEntry."Entry Type" := MedicalLedgEntry."Entry Type"::Negative;
                MedicalLedgEntry."Document No." := 'RESET';
                MedicalLedgEntry."Document Date" := Today;
                MedicalLedgEntry."Employee No." := frz_employee."No.";
                MedicalLedgEntry."Description" := 'Reset Medical Reimbersement of ' +
                frz_employee.FullName();
                MedicalLedgEntry."Request Approval Date" := today;
                MedicalLedgEntry."Daily rate - room" := frz_MedicalValues_5."Daily rate - room";
                MedicalLedgEntry."Basic Amount" := frz_MedicalValues_5.Plafon;
                MedicalLedgEntry."Quantity 2" := frz_MedicalValues_5."Quantity 2";
                MedicalLedgEntry.Amount := -frz_LedgerMedicalOld_5.Amount;
                MedicalLedgEntry."Medical Type" := frz_MedicalValues_5."Medical Type";
                MedicalLedgEntry."Rawat Inat Type" := frz_MedicalValues_5."Rawat Inat Type";
                MedicalLedgEntry.Insert();
            end;
        end;

        Window.Close();
        Message('Reset Balance Medical Reimbursement Ledger successfully.');
    end;
}