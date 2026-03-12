page 65010 "Unconditional Leave Request"
{
    PageType = Card;
    Caption = 'Others Paid Leave Request';
    // ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Unconditional Leave Request";
    DataCaptionFields = "No.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        rec."Employee Name" := Rec.GetEmployeeName(true);
                    end;
                }
                field(EmployeeFullName; rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Leave Type Code"; rec."Leave Type Code")
                {
                    ApplicationArea = all;
                    TableRelation = "Master Leave Unconditional".Code;
                    trigger OnValidate()
                    var
                        frz_MasterUnconditional: Record "Master Leave Unconditional";
                        frz_UnconLedger: Record "Uncon Leave Ledger Entry";
                        frz_totalQty: Decimal;
                    begin
                        frz_UnconLedger.Reset();
                        frz_UnconLedger.SetRange("Employee No.", rec."Employee No.");
                        frz_UnconLedger.SetRange("Leave Type Code", Rec."Leave Type Code");
                        if frz_UnconLedger.FindFirst() then
                            repeat
                                frz_totalQty += frz_UnconLedger.Quantity;
                            until frz_UnconLedger.Next = 0;

                        frz_MasterUnconditional.Reset();
                        frz_MasterUnconditional.SetRange(Code, rec."Leave Type Code");
                        if frz_MasterUnconditional.FindFirst() then begin
                            frz_DescMasterLeave := frz_MasterUnconditional.Description;
                            if frz_totalQty >= frz_MasterUnconditional."maximum leave" then
                                Error('Leave has passed the maximum');
                        end;
                        CurrPage.Update();
                    end;
                }
                field(frz_DescMasterLeave; frz_DescMasterLeave)
                {
                    ApplicationArea = all;
                    Caption = 'Leave Type Description';
                    Editable = false;
                }
                field("Employee No. Replacement"; Rec."Employee No. Replacement")
                {
                    Caption = 'My Replacement During Leave';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        EmployeeReplacementName := Rec.GetEmployeeName(false);
                        if rec."Employee No. Replacement" = rec."Employee No." then
                            Error('Employee No. Replacement = Employee No.');
                    end;
                }
                field(EmployeeReplacementName; EmployeeReplacementName)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Employee Replacement Name';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
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
                group("* Note for 0,5 day leave request, please tick below option :")
                {
                    Visible = false;
                    field("Leave-1"; rec."Leave-1")
                    {
                        Caption = 'Leave taken in the morning';
                        ApplicationArea = all;
                    }
                    field("Leave-2"; rec."Leave-2")
                    {
                        Caption = 'Leave taken in the afternoon';
                        ApplicationArea = all;
                    }
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
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

                    IF ApprovalDRE2.ConfirmSentApproval('Other Paid Leave', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetUncondLeaveWFEventCodeSendUncondLeaveAppReq) then begin
                            WorkflowMgt.HandleEvent(HooksDRE.GetUncondLeaveWFEventCodeSendUncondLeaveAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveUnconditionalLeave(Rec);
                        end;
                        CurrPage.Close();
                    end;

                    Message('Done.');
                end;
            }

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
                    Pegawai: Record Employee;
                    PayrollGeneralSetup: Record "Payroll General Setup";
                    frz_EmailUndo: Codeunit "Email Undo";
                    frz_CheckLeave: Codeunit "Leave Checking";
                begin
                    if (rec."Total Number of Days" = 0.5) and (rec."Leave-1" = false) and (rec."Leave-2" = false) then
                        Error('Please tick Leave-1 or Leave-2 if you are taking half day leave');
                    PayrollGeneralSetup.Get();
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");
                    Rec.TestField("Total Number of Days");
                    // frz_CheckLeave.LeaveCheck(rec."Starting Date", rec."Employee No.", rec."No.");
                    frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    Pegawai.Get(Rec."Employee No.");
                    Pegawai.TestField("MSI_HRIS Basic Salary");
                    if PayrollGeneralSetup."Activate Approval" then begin
                        IF ApprovalDRE2.ConfirmSentApproval('Other Paid Leave', Rec."No.") THEN begin
                            if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetUncondLeaveWFEventCodeSendUncondLeaveAppReq) then begin
                                WorkflowMgt.HandleEvent(HooksDRE.GetUncondLeaveWFEventCodeSendUncondLeaveAppReq, Rec);
                            end else begin
                                //ApprovalDRE2.CheckLine(Rec);
                                ApprovalDRE2.ApproveUnconditionalLeave(Rec);
                            end;
                            CurrPage.Close();
                        end;
                    end else begin

                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;


                    //Commit();
                    //frz_EmailUndo.SendEmailUndo();
                end;
            }
            action("Print Unconditional Leave Request")
            {
                Image = Print;
                Caption = 'Print';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    UncoHeader: Record "Unconditional Leave Request";
                begin
                    CurrPage.SetSelectionFilter(UncoHeader);
                    Report.run(Report::"Unconditional Leave Request", true, false, UncoHeader);
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
                    if ApprovalDRE2.ConfirmApprove('Unconditional leave', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetUncondLeaveWFEventCodeApproveUncondLeave()) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetUncondLeaveWFEventCodeApproveUncondLeave(), Rec)
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
                    if ApprovalDRE2.ConfirmReject('Unconditional leave', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec,
                           HooksDRE.GetUncondLeaveWFEventCodeRejectUncondLeaveAppReq) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetUncondLeaveWFEventCodeRejectUncondLeaveAppReq, Rec)
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
                    frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    Rec.TestField(Status, Rec.Status::Released);
                    LeaveMgt.PostLeaveRequest(Rec);
                end;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        clear(OpenApprovalEntriesExistForCurrUser);
        clear(CanRequestApprovalForFlow);
        SetControlAppearance();

        if UserId = 'MSI' then
            IniMSI := true
        else
            IniMSI := false;

        EmployeeName := Rec.GetEmployeeName(true);
        EmployeeReplacementName := Rec.GetEmployeeName(false);
    end;

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


        Employee: Record Employee;
        EmployeeReplacement: Record Employee;
        EmployeeName: Text;
        EmployeeReplacementName: Text;
        LeaveMgt: Codeunit "Unconditional Leave Manage";
        frz_DescMasterLeave: Text;



    trigger
    OnAfterGetCurrRecord()
    var
        frz_MasterUnconditional: Record "Master Leave Unconditional";
    begin
        frz_MasterUnconditional.Reset();
        frz_MasterUnconditional.SetRange(Code, rec."Leave Type Code");
        if frz_MasterUnconditional.FindFirst() then
            frz_DescMasterLeave := frz_MasterUnconditional.Description;

        clear(OpenApprovalEntriesExistForCurrUser);
        clear(CanRequestApprovalForFlow);
        SetControlAppearance();
    end;

    trigger
    OnOpenPage()
    begin
        clear(OpenApprovalEntriesExistForCurrUser);
        clear(CanRequestApprovalForFlow);
        SetControlAppearance();
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