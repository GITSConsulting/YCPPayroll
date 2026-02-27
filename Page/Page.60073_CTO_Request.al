page 60073 "CTO Request"
{
    Caption = 'Request of Compensatory Time Off';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CTO Request Header";

    layout
    {
        area(Content)
        {
            group(GENERAL)
            {
                field("No."; Rec."No.")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
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
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        EmpName := Rec.NamaEmployee(Rec."Employee No.");
                    end;
                }
                field(EmpName; EmpName)
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("CTO Balance"; Rec."CTO Balance")
                {
                    Caption = 'CTO Balance For This Document';
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;

                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Expired Date"; Rec."Expired Date")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;

                    ApplicationArea = all;
                    Editable = false;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("PROJECTED BALANCE")
            {
                field("Projected Calculated"; Rec."Projected Calculated")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Projected CTO Balance Calculated';
                }
                field("Projected CTO Balance"; Rec."Projected CTO Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(Subform; "CTO Request Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
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

                    IF ApprovalDRE2.ConfirmSentApproval('CTO Request', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq) then begin
                            //Error('gila=%1', HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq);

                            WorkflowMgt.HandleEvent(HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveCTOReq(Rec);
                        end;
                        CurrPage.Close();
                    end;

                    Message('Done.');
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
                    LeaveMgt: Codeunit "Leave Management";
                begin
                    PayrollGeneralSetup.Get();
                    Rec.TestField(Expired, false);
                    Rec.TestField("Projected Calculated");
                    Rec.TestField("CTO Balance", 0);
                    Rec.TestField("Document Date");
                    LeaveMgt.CTORequestCheckLine(Rec);

                    if PayrollGeneralSetup."Activate Approval" then begin
                        IF ApprovalDRE2.ConfirmSentApproval('CTO Request', Rec."No.") THEN begin
                            if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq) then begin
                                //Error('gila=%1', HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq);

                                WorkflowMgt.HandleEvent(HooksDRE.GetCTOReqWFEventCodeSendCTOReqAppReq, Rec);
                            end else begin
                                //ApprovalDRE2.CheckLine(Rec);
                                ApprovalDRE2.ApproveCTOReq(Rec);
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
                    Rec.TestField("Projected Calculated");
                    Rec.TestField("CTO Balance", 0);
                    Rec.TestField("Document Date");

                    Rec.TestField(Expired, false);

                    if ApprovalDRE2.ConfirmApprove('CTO Request', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetCTOReqWFEventCodeApproveCTOReq()) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetCTOReqWFEventCodeApproveCTOReq(), Rec)
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
                    Rec.TestField("Projected Calculated");
                    Rec.TestField("CTO Balance", 0);
                    Rec.TestField("Document Date");
                    Rec.TestField(Expired, false);

                    if ApprovalDRE2.ConfirmReject('CTO Request', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec,
                           HooksDRE.GetCTOReqWFEventCodeRejectCTOReqAppReq) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetCTOReqWFEventCodeRejectCTOReqAppReq, Rec)
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

            action("Undo CTO Balance")
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
                    leaveMgt: Codeunit "Leave Management";
                    ApprovalChain: Record "Approval Chain Setup";
                begin
                    ApprovalChain.Reset();
                    ApprovalChain.SetRange("Document Type", ApprovalChain."Document Type"::"CTO Request");
                    ApprovalChain.SetRange(ID, UserId);
                    if not ApprovalChain.FindFirst() then
                        Error('You have to be an approver to undo CTO Request.')
                    else
                        if not ApprovalChain."Able to Undo CTO Request" then
                            Error('You are not authorized to undo CTO Request.');

                    Rec.TestField(Status, Rec.Status::Released);

                    if not confirm('This process will create reversal CTO entries\' +
                                   'as a correction, and then reopen this document. \' +
                                   '\' +
                                   'Are you sure to continue?') then
                        exit;

                    leaveMgt.undoProcessCTOBalance(Rec."No.");

                    CurrPage.Update();

                    Message('Succesfully undo CTO %1. The status is now open, \' +
                            'CTO Balance for Employee %1 is REVERSED.',
                            Rec."No.", Rec.NamaEmployee(Rec."Employee No."));
                end;
            }
            action("Post")
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
                    LeaveMgt: Codeunit "Leave Management";

                begin
                    //rec.TestField(Status, Rec.Status::Released);

                    if not confirm('This process will create CTO entries\' +
                                   'and posted document,\' +
                                   'Are you sure to continue?') then
                        exit;

                    LeaveMgt.createCTOBalance(Rec);

                    Message('CTO for Employee %1 is succesfully posted.',
                            Rec.NamaEmployee(Rec."Employee No."));
                end;
            }
            action("Calculate Projected CTO Balance")
            {
                ApplicationArea = All;
                Image = CalculateWIP;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                    hasilHitungBalance: Integer;
                begin
                    LeaveMgt.CTORequestCheckLine(Rec);
                    LeaveMgt.projectedCTOBalance(Rec."No.", hasilHitungBalance);

                    if hasilHitungBalance > 0 then begin
                        Rec."Projected Calculated" := true;
                        Rec."Projected CTO Balance" := hasilHitungBalance;
                        Rec.Modify();
                    end;

                    CurrPage.Update();
                end;
            }
            // fadhil
            action("Print CTO")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    CTOHeader: Record "CTO Request Header";
                begin
                    CurrPage.SetSelectionFilter(CTOHeader);
                    Report.run(Report::"CTO Form", true, false, CTOHeader);
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



        EmpName: Text;
        Merah: Boolean;
        TextMerah: Text;

    trigger OnAfterGetCurrRecord();
    begin
        SetControlAppearance();
    end;

    trigger
    OnAfterGetRecord()
    begin
        if UserId = 'MSI' then
            IniMSI := true
        else
            IniMSI := false;

        if Rec."Employee No." <> '' then
            EmpName := Rec.NamaEmployee(Rec."Employee No.");

        if Rec.Expired then begin
            Merah := true;
        end else begin
            Merah := false;
        end;
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