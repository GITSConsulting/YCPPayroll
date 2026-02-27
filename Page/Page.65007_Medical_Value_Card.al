page 65007 "Description of Attendance Card"
{
    PageType = Document;
    caption = 'Description of Attendance';
    RefreshOnActivate = true;
    SourceTable = "Employee Attendance Header";
    UsageCategory = Documents;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; rec."Effective Date")
                {
                    ApplicationArea = All;
                }
            }
            part("Description of attendance"; "Description of attendance")
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Apply New Settings to Employee")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                PromotedOnly = true;
                trigger OnAction()
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

                                until frz_MedicalValues.Next() = 0;

                        until frz_Employee.Next() = 0;

                    Message('Update Data Success');
                end;
            }
        }
    }
}