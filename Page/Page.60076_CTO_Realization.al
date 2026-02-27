page 60076 "CTO Realization"
{
    Caption = 'Realization of Compensatory Time Off';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CTO Realization Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
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
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        if Rec."Employee No." <> '' then
                            EmpName := Rec.NamaEmployee(Rec."Employee No.");
                        CurrPage.Update();
                    end;
                }
                field(EmpName; EmpName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Employee No. Replacement"; Rec."Employee No. Replacement")
                {
                    ApplicationArea = all;
                    Caption = 'My Replacement During Leave';
                    trigger
                    OnValidate()
                    begin
                        if Rec."Employee No. Replacement" <> '' then
                            ReplaceName := Rec.NamaEmployee(Rec."Employee No. Replacement");
                    end;
                }
                field(ReplaceName; ReplaceName)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Employee Replacement Name';
                }
                group(Period)
                {
                    field("Starting Date"; Rec."Starting Date")
                    {
                        ApplicationArea = all;
                        ShowCaption = false;
                    }
                    field("Ending Date"; Rec."Ending Date")
                    {
                        ApplicationArea = all;
                        ShowCaption = false;
                    }
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                }
                field("Employee CTO Balance"; CTOBalance)
                {
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        CTOLEdgerEntryPage: page "CTO Ledger Entries";
                        CTOLEdgerEntry: record "CTO Ledger Entry";
                    begin
                        CTOLEdgerEntry.SetRange("Employee No.", rec."Employee No.");
                        CTOLEdgerEntryPage.SetTableView(CTOLEdgerEntry);
                        CTOLEdgerEntryPage.Run();
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
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

                    IF ApprovalDRE2.ConfirmSentApproval('CTO Realization', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTORealWFEventCodeSendCTORealAppReq) then begin
                            //Error('gila=%1', HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq);

                            WorkflowMgt.HandleEvent(HooksDRE.GetCTORealWFEventCodeSendCTORealAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveCTOReal(Rec);
                        end;
                        CurrPage.Close();
                    end;

                    Message('Done.');
                end;
            }

            action(test)
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                var
                    coba: Text;
                    coba2: Text;
                    URL: Text;
                begin
                    coba := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, PAGE::"CTO Realization",
                                Rec, True);

                    coba2 := Format(Rec.RecordId, 0, 10);


                    URL := STRSUBSTNO('<a href = ''%1&mode=edit&bookmark=%2''>%3</a>', coba,
                            coba2, 'Klik di sini');

                    Message(URL);
                end;
            }

            action("Send Approval Request")
            {
                Visible = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
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
                    frz_CheckLeave: Codeunit "Leave Checking";
                begin
                    PayrollGeneralSetup.Get();
                    Rec.TestField("Document Date");
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");
                    frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    if Rec."Ending Date" <> 0D then
                        if Rec."Starting Date" > Rec."Ending Date" then
                            Error('Starting period date cannot be bigger than ending period date.');

                    if Rec."Starting Date" <> 0D then
                        if Rec."Ending Date" < Rec."Starting Date" then
                            Error('Ending period date cannot be smaller than starting period date.');




                    LeaveMgt.validateRangeDateRealization(Rec."No.");

                    if PayrollGeneralSetup."Activate Approval" then begin
                        IF ApprovalDRE2.ConfirmSentApproval('CTO Realization', Rec."No.") THEN begin
                            if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTORealWFEventCodeSendCTORealAppReq) then begin
                                //Error('gila=%1', HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq);

                                WorkflowMgt.HandleEvent(HooksDRE.GetCTORealWFEventCodeSendCTORealAppReq, Rec);
                            end else begin
                                //ApprovalDRE2.CheckLine(Rec);
                                ApprovalDRE2.ApproveCTOReal(Rec);
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

                trigger
                OnAction()
                begin
                    if ApprovalDRE2.ConfirmApprove('CTO Realization', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTORealWFEventCodeApproveCTOReal()) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetCTORealWFEventCodeApproveCTOReal(), Rec)
                        else
                            Message(HooksDRE.GetNoActiveWFErrorMessage);
                        CurrPage.Close();
                    end;
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
                    if ApprovalDRE2.ConfirmReject('CTO Realization', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec,
                           HooksDRE.GetCTORealWFEventCodeRejectCTORealAppReq) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetCTORealWFEventCodeRejectCTORealAppReq, Rec)
                        else
                            Message(HooksDRE.GetNoActiveWFErrorMessage);
                        CurrPage.Close();
                    end;
                end;
            }
            action(Comments)
            {
                //Visible = OpenApprovalEntriesExistForCurrUser;
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
            action("Print CTO Realization")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    CTOHeader: Record "CTO Realization Header";
                begin
                    CurrPage.SetSelectionFilter(CTOHeader);
                    Report.run(Report::"CTO Realization", true, false, CTOHeader);
                end;
            }

            /*
            action(Reopen)
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                end;
            }
            
            action(Release)
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                begin
                    Rec.TestField("Document Date");
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");

                    LeaveMgt.validateRangeDateRealization(Rec."No.");

                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                end;
            }*/

            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                var
                    frz_CheckLeave: Codeunit "Leave Checking";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    LeaveMgt.postCTORealization(Rec);
                end;
            }
        }
    }

    var
        IniMSI: Boolean;
        ApprovalDRE2: Codeunit "Approval DRE2";
        HooksDRE: Codeunit "Hooks DRE";
        ApprovalEntry: Record "Approval Entry";

        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowEventHand: Codeunit "Workflow Event Handling";
        [InDataSet]
        OpenApprovalEntriesExistForCurrUser: Boolean;
        [InDataSet]
        OpenApprovalEntriesExist: Boolean;
        [InDataSet]
        ShowWorkflowStatus: Boolean;
        [InDataSet]
        CanCancelApprovalForRecord: Boolean;
        [InDataSet]
        CanCancelApprovalForFlow: Boolean;
        [InDataSet]
        CanRequestApprovalForFlow: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";


        LeaveMgt: Codeunit "Leave Management";
        EmpName: Text;
        ReplaceName: Text;
        CTOBalance: integer;

    trigger OnAfterGetCurrRecord();
    begin
        SetControlAppearance();
    end;

    trigger
    OnAfterGetRecord()
    var
        CTOLedgerEntry: Record "CTO Ledger Entry";
    begin
        if UserId = 'MSI' then
            IniMSI := true
        else
            IniMSI := false;

        if Rec."Employee No." <> '' then
            EmpName := Rec.NamaEmployee(Rec."Employee No.");

        if Rec."Employee No. Replacement" <> '' then
            ReplaceName := Rec.NamaEmployee(Rec."Employee No. Replacement");

        // fadhil 
        CTOLedgerEntry.Reset();
        CTOLedgerEntry.setrange("Employee No.", rec."Employee No.");
        CTOLedgerEntry.setrange(Expired, false);
        CTOLedgerEntry.CalcSums("Day Balance");
        CTOBalance := CTOLedgerEntry."Day Balance";
        // fadhil //
    end;


    local procedure SetControlAppearance()
    var
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        // ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}