page 60041 "Unpaid Leave Request"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Leave Request";
    SourceTableView = where("Leave Type" = const(Unpaid));
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
                    trigger
                    OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;

                    trigger OnValidate()
                    begin
                        EmployeeName := Rec.GetEmployeeName(true);
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

                        LeaveBalane := Employee."MSI_HRIS Leave Balance";
                        LeaveEligibleBalance := Employee."MSI_HRIS Leave Eligbl. Balance";
                    end;
                }
                field(EmployeeFullName; rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Unpaid Leave Type"; Rec."Unpaid Leave Type")
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
                                    error('The Date is Weekend or Not Working 1');
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
                                rec_BaseCalendar2.SetRange(Day, Date2DWY(Rec."Ending Date", 1));
                                rec_BaseCalendar2.SetFilter(Date, '= %1', 0D);
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
                /*
                field(LeaveBalane; LeaveBalane)
                {
                    Caption = 'Leave Balance';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(LeaveEligibleBalance; LeaveEligibleBalance)
                {
                    Caption = 'Leave Eligible Balance';
                    ApplicationArea = all;
                    Editable = false;
                }*/
                field("Salary Deduction"; deductionnya)
                {
                    ApplicationArea = all;
                    Editable = false;
                    // Visible = hideDeduction;
                }
                field("Salary Deduction ORI"; rec."Salary Deduction")
                {
                    ApplicationArea = all;
                    Caption = 'Salary Deduction';
                    Visible = false;
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

                    IF ApprovalDRE2.ConfirmSentApproval('Unpaid Leave', Rec."No.") THEN begin
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
                    EmployeeAbsenceLine: Record "Employee Absence Line";
                    PayrollGeneralSetup: Record "Payroll General Setup";
                    MasterLeaveType: Record "Master Leave Unconditional";
                    BulanStarting: Integer;
                    BulanEnding: Integer;
                    LeaveRequest: Record "Leave Request";
                begin
                    // if (rec."Total Number of Days" = 0.5) and (rec."Leave-1" = false) and (rec."Leave-2" = false) then
                    //     Error('Please tick Leave-1 or Leave-2 if you are taking half day leave');
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");

                    // frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.");
                    // frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement");
                    //Cek range tanggal cuti apakah ada attendance yg diinput
                    if rec."Total Number of Days" <> 0.5 then begin
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."Employee No.");
                        EmployeeAbsenceLine.SetRange(Date, Rec."Starting Date", Rec."Ending Date");
                        if EmployeeAbsenceLine.FindFirst() then
                            Error('There is an attendance registration data within your leave dates. Pleace check.');
                    end;

                    LeaveRequest.Reset();
                    LeaveRequest.SetRange("Employee No.", Rec."Employee No.");
                    LeaveRequest.SetRange("Starting Date", Rec."Starting Date", Rec."Ending Date");
                    if LeaveRequest.FindFirst() then
                        Error('There is an existing leave request for the same period.');

                    LeaveRequest.Reset();
                    LeaveRequest.SetRange("Employee No.", Rec."Employee No.");
                    LeaveRequest.SetRange("Ending Date", Rec."Starting Date", Rec."Ending Date");
                    if LeaveRequest.FindFirst() then
                        Error('There is an existing leave request for the same period.');

                    //pastikan starting dan ending date berada di bulan yang sama
                    //alias tidak boleh sebrang bulan
                    BulanStarting := Date2DMY(Rec."Starting Date", 2);
                    BulanEnding := Date2DMY(Rec."Ending Date", 2);
                    if BulanStarting <> BulanEnding then
                        Error('Period must be in the same month.');

                    //Cek leave type code, jika yg dipilih itu ada tickmark no backdated,
                    //maka period harus lebih besar daripada posting date
                    MasterLeaveType.Get(Rec."Document Type"::"Unpaid Leave", Rec."Leave Type Code");
                    if MasterLeaveType."No Backdated" then
                        if Rec."Starting Date" <= Rec."Posting Date" then
                            Error('Leave type %1 is set to no backdated input.\' +
                                  'So starting date must be bigger than posting date.',
                                  Rec."Leave Type Code");

                    //if PayrollGeneralSetup."Activate Approval" then begin

                    IF ApprovalDRE2.ConfirmSentApproval('Unpaid Leave', Rec."No.") THEN begin
                        if WorkflowMgt.CanExecuteWorkflow(Rec, HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq) then begin
                            WorkflowMgt.HandleEvent(HooksDRE.GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq, Rec);
                        end else begin
                            //ApprovalDRE2.CheckLine(Rec);
                            ApprovalDRE2.ApproveAnnualLeave(Rec);
                        end;
                        CurrPage.Close();
                    end;

                    //end else begin
                    //    Rec.Status := Rec.Status::Released;
                    //    Rec.Modify();
                    //end;
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
                    if ApprovalDRE2.ConfirmApprove('Unpaid Leave', Rec."No.") then begin
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
                    if ApprovalDRE2.ConfirmReject('Unpaid Leave', Rec."No.") then begin
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
            action(Release)
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
                    EmployeeAbsenceLine: Record "Employee Absence Line";
                    frz_CheckingLeave: Codeunit "Leave Checking";
                begin
                    Rec.TestField("Employee No.");
                    Rec.TestField("Starting Date");
                    Rec.TestField("Ending Date");
                    frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    //Cek range tanggal cuti apakah ada attendance yg diinput
                    if rec."Total Number of Days" <> 0.5 then begin
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."Employee No.");
                        EmployeeAbsenceLine.SetRange(Date, Rec."Starting Date", Rec."Ending Date");
                        if EmployeeAbsenceLine.FindFirst() then
                            Error('There is an attendance registration data within your leave dates. Pleace check.');
                    end;

                    //if Rec."Total Number of Days" > LeaveEligibleBalance then
                    //    if not Confirm(StrConfirm + '\' + StrConfirm2 + '\' + StrConfirm3) then exit;

                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();

                    //LeaveMgt.PostLeaveRequest(Rec);
                end;
            }
            // fadhil
            action("Print Leave Request")
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
                    frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No.", rec."No.");
                    // if Rec."Employee No. Replacement" <> '' then
                    //     frz_CheckingLeave.TemporaryDate(rec."Starting Date", rec."Ending Date", rec."Employee No. Replacement", rec."No.");
                    LeaveMgt.PostLeaveRequest(Rec);
                end;
            }
            // fadhil
        }
    }

    trigger OnOpenPage()
    begin
        clear(OpenApprovalEntriesExistForCurrUser);
        clear(CanRequestApprovalForFlow);
        SetControlAppearance();
    end;

    trigger OnAfterGetRecord()
    var
        employeenya: Record Employee;
        usernya: Record User;
    begin
        if UserId = 'MSI' then
            IniMSI := true
        else
            IniMSI := false;


        employeenya.Reset();
        employeenya.SetRange("No.", rec."Employee No.");
        if employeenya.FindFirst() then begin
            usernya.Reset();
            usernya.SetRange("User Security ID", employeenya."User SID");
            if usernya.FindFirst() then begin
                if usernya."User Name" = UserId then
                    deductionnya := rec."Salary Deduction";
            end;
            if employeenya."MSI_HRIS Admin By" = UserId then
                deductionnya := rec."Salary Deduction";

        end;

        EmployeeName := Rec.GetEmployeeName(true);
        EmployeeReplacementName := Rec.GetEmployeeName(false);

        Employee.Get(Rec."Employee No.");
        Employee.CalcFields("MSI_HRIS Leave Eligbl. Balance");
        Employee.CalcFields("MSI_HRIS Leave Balance");

        LeaveBalane := Employee."MSI_HRIS Leave Balance";
        LeaveEligibleBalance := Employee."MSI_HRIS Leave Eligbl. Balance";
    end;

    var
        IniMSI: Boolean;
        hideDeduction: Boolean;
        Employee: Record Employee;
        EmployeeReplacement: Record Employee;
        EmployeeName: Text;
        EmployeeReplacementName: Text;
        LeaveMgt: Codeunit "Leave Management";
        LeaveBalane: Decimal;
        deductionnya: Decimal;
        LeaveEligibleBalance: Decimal;
        StrConfirm: Label 'Your leave days requested is more than your leave eligible balance';
        StrConfirm2: Label 'This will create a negative balance.';
        StrConfirm3: Label 'Are you sure to continue?';
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