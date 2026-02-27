page 65065 "Med Reimbursement List OPBAL"
{
    //dre
    Caption = 'Medical Reimbursements List OPBAL';

    PageType = List;
    RefreshOnActivate = true;
    Editable = false;
    SourceTable = "Medical Reimbursement Header";
    SourceTableView = where(Opbal = filter(true));
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Medical Reimbursement OPBAL";

    layout
    {
        area(Content)
        {
            repeater(MyGroup)
            {
                field(Code; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                }
                //dre
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            //dre
            action("Posting Medical")
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MedicalMgt: Codeunit "Proses Medical Reimbersement";
                    MedicalHeader: Record "Medical Reimbursement Header";
                begin
                    rec.Status := Rec.Status::Released;
                    rec.Modify();
                    if not confirm('This process will create medical reimbursement entries\' +
                                   '\' +
                                   'Are you sure to continue?') then
                        exit;
                    MedicalHeader.Reset();
                    MedicalHeader.SetRange(Opbal, true);
                    if MedicalHeader.FindFirst() then
                        repeat
                            MedicalMgt.PostedMedical(MedicalHeader);
                        until MedicalHeader.Next() = 0;

                    Message('Medical Reimbursement for Employee %1 is succesfully created.',
                            Rec.NamaEmployee(Rec."Employee No."));
                end;
            }
            action("Delete Transaksi Medical Posted")
            {
                ApplicationArea = All;
                Image = AbsenceCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = false;
                trigger OnAction()
                var
                    MedicalHeader: Record "Medical Reimbursement Header";
                    MedicalLines: Record "Medical Reimbursement Line";
                    MedicalLinesPosted: Record "Posted MR Line";
                    MedicalHeaderPosted: Record "Posted MR Header";
                    MedicalLedger: Record "Medical Reim Ledger Entries";
                begin
                    // MedicalHeader.Reset();
                    // if MedicalHeader.FindFirst() then
                    //     // MedicalHeader.Get();
                    //     MedicalHeader.DeleteAll();

                    // MedicalLines.Reset();
                    // if MedicalLines.FindFirst() then
                    //     MedicalLines.DeleteAll();

                    MedicalHeaderPosted.Reset();
                    MedicalHeaderPosted.SetRange(Opbal, false);
                    if MedicalHeaderPosted.FindFirst() then
                        repeat
                            MedicalLinesPosted.Reset();
                            MedicalLinesPosted.SetRange("Document No.", MedicalHeaderPosted."No.");
                            if MedicalLinesPosted.FindFirst() then
                                MedicalLinesPosted.DeleteAll();

                            MedicalLedger.Reset();
                            MedicalLedger.SetRange("Document No.", MedicalHeaderPosted."No.");
                            if MedicalLedger.FindFirst() then
                                MedicalLedger.DeleteAll();

                            MedicalHeaderPosted.Delete();
                        until MedicalHeaderPosted.Next() = 0;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();
    end;
}