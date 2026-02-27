page 65004 "Medical Reimbursement Card"
{
    PageType = Document;
    caption = 'Medical Reimbursement';
    RefreshOnActivate = true;
    SourceTable = "Medical Reimbursement Header";
    UsageCategory = Documents;
    // ApplicationArea = all;
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
                    trigger
                    OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        rec_Employee: Record Employee;
                        frz_MedicalLines: record "Medical Reimbursement Line";
                    begin
                        rec_Employee.Reset();
                        rec_Employee.SetRange("No.", rec."Employee No.");
                        rec_Employee.FindFirst();
                        rec."Name Employee" := rec_Employee.FullName();

                        frz_MedicalLines.Reset();
                        frz_MedicalLines.SetRange("Document No.", rec."No.");
                        if frz_MedicalLines.FindFirst() then
                            frz_MedicalLines.DeleteAll();

                        rec."Medical Type 1" := false;
                        rec."Medical Type 2" := false;
                        rec."Medical Type 3" := false;
                        rec."Medical Type 4" := false;
                        frz_Pembedahan := false;
                        frz_RawatJalan := false;
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
                    trigger OnValidate()
                    var
                        rec_Employee: Record Employee;
                        frz_MedicalLines: record "Medical Reimbursement Line";
                    begin
                        if rec."Posting Date" <> xRec."Posting Date" then begin
                            rec."From Date" := 0D;

                            frz_MedicalLines.Reset();
                            frz_MedicalLines.SetRange("Document No.", rec."No.");
                            if frz_MedicalLines.FindFirst() then
                                frz_MedicalLines.DeleteAll();

                            rec."Medical Type 1" := false;
                            rec."Medical Type 2" := false;
                            rec."Medical Type 3" := false;
                            rec."Medical Type 4" := false;
                            frz_Pembedahan := false;
                            frz_RawatJalan := false;

                        end;
                        CurrPage.Update();
                    end;
                    // Editable = false;
                }
                field("From Date"; rec."From Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        frz_MedicalLines: record "Medical Reimbursement Line";
                    begin
                        // if (rec."From Date" < CalcDate('-CM', Rec."Posting Date")) OR (REC."From Date" > CalcDate('CM', Rec."Posting Date")) then
                        //     Error('From date can not be more than 1 month posting date');
                        if rec."From Date" < CalcDate('-1M', Rec."Posting Date") then
                            Error('From date can not be more than 1 month posting date');

                        if rec."From Date" <> xRec."From Date" then begin

                            frz_MedicalLines.Reset();
                            frz_MedicalLines.SetRange("Document No.", rec."No.");
                            if frz_MedicalLines.FindFirst() then
                                repeat
                                    frz_MedicalLines.Date := rec."From Date";
                                    frz_MedicalLines.Modify();
                                until frz_MedicalLines.Next() = 0;

                        end;
                        CurrPage.Update();
                    end;
                }
                field("To Date"; rec."To Date")
                {
                    ApplicationArea = All;
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
                field("Status Patient"; rec."Status Patient")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.TestField("Posting Date");
                        rec.TestField("Employee No.");
                        if rec."Medical Type 1" = true then
                            rec."Status Patient" := rec."Status Patient"::Employee;
                        CurrPage.Update();
                    end;
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
                field("Place of Accident"; rec."Place of Accident")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Time; rec.Time)
                {
                    ApplicationArea = All;
                }
                field("Rekening no."; rec."Rekening no.")
                {
                    Caption = 'Description of Accident / Ilness"';
                    ApplicationArea = All;
                }
                group("Medical Type")
                {
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
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            if rec."Medical Type 1" = true then begin
                                rec."Medical Type 2" := false;
                                rec."Medical Type 3" := false;
                                rec."Medical Type 4" := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
                                frz_InapCheck := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
                            end;
                            rec."Status Patient" := rec."Status Patient"::Employee;
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
                                        rec_MedicalLines.Date := rec."From Date";
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
                            frz_point: Integer;
                            frz_StatusPointCode: Code[50];
                        begin
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            // noModifyType();
                            if rec."Medical Type 2" = true then begin
                                rec."Medical Type 1" := false;
                                rec."Medical Type 3" := false;
                                rec."Medical Type 4" := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
                                frz_InapCheck := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
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
                                        rec_MedicalLines.Date := rec."From Date";
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
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            if rec."Medical Type 4" = true then begin
                                rec."Medical Type 1" := false;
                                rec."Medical Type 3" := false;
                                rec."Medical Type 2" := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
                                frz_InapCheck := false;
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;
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
                                        rec_MedicalLines.Date := rec."From Date";
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
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            if rec."Medical Type 3" = true then begin
                                frz_InapCheck := true;
                            end else
                                frz_InapCheck := false;

                            if rec."Medical Type 3" = true then begin
                                rec_MedicalLines3.Reset();
                                rec_MedicalLines3.SetRange("Document No.", rec."No.");
                                if rec_MedicalLines3.FindFirst() then
                                    rec_MedicalLines3.DeleteAll();
                            end else begin
                                frz_Pembedahan := false;
                                frz_RawatJalan := false;

                                rec_MedicalLines.Reset();
                                rec_MedicalLines.SetRange("Document No.", rec."No.");
                                rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::"Rawat Inap");
                                if rec_MedicalLines.FindFirst() then
                                    rec_MedicalLines.DeleteAll();
                            end;
                            CurrPage.Update();
                        end;
                    }
                    field(frz_Pembedahan; frz_Pembedahan)
                    {
                        Caption = 'Pembedahan';
                        ApplicationArea = all;
                        Editable = frz_InapCheck;
                        trigger OnValidate()
                        var
                            recHeader: Record "Medical Reimbursement Header";
                            rec_MedicalValue: Record "Medical Values";
                            rec_MedicalLines: Record "Medical Reimbursement Line";
                            rec_MedicalLines2: Record "Medical Reimbursement Line";
                            rec_MedicalLines3: Record "Medical Reimbursement Line";
                        begin
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            if frz_Pembedahan = true then begin
                                frz_RawatJalan := false;

                                rec_MedicalLines3.Reset();
                                rec_MedicalLines3.SetRange("Document No.", rec."No.");
                                if rec_MedicalLines3.FindFirst() then
                                    rec_MedicalLines3.DeleteAll();

                                rec_MedicalValue.Reset();
                                rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::"Rawat Inap");
                                rec_MedicalValue.SetFilter("Rawat Inat Type", '<> %1', rec_MedicalValue."Rawat Inat Type"::"Biaya Jasa Perawatan");
                                rec_MedicalValue.SetFilter(Code, '<> %1', '');
                                if rec_MedicalValue.FindFirst() then
                                    repeat
                                        rec_MedicalLines.Init();
                                        rec_MedicalLines."Document No." := rec."No.";
                                        rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                        rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::"Rawat Inap";
                                        rec_MedicalLines."Rawat Inat Type" := rec_MedicalValue."Rawat Inat Type"::Pembedahan;
                                        rec_MedicalLines.Date := rec."From Date";
                                        rec_MedicalLines."Daily rate - room" := rec_MedicalValue."Daily rate - room";
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

                            end else begin
                                rec_MedicalLines.Reset();
                                rec_MedicalLines.SetRange("Document No.", rec."No.");
                                rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::"Rawat Inap");
                                if rec_MedicalLines.FindFirst() then
                                    rec_MedicalLines.DeleteAll();
                            end;

                            CurrPage.Update();
                        end;
                    }
                    field(frz_RawatJalan; frz_RawatJalan)
                    {
                        Caption = 'Jasa Biaya Perawatan';
                        ApplicationArea = all;
                        Editable = frz_InapCheck;
                        trigger OnValidate()
                        var
                            rec_MedicalValue: Record "Medical Values";
                            rec_MedicalLines: Record "Medical Reimbursement Line";
                            rec_MedicalLines2: Record "Medical Reimbursement Line";
                            rec_MedicalLines3: Record "Medical Reimbursement Line";
                        begin
                            rec.TestField("Posting Date");
                            rec.TestField("Employee No.");
                            rec.TestField("From Date");
                            if frz_RawatJalan = true then begin
                                frz_Pembedahan := false;

                                rec_MedicalLines3.Reset();
                                rec_MedicalLines3.SetRange("Document No.", rec."No.");
                                if rec_MedicalLines3.FindFirst() then
                                    rec_MedicalLines3.DeleteAll();

                                rec_MedicalValue.Reset();
                                rec_MedicalValue.SetRange("Medical Type", rec_MedicalValue."Medical Type"::"Rawat Inap");
                                rec_MedicalValue.SetFilter("Rawat Inat Type", '<> %1', rec_MedicalValue."Rawat Inat Type"::Pembedahan);
                                rec_MedicalValue.SetFilter(Code, '<> %1', '');
                                if rec_MedicalValue.FindFirst() then
                                    repeat
                                        rec_MedicalLines.Init();
                                        rec_MedicalLines."Document No." := rec."No.";
                                        rec_MedicalLines."Medical Value" := rec_MedicalValue.Code;
                                        rec_MedicalLines."Medical Type" := rec_MedicalValue."Medical Type"::"Rawat Inap";
                                        rec_MedicalLines."Rawat Inat Type" := rec_MedicalValue."Rawat Inat Type"::"Biaya Jasa Perawatan";
                                        rec_MedicalLines.Date := rec."From Date";
                                        rec_MedicalLines."Daily rate - room" := rec_MedicalValue."Daily rate - room";
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
                            end else begin
                                rec_MedicalLines.Reset();
                                rec_MedicalLines.SetRange("Document No.", rec."No.");
                                rec_MedicalLines.SetRange("Medical Type", rec_MedicalLines."Medical Type"::"Rawat Inap");
                                if rec_MedicalLines.FindFirst() then
                                    rec_MedicalLines.DeleteAll();
                            end;

                            CurrPage.Update();
                        end;
                    }

                }
            }
            part("Medical Kacamata"; "MR Line Kacamata")
            {
                ApplicationArea = all;
                Visible = rec."Medical Type 1";
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Rawat jalan"; "MR Line Rawat Jalan")
            {
                ApplicationArea = all;
                ;
                Visible = rec."Medical Type 2";
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Persalinan"; "MR Line Persalinan")
            {
                Visible = rec."Medical Type 4";
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            part("Medical Rawat Inap - Pembedahan"; "MR Line Rawat Inap")
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
        }
    }

    actions
    {
        area(Processing)
        {
            action("Admin - Troubleshoot")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IniMSI;

                trigger
                OnAction()
                begin
                    if not Confirm('Troubleshoot?') then exit;

                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();

                    IF ApprovalDRE2.ConfirmSentApproval('Medical Reimbursement', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetMedicalReimWFEventCodeSendMedicalReimAppReq) then begin
                            WorkflowMgt.HandleEvent(HooksDRE.GetMedicalReimWFEventCodeSendMedicalReimAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveMedicalReim(Rec);
                        end;
                        CurrPage.Close();
                    end;

                    Message('Done.');
                end;
            }

            //dre
            action("Send Approval Request")
            {
                Visible = (NOT OpenApprovalEntriesExist) AND (CanRequestApprovalForFlow)
                and (Rec.Status = Rec.Status::Open);
                ApplicationArea = all;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    PayrollGeneralSetup: Record "Payroll General Setup";
                begin
                    PayrollGeneralSetup.Get();

                    if rec."Total Allowance" = 0 then
                        Error('Total Amount Allowance = 0');

                    Rec.TestField("No.");
                    Rec.TestField("Employee No.");
                    Rec.TestField("Posting Date");
                    Rec.TestField("Status Patient");
                    Rec.TestField("Age of Patient");
                    Rec.TestField(Gender);
                    Rec.TestField("Name of Hospital");
                    Rec.TestField("Address of hospital");
                    Rec.TestField("From Date");
                    Rec.TestField("To Date");
                    // Rec.TestField("Place of Accident");
                    // Rec.TestField(Time);
                    Rec.TestField("Rekening no.");

                    CheckValidasi(Rec);

                    if PayrollGeneralSetup."Activate Approval" then begin
                        IF ApprovalDRE2.ConfirmSentApproval('Medical Reimbursement', Rec."No.") THEN begin
                            if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetMedicalReimWFEventCodeSendMedicalReimAppReq) then begin
                                WorkflowMgt.HandleEvent(HooksDRE.GetMedicalReimWFEventCodeSendMedicalReimAppReq, Rec);
                            end else begin
                                //ApprovalDRE2.CheckLine(Rec);
                                ApprovalDRE2.ApproveMedicalReim(Rec);
                            end;
                            CurrPage.Close();
                        end;
                    end else begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;

                end;
            }

            action(Approve)
            {
                Visible = OpenApprovalEntriesExistForCurrUser;
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if ApprovalDRE2.ConfirmApprove('Medical Reimbursement', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetMedicalReimWFEventCodeApproveMedicalReim()) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetMedicalReimWFEventCodeApproveMedicalReim(), Rec)
                        else
                            Message(HooksDRE.GetNoActiveWFErrorMessage);
                        CurrPage.Close();
                    end;
                end;
            }

            action("Undo Medical Reimbersement")
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    MedicalMgt: Codeunit "Proses Medical Reimbersement";
                    ApprovalChain: Record "Approval Chain Setup";
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

                    MedicalMgt.undoProcessMedicalBalance(Rec."No.");

                    CurrPage.Update();

                    Message('Succesfully undo Medical Reimbersement %1. The status is now open, \' +
                            'Medical Balance for Employee %1 is REVERSED.',
                            Rec."No.", Rec.NamaEmployee(Rec."Employee No."));
                end;
            }
            action("Process Medical")
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                var
                    MedicalMgt: Codeunit "Proses Medical Reimbersement";
                begin
                    rec.TestField(Status, Rec.Status::Released);
                    CheckValidasi(Rec);
                    if not confirm('This process will create medical reimbursement entries\' +
                                   '\' +
                                   'Are you sure to continue?') then
                        exit;

                    MedicalMgt.PostedMedical(Rec);

                    Message('Medical Reimbursement for Employee %1 is succesfully created.',
                            Rec.NamaEmployee(Rec."Employee No."));
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
                    frz_CodeUnitAttach: Codeunit "Attachment Medical";
                begin
                    frz_CodeUnitAttach.UploadAttachment('Medical Reimbursement', Rec."No.");
                end;
            }
            action(Reject)
            {
                Visible = OpenApprovalEntriesExistForCurrUser;
                Image = Reject;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    if ApprovalDRE2.ConfirmReject('Medical Reimbursement', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec,
                           HooksDRE.GetMedicalReimWFEventCodeRejectMedicalReimAppReq) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetMedicalReimWFEventCodeRejectMedicalReimAppReq, Rec)
                        else
                            Message(HooksDRE.GetNoActiveWFErrorMessage);
                        CurrPage.Close();
                    end;
                end;
            }
            action(Comments)
            {
                Visible = OpenApprovalEntriesExistForCurrUser;
                Image = Comment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    ApprovalDRE2.GetApprovalComment(Rec);
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
                    MedicalHeader: Record "Medical Reimbursement Header";
                begin
                    CurrPage.SetSelectionFilter(MedicalHeader);
                    Report.run(Report::"Medical Reimbursement YCP", true, false, MedicalHeader);
                end;
            }
        }
    }
    var
        IniMSI: Boolean;
        frz_InapCheck: Boolean;
        frz_Pembedahan: Boolean;
        frz_RawatJalan: Boolean;
        //dre
        ApprovalDRE2: Codeunit "Approval DRE2";
        HooksDRE: Codeunit "Hooks DRE";
        getOption: array[4] of Boolean;
        getnama: array[4] of Text;
        getcode: array[4] of Text;
        DynamicEditable: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalCustMgt: Codeunit ApprovalCustomManagement;
        WorkflowMgt: Codeunit "Workflow Management";
        Muncul: Boolean;
        CodeBololean1: Boolean;
        CodeBololean2: Boolean;
        CodeBololean3: Boolean;
        CodeBololean4: Boolean;
    // fadhil

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    trigger OnAfterGetRecord()
    var
        frz_MedicalLine: Record "Medical Reimbursement Line";
    begin
        if UserId = 'MSI' then
            IniMSI := true
        else
            IniMSI := false;

        if rec."Medical Type 3" = true then begin
            frz_InapCheck := true;
        end;
        frz_MedicalLine.Reset();
        frz_MedicalLine.SetRange("Document No.", rec."No.");
        if frz_MedicalLine.FindFirst() then begin
            if frz_MedicalLine."Rawat Inat Type" = frz_MedicalLine."Rawat Inat Type"::Pembedahan then begin
                frz_Pembedahan := true;
                frz_RawatJalan := false;
            end;
            if frz_MedicalLine."Rawat Inat Type" = frz_MedicalLine."Rawat Inat Type"::"Biaya Jasa Perawatan" then begin
                frz_Pembedahan := false;
                frz_RawatJalan := true;
            end;
        end;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure SetControlAppearance()
    var
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    procedure CheckValidasi(frz_MedicalHeader: Record "Medical Reimbursement Header")
    var
        frz_MedicalLine: Record "Medical Reimbursement Line";
    begin
        frz_MedicalLine.Reset();
        frz_MedicalLine.SetRange("Document No.", frz_MedicalHeader."No.");
        frz_MedicalLine.SetRange("Paid Amount", 0);
        if frz_MedicalLine.FindFirst() then
            repeat
                frz_MedicalLine.Delete();
            until frz_MedicalLine.Next() = 0;
    end;
}