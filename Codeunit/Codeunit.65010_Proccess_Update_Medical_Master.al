codeunit 65010 "Medical Master Update"
{
    procedure UpdateSlot()
    var
        frz_Employee: Record Employee;
        frz_MedicalSlot: Record "Medical Slot";
        frz_MedicalSlotCheck: Record "Medical Slot";
        frz_MedicalSlotDelete: Record "Medical Slot";
        frz_MedicalValues: Record "Medical Values";
        frz_LineNo: Integer;
    begin
        frz_MedicalSlotDelete.DeleteAll();

        frz_Employee.Reset();
        frz_Employee.SetRange(Status, frz_Employee.Status::Active);
        if frz_Employee.FindFirst() then
            repeat

                if frz_MedicalValues.FindFirst() then
                    repeat
                        /////////////////////////
                        frz_MedicalSlotCheck.Reset();
                        frz_MedicalSlotCheck.SetRange("Employee No.", frz_Employee."No.");
                        if frz_MedicalSlotCheck.FindLast() then
                            frz_LineNo := frz_MedicalSlotCheck."Line No." + 1 else
                            frz_LineNo := 1;
                        /////////////////////////
                        frz_MedicalSlot.Init();
                        frz_MedicalSlot."Employee No." := frz_Employee."No.";
                        frz_MedicalSlot."Medical Code" := frz_MedicalValues.Code;
                        frz_MedicalSlot."Medical Type" := frz_MedicalValues."Medical Type";
                        frz_MedicalSlot."Rawat Inat Type" := frz_MedicalValues."Rawat Inat Type";
                        frz_MedicalSlot."Daily rate - room" := frz_MedicalValues."Daily rate - room";
                        frz_MedicalSlot."Line No." := frz_LineNo;
                        frz_MedicalSlot.Insert();
                        ///////////////////////////
                        frz_MedicalValues."Update for Slot Medical" := true;
                        frz_MedicalValues.Modify();

                    until frz_MedicalValues.Next() = 0
                else begin

                end;

            until frz_Employee.Next() = 0;

        // Message('Update Data Success');
    end;

    procedure UpdateSlotPerEmployee(EmployeeNo: code[50])

    var
        frz_Employee: Record Employee;
        frz_MedicalSlot: Record "Medical Slot";
        frz_MedicalSlotCheck: Record "Medical Slot";
        frz_MedicalSlotDelete: Record "Medical Slot";
        frz_MedicalValues: Record "Medical Values";
        frz_LineNo: Integer;
    begin
        frz_MedicalSlotDelete.Reset();
        frz_MedicalSlotDelete.SetRange("Employee No.", EmployeeNo);
        if frz_MedicalSlotDelete.FindFirst() then
            frz_MedicalSlotDelete.DeleteAll();

        if frz_MedicalValues.FindFirst() then
            repeat
                /////////////////////////
                frz_MedicalSlotCheck.Reset();
                frz_MedicalSlotCheck.SetRange("Employee No.", EmployeeNo);
                if frz_MedicalSlotCheck.FindLast() then
                    frz_LineNo := frz_MedicalSlotCheck."Line No." + 1 else
                    frz_LineNo := 1;
                /////////////////////////
                frz_MedicalSlot.Init();
                frz_MedicalSlot."Employee No." := EmployeeNo;
                frz_MedicalSlot."Medical Code" := frz_MedicalValues.Code;
                frz_MedicalSlot."Medical Type" := frz_MedicalValues."Medical Type";
                frz_MedicalSlot."Rawat Inat Type" := frz_MedicalValues."Rawat Inat Type";
                frz_MedicalSlot."Daily rate - room" := frz_MedicalValues."Daily rate - room";
                frz_MedicalSlot."Line No." := frz_LineNo;
                frz_MedicalSlot.Insert();
            ///////////////////////////
            until frz_MedicalValues.Next() = 0;
    end;
}