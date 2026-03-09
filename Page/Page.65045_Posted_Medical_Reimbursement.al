page 65045 "Posted MR Card"
{
    PageType = Document;
    caption = 'Posted Medical Reimbursement Card';
    RefreshOnActivate = true;
    SourceTable = "Posted MR Header";
    UsageCategory = Documents;
    // ApplicationArea = all;
    Editable = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        rec_Employee: Record Employee;
                    begin
                        rec_Employee.Reset();
                        rec_Employee.SetRange("No.", rec."Employee No.");
                        rec_Employee.FindFirst();
                        rec."Name Employee" := rec_Employee.FullName();
                    end;
                }
                field("Name Employee"; rec."Name Employee")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Revision Date"; rec."Revision Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(getOption; rec."Medical Type 1")
                {
                    // Visible = CodeBololean1;

                    CaptionClass = 'Kacamata';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_MedicalValue: Record "Medical Values";
                        rec_MedicalLines: Record "Medical Reimbursement Line";
                        rec_MedicalLines2: Record "Medical Reimbursement Line";
                        rec_MedicalLines3: Record "Medical Reimbursement Line";
                    begin
                        // noModifyType();
                        if rec."Medical Type 1" = true then begin
                            rec."Medical Type 2" := false;
                            rec."Medical Type 3" := false;
                            rec."Medical Type 4" := false;
                        end;
                        if rec."Medical Type 1" = true then begin
                            rec_MedicalValue.Reset();
                            rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::Kacamata);
                            if rec_MedicalValue.FindFirst() then
                                repeat
                                    rec_MedicalLines.Init();
                                    rec_MedicalLines."Document No." := rec."No.";
                                    rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                    rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::Kacamata;
                                    rec_MedicalLines.Description := rec_MedicalValue.Description;
                                    rec_MedicalLines."Employee No." := rec."Employee No.";
                                    rec_MedicalLines2.Reset();
                                    rec_MedicalLines2.SetRange("Document No.", Rec."No.");
                                    rec_MedicalLines2.SetRange("Medical Type", rec_MedicalLines2."Medical Type"::Kacamata);
                                    if rec_MedicalLines2.FindLast() then
                                        rec_MedicalLines."Line No." := rec_MedicalLines2."Line No." + 10000
                                    else
                                        rec_MedicalLines."Line No." += 10000;
                                    rec_MedicalLines.Insert();
                                until rec_MedicalValue.Next = 0;
                            rec_MedicalLines3.Reset();
                            rec_MedicalLines3.SetRange("Document No.", rec."No.");
                            rec_MedicalLines3.SetFilter("Medical Type", '<> %1', rec_MedicalLines3."Medical Type"::Kacamata);
                            if rec_MedicalLines3.FindFirst() then
                                rec_MedicalLines3.DeleteAll();
                        end else begin
                            rec_MedicalLines.SetRange("Document No.", rec."No.");
                            rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::Kacamata);
                            if rec_MedicalLines.FindFirst() then
                                rec_MedicalLines.DeleteAll();
                        end;
                    end;
                }
                field(getOption2; rec."Medical Type 2")
                {
                    // Visible = CodeBololean2;
                    CaptionClass = 'Rawat Jalan';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_MedicalValue: Record "Medical Values";
                        rec_MedicalLines: Record "Medical Reimbursement Line";
                        rec_MedicalLines2: Record "Medical Reimbursement Line";
                        rec_MedicalLines3: Record "Medical Reimbursement Line";
                        frz_StatusPoint: Record "Master Point Status";
                        frz_Employee: Record Employee;
                        frz_point: Decimal;
                        frz_StatusPointCode: Code[50];
                    begin
                        // noModifyType();
                        if rec."Medical Type 2" = true then begin
                            rec."Medical Type 1" := false;
                            rec."Medical Type 3" := false;
                            rec."Medical Type 4" := false;
                        end;
                        if rec."Medical Type 2" = true then begin
                            frz_point := 0;
                            // get employee dan status point master
                            frz_Employee.reset;
                            frz_Employee.SetRange("No.", rec."Employee No.");
                            if frz_Employee.FindFirst() then begin
                                frz_StatusPoint.Reset();
                                frz_StatusPoint.SetRange(Code, frz_Employee."Status Point Code");
                                if frz_StatusPoint.FindFirst() then begin
                                    frz_point := frz_StatusPoint.Point;
                                    frz_StatusPointCode := frz_StatusPoint.code;
                                end;
                            end;
                            // input line rawat jalan
                            rec_MedicalValue.Reset();
                            rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::"Rawat Jalan");
                            if rec_MedicalValue.FindFirst() then
                                repeat
                                    rec_MedicalLines.Init();
                                    rec_MedicalLines."Document No." := rec."No.";
                                    rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                    rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::"Rawat Jalan";
                                    rec_MedicalLines."Status Poin" := frz_StatusPointCode;
                                    rec_MedicalLines.Poin := frz_point;
                                    rec_MedicalLines.Description := rec_MedicalValue.Description;
                                    rec_MedicalLines."Employee No." := rec."Employee No.";
                                    rec_MedicalLines2.Reset();
                                    rec_MedicalLines2.SetRange("Document No.", Rec."No.");
                                    rec_MedicalLines2.SetRange("Medical Type", rec_MedicalLines2."Medical Type"::"Rawat Jalan");
                                    if rec_MedicalLines2.FindLast() then
                                        rec_MedicalLines."Line No." := rec_MedicalLines2."Line No." + 10000
                                    else
                                        rec_MedicalLines."Line No." += 10000;
                                    rec_MedicalLines.Insert();
                                until rec_MedicalValue.Next = 0;
                            rec_MedicalLines3.Reset();
                            rec_MedicalLines3.SetRange("Document No.", rec."No.");
                            rec_MedicalLines3.SetFilter("Medical Type", '<> %1', rec_MedicalLines3."Medical Type"::"Rawat Jalan");
                            if rec_MedicalLines3.FindFirst() then
                                rec_MedicalLines3.DeleteAll();
                        end else begin
                            rec_MedicalLines.SetRange("Document No.", rec."No.");
                            rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::"Rawat Jalan");
                            if rec_MedicalLines.FindFirst() then
                                rec_MedicalLines.DeleteAll();
                        end;
                    end;
                }
                field(getOptio4; rec."Medical Type 4")
                {
                    // Visible = CodeBololean4;
                    CaptionClass = 'Persalinan';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_MedicalValue: Record "Medical Values";
                        rec_MedicalLines: Record "Medical Reimbursement Line";
                        rec_MedicalLines2: Record "Medical Reimbursement Line";
                        rec_MedicalLines3: Record "Medical Reimbursement Line";
                    begin
                        // noModifyType();
                        if rec."Medical Type 4" = true then begin
                            rec."Medical Type 1" := false;
                            rec."Medical Type 3" := false;
                            rec."Medical Type 2" := false;
                        end;
                        if rec."Medical Type 4" = true then begin
                            rec_MedicalValue.Reset();
                            rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::Persalinan);
                            if rec_MedicalValue.FindFirst() then
                                repeat
                                    rec_MedicalLines.Init();
                                    rec_MedicalLines."Document No." := rec."No.";
                                    rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                    rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::Persalinan;
                                    rec_MedicalLines.Description := rec_MedicalValue.Description;
                                    rec_MedicalLines."Employee No." := rec."Employee No.";
                                    rec_MedicalLines2.Reset();
                                    rec_MedicalLines2.SetRange("Document No.", Rec."No.");
                                    rec_MedicalLines2.SetRange("Medical Type", rec_MedicalLines2."Medical Type"::Persalinan);
                                    if rec_MedicalLines2.FindLast() then
                                        rec_MedicalLines."Line No." := rec_MedicalLines2."Line No." + 10000
                                    else
                                        rec_MedicalLines."Line No." += 10000;
                                    rec_MedicalLines.Insert();
                                until rec_MedicalValue.Next = 0;

                            rec_MedicalLines3.Reset();
                            rec_MedicalLines3.SetRange("Document No.", rec."No.");
                            rec_MedicalLines3.SetFilter("Medical Type", '<> %1', rec_MedicalLines3."Medical Type"::Persalinan);
                            if rec_MedicalLines3.FindFirst() then
                                rec_MedicalLines3.DeleteAll();
                        end else begin
                            rec_MedicalLines.Reset();
                            rec_MedicalLines.SetRange("Document No.", rec."No.");
                            rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::Persalinan);
                            if rec_MedicalLines.FindFirst() then
                                rec_MedicalLines.DeleteAll();
                        end;
                    end;
                }
                field(getOption3; rec."Medical Type 3")
                {
                    // Visible = CodeBololean3;

                    CaptionClass = 'Rawat Inap';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_MedicalValue: Record "Medical Values";
                        rec_MedicalLines: Record "Medical Reimbursement Line";
                        rec_MedicalLines2: Record "Medical Reimbursement Line";
                        rec_MedicalLines3: Record "Medical Reimbursement Line";
                    begin
                        if rec."Medical Type 3" = true then begin
                            rec."Medical Type 1" := false;
                            rec."Medical Type 4" := false;
                            rec."Medical Type 2" := false;
                        end;
                        // noModifyType();
                        if rec."Medical Type 3" = true then begin
                            rec_MedicalValue.Reset();
                            rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::"Rawat Inap");
                            if rec_MedicalValue.FindFirst() then
                                repeat
                                    rec_MedicalLines.Init();
                                    rec_MedicalLines."Document No." := rec."No.";
                                    rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                    rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::"Rawat Inap";
                                    rec_MedicalLines.Description := rec_MedicalValue.Description;
                                    rec_MedicalLines."Employee No." := rec."Employee No.";
                                    rec_MedicalLines2.Reset();
                                    rec_MedicalLines2.SetRange("Document No.", Rec."No.");
                                    rec_MedicalLines2.SetRange("Medical Type", rec_MedicalLines2."Medical Type"::"Rawat Inap");
                                    if rec_MedicalLines2.FindLast() then
                                        rec_MedicalLines."Line No." := rec_MedicalLines2."Line No." + 10000
                                    else
                                        rec_MedicalLines."Line No." += 10000;
                                    rec_MedicalLines.Insert();
                                until rec_MedicalValue.Next = 0;

                            rec_MedicalLines3.Reset();
                            rec_MedicalLines3.SetRange("Document No.", rec."No.");
                            rec_MedicalLines3.SetFilter("Medical Type", '<> %1', rec_MedicalLines3."Medical Type"::"Rawat Inap");
                            if rec_MedicalLines3.FindFirst() then
                                rec_MedicalLines3.DeleteAll();
                        end else begin
                            rec_MedicalLines.Reset();
                            rec_MedicalLines.SetRange("Document No.", rec."No.");
                            rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::"Rawat Inap");
                            if rec_MedicalLines.FindFirst() then
                                rec_MedicalLines.DeleteAll();
                        end;
                    end;
                }
                field(frz_Pembedahan; frz_Pembedahan)
                {
                    Caption = 'Pembedahan';
                    ApplicationArea = all;
                }
                field(frz_RawatJalan; frz_RawatJalan)
                {
                    Caption = 'Jasa Biaya Perawatan';
                    ApplicationArea = all;
                }
                field("Status Patient"; rec."Status Patient")
                {
                    ApplicationArea = All;
                }
                field("Age of Patient"; rec."Age of Patient")
                {
                    ApplicationArea = All;
                }
                field(Gender; rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Name of Hospital"; rec."Name of Hospital")
                {
                    ApplicationArea = All;
                }
                field("Address of hospital"; rec."Address of hospital")
                {
                    ApplicationArea = All;
                }
                field("Hospital Benefit"; rec."Hospital Benefit")
                {
                    ApplicationArea = All;
                }
                field("From Date"; rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("Place of Accident"; rec."Place of Accident")
                {
                    ApplicationArea = All;
                }
                field(Time; rec.Time)
                {
                    ApplicationArea = All;
                }
                field("Rekening no."; rec."Rekening no.")
                {
                    Caption = 'Give Clear Account of * Accident / Illness';
                    ApplicationArea = All;
                }
                field(Reversed; rec.Reversed)
                {
                    ApplicationArea = All;
                }
            }
            part("Medical Kacamata"; "Posted MR Line Kacamata")
            {
                ApplicationArea = all;
                Visible = rec."Medical Type 1";
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Rawat jalan"; "Posted MR Line Rawat Jalan")
            {
                ApplicationArea = all;
                Visible = rec."Medical Type 2";
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Persalinan"; "Posted MR Line Persalinan")
            {
                Visible = rec."Medical Type 4";
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Rawat Inap"; "Posted MR Line Rawat Inap")
            {
                Visible = rec."Medical Type 3";
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Total")
            {
                ShowCaption = false;
                field("Total Allowance"; rec."Total Allowance")
                {
                    ApplicationArea = All;
                }
            }

        }
        area(FactBoxes)
        {
            part(Attachment; "Medical Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document No." = FIELD("No.");
            }
            part(Comment; "Comment Posted Factbox")
            {
                ApplicationArea = All;
                Caption = 'Comment Factbox';
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Undo Medical Reimbersement")
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MedicalMgt: Codeunit "Proses Medical Reimbersement";
                    ApprovalChain: Record "Approval Chain Setup";
                    frz_CU_EmailUndo: Codeunit "Email Undo";
                    frz_PostedComment: Record "Posted Approval Comment Line";
                begin
                    ApprovalChain.Reset();
                    ApprovalChain.SetRange("Document Type", ApprovalChain."Document Type"::"Medical Reimbursement");
                    ApprovalChain.SetRange(ID, UserId);
                    if not ApprovalChain.FindFirst() then
                        Error('You have to be an approver to undo Medical Reimbersement.');
                    // else
                    //     if not ApprovalChain."Able to Undo CTO Request" then
                    //         Error('You are not authorized to undo Medical Reimbersement.');

                    // Rec.TestField(Status, Rec.Status::Released);

                    if not confirm('This process will create reversal Medical entries\' +
                                   'as a correction, and then reopen this document. \' +
                                   '\' +
                                   'Are you sure to continue?') then
                        exit;

                    frz_CU_EmailUndo.cekKomennye(rec."No.");

                    MedicalMgt.undoProcessMedicalBalance(Rec."No.");

                    frz_CU_EmailUndo.SendEmail(rec."No.");



                    Message('Succesfully undo Medical Reimbersement %1. The status is now open, \' +
                            'Medical Balance for Employee %1 is REVERSED.',
                            Rec."No.", Rec."Employee No.");

                    CurrPage.Update();
                end;
            }
            action(Comments)
            {
                // Visible = OpenApprovalEntriesExistForCurrUser;
                Caption = 'Comments Undo';
                Image = Comment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    frz_getComment: Codeunit getComment;
                begin
                    frz_getComment.RunApprovalCommentsPage(Rec."No.", 65021);
                end;
            }
            action("Attach File")
            {
                // Visible = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Caption = 'Attach File';
                Image = EditAttachment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction();
                var
                    _AdvanceAttchEntry: Record "Advance Attachment Entry";
                begin
                    _AdvanceAttchEntry.Reset();
                    _AdvanceAttchEntry.SetRange("Document No.", rec."No.");
                    Page.Run(Page::"Posted Attachment Medical", _AdvanceAttchEntry);
                end;
            }
            action("Print Medical Reimbersement")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    MedicalHeader: Record "Posted MR Header";
                begin
                    CurrPage.SetSelectionFilter(MedicalHeader);
                    Report.run(Report::"Posted Medical Reimbursement", true, false, MedicalHeader);
                end;
            }
            action("Print Medical Reimbersement (Klaim)")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    MedicalHeader: Record "Posted MR Header";
                begin
                    CurrPage.SetSelectionFilter(MedicalHeader);
                    Report.run(Report::"Posted Med. Rmb. Claim", true, false, MedicalHeader);
                end;
            }

            //dre
            action("Create General Payment")
            {
                Image = CreateFinanceChargememo;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger
                OnAction()
                var
                    AdvanceHeader: Record "Advance Header";
                    AdvanceHeader2: Record "Advance Header";
                    GenJnlLine: Record "Gen. Journal Line";
                    KuliBangunan: Record Employee;
                    Window: Dialog;
                    _GenJnlBatch: Record "Gen. Journal Batch";
                    AdvancePostDRE: Codeunit "Advance-Post";
                    PayrollSetup: Record "Payroll General Setup";
                    NomorGP: Code[20];
                begin
                    if not Confirm('Proceed to create general payment?') then exit;

                    Window.Open('Creating general payment, please wait..');

                    PayrollSetup.Get();
                    PayrollSetup.TestField("Medical Reimbursement Acc. No.");

                    KuliBangunan.Reset();
                    KuliBangunan.SetRange("User ID", UserId);
                    KuliBangunan.FindFirst();

                    //Create General Payment
                    AdvanceHeader.Init();
                    AdvanceHeader.Validate("Document Type", AdvanceHeader."Document Type"::"General Payment");
                    AdvanceHeader.Validate("No.", '');
                    AdvanceHeader."Employee No." := KuliBangunan."No.";
                    AdvanceHeader.validate("Shortcut Dimension 1 Code", KuliBangunan."MSI_HRIS Shortcut Dim Code");
                    AdvanceHeader.Insert(true);
                    NomorGP := AdvanceHeader."No.";

                    AdvanceHeader2.get(AdvanceHeader2."Document Type"::"General Payment",
                    AdvanceHeader."No.");
                    if not _GenJnlBatch.GET(AdvancePostDRE.GetTemplateInitial,
                        AdvancePostDRE.GetBatchInitial(AdvanceHeader)) THEN BEGIN
                        _GenJnlBatch.Init();
                        _GenJnlBatch."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                        _GenJnlBatch.Name := AdvancePostDRE.GetBatchInitial(AdvanceHeader);
                        _GenJnlBatch.Insert();
                    end;

                    AdvanceHeader2."Journal Template Name" := AdvancePostDRE.GetTemplateInitial;
                    AdvanceHeader2."Journal Batch Name" := _GenJnlBatch.Name;
                    AdvanceHeader2."Journal Description" := 'Medical reimbursement for ' + Rec."No.";
                    AdvanceHeader2.Validate("Posting Date", Rec."Posting Date");
                    AdvanceHeader2.Modify();


                    GenJnlLine.Init();
                    GenJnlLine.Validate("Journal Template Name", AdvanceHeader2."Journal Template Name");
                    GenJnlLine.validate("Journal Batch Name", AdvanceHeader2."Journal Batch Name");
                    GenJnlLine.Validate("Line No.", 10000);
                    GenJnlLine.Validate("Document No.", AdvanceHeader."No.");
                    GenJnlLine.Validate("Posting Date", Rec."Posting Date");

                    Rec.CalcFields("Total Allowance");
                    GenJnlLine.Validate(Amount, Rec."Total Allowance");
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.Validate("Account No. 2", PayrollSetup."Medical Reimbursement Acc. No.");
                    GenJnlLine.Insert(true);



                    Window.Close();
                    Message('General payment %1 is created.', NomorGP);
                end;
            }
        }
    }
    var
        //dre
        ApprovalDRE2: Codeunit "Approval DRE2";
        frz_Pembedahan: Boolean;
        frz_RawatJalan: Boolean;

        OpenApprovalEntriesExistForCurrUser: Boolean;

    trigger OnAfterGetRecord()
    var
        frz_MedicalLine: Record "Posted MR Line";
    begin
        frz_MedicalLine.Reset();
        frz_MedicalLine.SetRange("Document No.", rec."No.");
        if frz_MedicalLine.FindFirst() then begin
            if Rec."Medical Type 3" = true then begin

                if frz_MedicalLine."Rawat Inat Type" = frz_MedicalLine."Rawat Inat Type"::Pembedahan then begin
                    frz_Pembedahan := true;
                    frz_RawatJalan := false;
                end;
                if frz_MedicalLine."Rawat Inat Type" = frz_MedicalLine."Rawat Inat Type"::"Biaya Jasa Perawatan" then begin
                    frz_Pembedahan := false;
                    frz_RawatJalan := true;
                end;
            end else begin
                frz_Pembedahan := false;
                frz_RawatJalan := false;
            end;
        end;
    end;
}