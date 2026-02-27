page 60040 "Paid Leave Request"
{
    PageType = Card;
    caption = 'Annual Leave Request';
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Leave Request";
    SourceTableView = where("Leave Type" = const(Paid));

    DataCaptionFields = "No.";
    RefreshOnActivate = true;


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
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        rec."Employee Name" := Rec.GetEmployeeName(true);
                        Employee.Get(Rec."Employee No.");
                        Employee.CalcFields("MSI_HRIS Leave Eligbl. Balance");
                        Employee.CalcFields("MSI_HRIS Leave Balance");
                        LeaveEligibleBalance := Employee."MSI_HRIS Leave Eligbl. Balance";
                        frz_Balance := Employee."MSI_HRIS Leave Balance";
                    end;
                }
                field(EmployeeFullName; rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Paid Leave Type"; Rec."Paid Leave Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Leave Type Code"; rec."Leave Type Code")
                {
                    ApplicationArea = all;
                    TableRelation = "Master Leave Unconditional".Code where("Document Type" = field("Document Type"));
                }
                field("Employee No. Replacement"; Rec."Employee No. Replacement")
                {
                    Caption = 'My Replacement During Leave';
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        EmployeeReplacementName := Rec.GetEmployeeName(false);
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
                        trigger OnValidate()
                        var
                            rec_BaseCalendar: Record "Base Calendar Change";
                            rec_BaseCalendar2: Record "Base Calendar Change";
                            rec_PayrollGenSetup: Record "Payroll General Setup";
                        begin
                            rec_PayrollGenSetup.FindFirst();
                            rec_BaseCalendar.Reset();
                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                            rec_BaseCalendar.SetRange(Date, Rec."Starting Date");
                            if rec_BaseCalendar.FindFirst() then begin
                                if rec_BaseCalendar.Nonworking = true then begin
                                    error('The Date is Weekend or Not Working');
                                end;
                            end else begin
                                rec_BaseCalendar2.Reset();
                                rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                rec_BaseCalendar2.SetRange(Day, Date2DWY(Rec."Starting Date", 1));
                                rec_BaseCalendar2.SetRange(Date, 0D);
                                if rec_BaseCalendar2.FindFirst() then
                                    if rec_BaseCalendar2.Nonworking = true then
                                        error('The Date is Weekend or Not Working');
                            end;
                        end;
                    }
                    field("Ending Date"; Rec."Ending Date")
                    {
                        ApplicationArea = all;
                        ShowCaption = false;
                        trigger OnValidate()
                        var
                            rec_BaseCalendar: Record "Base Calendar Change";
                            rec_BaseCalendar2: Record "Base Calendar Change";
                            rec_PayrollGenSetup: Record "Payroll General Setup";
                        begin
                            rec_PayrollGenSetup.FindFirst();
                            rec_BaseCalendar.Reset();
                            rec_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                            rec_BaseCalendar.SetRange(Date, Rec."Ending Date");
                            if rec_BaseCalendar.FindFirst() then begin
                                if rec_BaseCalendar.Nonworking = true then begin
                                    error('The Date is Weekend or Not Working');
                                end;
                            end else begin
                                rec_BaseCalendar2.Reset();
                                rec_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                rec_BaseCalendar2.SetRange(Date, 0D);
                                rec_BaseCalendar2.SetRange(Day, Date2DWY(Rec."Ending Date", 1));
                                if rec_BaseCalendar2.FindFirst() then
                                    if rec_BaseCalendar2.Nonworking = true then
                                        error('The Date is Weekend or Not Working');
                            end;
                        end;
                    }
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if rec."Starting Date" = rec."Ending Date" then begin
                            if Rec."Total Number of Days" <= 1 then
                                rec."Total Number of Days" := rec."Total Number of Days"
                            else
                                Error('Total days cannot be more than 1');
                        end else
                            Error('Cannot be edited because the start date is not the same as the end date');

                        CurrPage.Update();
                    end;
                }
                group("* Note for 0,5 day leave request, please tick below option :")
                {
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
                field(frz_Balance; frz_Balance)
                {
                    Caption = 'Leave Balance as per Contract';
                    ApplicationArea = all;
                    Editable = false;
                    // visible = false;
                }
                field(LeaveEligibleBalance; LeaveEligibleBalance)
                {
                    Caption = 'Leave Eligible Balance';
                    ApplicationArea = all;
                    Editable = false;
                    // visible = false;
                }
                field("Projected Eligible Balance"; Rec."Projected Eligible Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    // visible = false;
                }
                field(LeaveValue; frz_Employee.LeaveValue())
                {
                    Caption = 'Leave Balance (Value)';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
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

                    IF ApprovalDRE2.ConfirmSentApproval('Annual Leave', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq) then begin
                            WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveAnnualLeave(Rec);
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
                    coba := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, PAGE::"Paid Leave Request",
                                Rec, True);

                    coba2 := Format(Rec.RecordId, 0, 10);


                    URL := STRSUBSTNO('<a href = ''%1&mode=edit&bookmark=%2''>%3</a>', coba,
                            coba2, 'Klik di sini');

                    Message(URL);
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
                    PayrollGeneralSetup: Record "Payroll General Setup";
                    EmployeeAbsenceLine: Record "Employee Absence Line";
                    frz_CheckingLeave: Codeunit "Leave Checking";
                    PaidLeaveRequest: Record "Leave Request";
                begin
                    if (rec."Total Number of Days" = 0.5) and (rec."Leave-1" = false) and (rec."Leave-2" = false) then
                        Error('Please tick Leave-1 or Leave-2 if you are taking half day leave');
                    PayrollGeneralSetup.Get();
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");
                    Rec.TestField("Total Number of Days");
                    frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if rec."Employee No. Replacement" <> '' then
                    //     frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    //Cek range tanggal cuti apakah ada attendance yg diinput
                    if rec."Total Number of Days" <> 0.5 then begin
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."Employee No.");
                        EmployeeAbsenceLine.SetRange(Date, Rec."Starting Date", Rec."Ending Date");
                        if EmployeeAbsenceLine.FindFirst() then
                            Error('There is an attendance registration data within your leave dates. Pleace check.');
                    end;

                    if (Rec."Total Number of Days" > LeaveEligibleBalance) and
                        (Rec."Paid Leave Type" <> Rec."Paid Leave Type"::Sick) then
                        if not Confirm(StrConfirm + '\' + StrConfirm2 + '\' + StrConfirm3) then exit;

                    if PayrollGeneralSetup."Activate Approval" then begin
                        IF ApprovalDRE2.ConfirmSentApproval('Annual Leave', Rec."No.") THEN begin
                            if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq) then begin
                                WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq, Rec);
                            end else begin
                                //ApprovalDRE2.CheckLine(Rec);
                                ApprovalDRE2.ApproveAnnualLeave(Rec);
                            end;

                            /*
                            if PaidLeaveRequest.Get(Rec."Leave Type"::Paid, Rec."No.") then begin
                                PaidLeaveRequest.CalcFields("Approver ID");
                                if PaidLeaveRequest."Approver ID" = '' then begin
                                    if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq) then begin
                                        WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq, Rec);
                                    end else begin
                                        //ApprovalDRE2.CheckLine(Rec);
                                        ApprovalDRE2.ApproveAnnualLeave(Rec);
                                    end;
                                end;
                            end;*/

                            CurrPage.Close();
                        end;
                    end else begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;
                end;
            }
            // fadhil
            action("Print")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    LeaveHeader: Record "Leave Request";
                begin
                    CurrPage.SetSelectionFilter(LeaveHeader);
                    Report.run(Report::"Paid Leave Request", true, false, LeaveHeader);
                end;
            }
            // fadhil
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
                    if ApprovalDRE2.ConfirmApprove('Annual Leave', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetAnnualLeaveWFEventCodeApproveAnnualLeave()) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeApproveAnnualLeave(), Rec)
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
                    if ApprovalDRE2.ConfirmReject('Annual Leave', Rec."No.") then begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec,
                           HooksDRE.GetAnnualLeaveWFEventCodeRejectAnnualLeaveAppReq) then
                            WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeRejectAnnualLeaveAppReq, Rec)
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
                    frz_CheckingLeave: Codeunit "Leave Checking";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    LeaveMgt.PostLeaveRequest(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
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

        Employee.Get(Rec."Employee No.");
        Employee.CalcFields("MSI_HRIS Leave Eligbl. Balance");
        LeaveEligibleBalance := Employee."MSI_HRIS Leave Eligbl. Balance";

        if Rec."Eligible Minus" then
            Merah := true
        else
            Merah := false;
    end;

    var
        IniMSI: Boolean;
        Merah: Boolean;
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
        LeaveMgt: Codeunit "Leave Management";
        frz_Employee: Record Employee;
        frz_Balance: Decimal;
        LeaveEligibleBalance: Decimal;
        StrConfirm: Label 'Your leave days requested is more than your leave eligible balance';
        StrConfirm2: Label 'This will create a negative balance.';
        StrConfirm3: Label 'Are you sure to continue?';

    trigger OnAfterGetCurrRecord()
    var
        frz_LeaveLedger: Record "Leave Ledger Entry";
    begin
        clear(OpenApprovalEntriesExistForCurrUser);
        clear(CanRequestApprovalForFlow);
        SetControlAppearance();

        frz_Employee.Reset();
        frz_Employee.SetRange("No.", Rec."Employee No.");
        if frz_Employee.FindFirst() then begin
            frz_Employee.FindFirst();
            frz_Balance := frz_Employee."MSI_HRIS Leave Balance";
        end;

        frz_Balance := 0;
        frz_LeaveLedger.Reset();
        frz_LeaveLedger.SetRange("Employee No.", Rec."Employee No.");
        if frz_LeaveLedger.FindFirst() then begin
            repeat
                frz_Balance += frz_LeaveLedger.Quantity;
            until frz_LeaveLedger.Next = 0;
        end;

    end;

    trigger OnOpenPage()
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