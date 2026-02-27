codeunit 65018 "Posting Opbal Kacamata"
{
    trigger OnRun()
    var
        frz_MedicalReimLedgerEntry: Record "Medical Reim Ledger Entries";
        frz_Check_MedicalReimLedgerEntry: Record "Medical Reim Ledger Entries";
        frz_Employee: Record Employee;
        frz_MedicalValues: Record "Medical Values";
        MedicalLedgEntryLast: Record "Medical Reim Ledger Entries";
        EntryNo: Integer;
    begin
        frz_Employee.Reset();
        frz_Employee.SetRange(Status, frz_Employee.Status::Active);
        if frz_Employee.FindFirst() then
            repeat
                frz_Check_MedicalReimLedgerEntry.Reset();
                frz_Check_MedicalReimLedgerEntry.SetRange("Medical Type", frz_Check_MedicalReimLedgerEntry."Medical Type"::Kacamata);
                frz_Check_MedicalReimLedgerEntry.SetRange("Employee No.", frz_Employee."No.");
                frz_Check_MedicalReimLedgerEntry.SetRange("expired date optical", Today);
                if frz_Check_MedicalReimLedgerEntry.FindFirst() then
                    repeat
                        frz_MedicalReimLedgerEntry.Init();
                        // last ledger
                        MedicalLedgEntryLast.Reset();
                        if MedicalLedgEntryLast.FindLast() then
                            EntryNo := MedicalLedgEntryLast."Entry No." + 1
                        else
                            EntryNo := 1;
                        // medical value
                        frz_MedicalValues.Reset();
                        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::Kacamata);
                        frz_MedicalValues.SetRange(Code, frz_Check_MedicalReimLedgerEntry."Medical Value");
                        if frz_MedicalValues.FindFirst() then begin
                            frz_MedicalReimLedgerEntry."Quantity 2" := frz_MedicalValues."Quantity 2";
                            frz_MedicalReimLedgerEntry.Amount := frz_MedicalValues.Plafon;
                        end;
                        // insert ledger opbal
                        frz_MedicalReimLedgerEntry."Entry No." := EntryNo;
                        frz_MedicalReimLedgerEntry."Medical Value" := frz_Check_MedicalReimLedgerEntry."Medical Value";
                        frz_MedicalReimLedgerEntry."Medical Type" := frz_Check_MedicalReimLedgerEntry."Medical Type";
                        frz_MedicalReimLedgerEntry."Medical Type" := frz_Check_MedicalReimLedgerEntry."Medical Type";
                        frz_MedicalReimLedgerEntry."Entry Type" := frz_MedicalReimLedgerEntry."Entry Type"::Positive;
                        frz_MedicalReimLedgerEntry."Document No." := 'OPBAL';
                        frz_MedicalReimLedgerEntry."Document Date" := Today;
                        frz_MedicalReimLedgerEntry."Employee No." := frz_Employee."No.";
                        frz_MedicalReimLedgerEntry."Description" := 'Opening Medical Reimbersement of ' + frz_Employee.FullName();
                        frz_MedicalReimLedgerEntry."Basic Amount" := frz_MedicalValues.Plafon;
                        frz_MedicalReimLedgerEntry.Insert();
                    until frz_Check_MedicalReimLedgerEntry.Next() = 0;
            until frz_Employee.Next() = 0;
    end;
}