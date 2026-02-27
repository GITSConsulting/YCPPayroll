codeunit 60009 "Hooks DRE"
{
    Permissions = TableData 169 = rimd,
                  TableData 480 = rimd,
                  TableData 45 = rimd,
                  TableData 5222 = rimd,
                  tabledata 5223 = rimd,
                  TableData 17 = rimd,
                  TableData 456 = rimd,
                  tabledata 380 = rimd,
                  TableData 454 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Cash/bank transaction on direct journal is not allowed after %1';
        Text004: Label 'This entry has been used in posted or ledger entries.';
        Text009: Label 'Any action are not allowed while the status is ''Pending Approval''';
        Text010: Label 'Status must be ''Approved'' in order to move to the next stage.';
        Text011: Label 'You cannot delete the entry while the budget lines exist.';
        Text012: Label 'Invalid contact number format.';
        Text013: Label 'Update is not allowed while the status is ''Approved''';
        Text014: Label 'You cannot modify the column "%1';

        AdvanceWFEventCodeSendAdvanceAppReq: Label '50000_SEND_ADVANCE_APP_REQUEST';
        AdvanceWFEventCodeCancelAdvanceAppReq: Label '50000_CANCEL_ADVANCE_APP_REQUEST';
        AdvanceWFEventCodeRejectAdvanceAppReq: Label '50000_REJECT_ADVANCE_APP_REQUEST';
        AdvanceWFEventCodeDelegateAdvanceAppReq: Label '50000_DELEGATE_ADVANCE_APP_REQUEST';
        AdvanceWFEventCodeApproveAdvanceAppReq: Label '50000_APPROVE_ADVANCE_APP_REQUEST';
        AdvanceWFEventCodeReleaseAdvance: Label '50000_RELEASE_ADVANCE';
        AdvanceWFResponseCodePending: Label '50000_UPDATE_STATUS_PENDING';
        AdvanceWFResponseCodeOpen: Label '50000_UPDATE_STATUS_OPEN';
        AdvanceWFResponseCodeRelease: Label '50000_UPDATE_STATUS_RELEASED';
        AdvanceWFResponseCodeCreateAppChain: Label '50000_CREATE_APPROVAL_CHAIN';
        AdvanceWFResponseCodeRunAppChain: Label '50000_RUN_APPROVAL_CHAIN';
        AdvanceWFResponseCodeDelegateAppChain: Label '50000_DELEGATE_APPROVAL_CHAIN';
        AdvanceWFResponseCodeRejectAppChain: Label '50000_REJECT_APPROVAL_CHAIN';
        AdvanceWFResponseCodeCancelAppChain: Label '50000_CANCEL_APPROVAL_CHAIN';


        //CTO REQUEST
        CTOReqWFEventCodeSendCTOReqAppReq: Label '60037_SEND_CTOREQ_APP_REQUEST';
        CTOReqWFEventCodeCancelCTOReqAppReq: Label '60037_CANCEL_CTOREQ_APP_REQUEST';
        CTOReqWFEventCodeRejectCTOReqAppReq: Label '60037_REJECT_CTOREQ_APP_REQUEST';
        CTOReqWFEventCodeDelegateCTOReqAppReq: Label '60037_DELEGATE_CTOREQ_APP_REQUEST';
        CTOReqWFEventCodeApproveCTOReqAppReq: Label '60037_APPROVE_CTOREQ_APP_REQUEST';
        CTOReqWFEventCodeReleaseCTOReq: Label '60037_RELEASE_CTOREQ';
        CTOReqWFResponseCodePending: Label '60037_UPDATE_STATUS_PENDING';
        CTOReqWFResponseCodeOpen: Label '60037_UPDATE_STATUS_OPEN';
        CTOReqWFResponseCodeRelease: Label '60037_UPDATE_STATUS_RELEASED';
        CTOReqWFResponseCodeCreateAppChain: Label '60037_CREATE_APPROVAL_CHAIN';
        CTOReqWFResponseCodeRunAppChain: Label '60037_RUN_APPROVAL_CHAIN';
        CTOReqWFResponseCodeDelegateAppChain: Label '60037_DELEGATE_APPROVAL_CHAIN';
        CTOReqWFResponseCodeRejectAppChain: Label '60037_REJECT_APPROVAL_CHAIN';
        CTOReqWFResponseCodeCancelAppChain: Label '60037_CANCEL_APPROVAL_CHAIN';




        //CTO REALIZATION
        CTORealWFEventCodeSendCTORealAppReq: Label '60039_SEND_CTOREAL_APP_REQUEST';
        CTORealWFEventCodeCancelCTORealAppReq: Label '60039_CANCEL_CTOREAL_APP_REQUEST';
        CTORealWFEventCodeRejectCTORealAppReq: Label '60039_REJECT_CTOREAL_APP_REQUEST';
        CTORealWFEventCodeDelegateCTORealAppReq: Label '60039_DELEGATE_CTOREAL_APP_REQUEST';
        CTORealWFEventCodeApproveCTORealAppReq: Label '60039_APPROVE_CTOREAL_APP_REQUEST';
        CTORealWFEventCodeReleaseCTOReal: Label '60039_RELEASE_CTOREAL';
        CTORealWFResponseCodePending: Label '60039_UPDATE_STATUS_PENDING';
        CTORealWFResponseCodeOpen: Label '60039_UPDATE_STATUS_OPEN';
        CTORealWFResponseCodeRelease: Label '60039_UPDATE_STATUS_RELEASED';
        CTORealWFResponseCodeCreateAppChain: Label '60039_CREATE_APPROVAL_CHAIN';
        CTORealWFResponseCodeRunAppChain: Label '60039_RUN_APPROVAL_CHAIN';
        CTORealWFResponseCodeDelegateAppChain: Label '60039_DELEGATE_APPROVAL_CHAIN';
        CTORealWFResponseCodeRejectAppChain: Label '60039_REJECT_APPROVAL_CHAIN';
        CTORealWFResponseCodeCancelAppChain: Label '60039_CANCEL_APPROVAL_CHAIN';


        //ANNUAL LEAVE
        AnnualLeaveWFEventCodeSendAnnualLeaveAppReq: Label '60020_SEND_ANNUALLEAVE_APP_REQUEST';
        AnnualLeaveWFEventCodeCancelAnnualLeaveAppReq: Label '60020_CANCEL_ANNUALLEAVE_APP_REQUEST';
        AnnualLeaveWFEventCodeRejectAnnualLeaveAppReq: Label '60020_REJECT_ANNUALLEAVE_APP_REQUEST';
        AnnualLeaveWFEventCodeDelegateAnnualLeaveAppReq: Label '60020_DELEGATE_ANNUALLEAVE_APP_REQUEST';
        AnnualLeaveWFEventCodeApproveAnnualLeaveAppReq: Label '60020_APPROVE_ANNUALLEAVE_APP_REQUEST';
        AnnualLeaveWFEventCodeReleaseAnnualLeave: Label '60020_RELEASE_ANNUALLEAVE';
        AnnualLeaveWFResponseCodePending: Label '60020_UPDATE_STATUS_PENDING';
        AnnualLeaveWFResponseCodeOpen: Label '60020_UPDATE_STATUS_OPEN';
        AnnualLeaveWFResponseCodeRelease: Label '60020_UPDATE_STATUS_RELEASED';
        AnnualLeaveWFResponseCodeCreateAppChain: Label '60020_CREATE_APPROVAL_CHAIN';
        AnnualLeaveWFResponseCodeRunAppChain: Label '60020_RUN_APPROVAL_CHAIN';
        AnnualLeaveWFResponseCodeDelegateAppChain: Label '60020_DELEGATE_APPROVAL_CHAIN';
        AnnualLeaveWFResponseCodeRejectAppChain: Label '60020_REJECT_APPROVAL_CHAIN';
        AnnualLeaveWFResponseCodeCancelAppChain: Label '60020_CANCEL_APPROVAL_CHAIN';



        //MEDICAL REIMBURSEMENT
        MedicalReimWFEventCodeSendMedicalReimAppReq: Label '65002_SEND_MEDICALREIM_APP_REQUEST';
        MedicalReimWFEventCodeCancelMedicalReimAppReq: Label '65002_CANCEL_MEDICALREIM_APP_REQUEST';
        MedicalReimWFEventCodeRejectMedicalReimAppReq: Label '65002_REJECT_MEDICALREIM_APP_REQUEST';
        MedicalReimWFEventCodeDelegateMedicalReimAppReq: Label '65002_DELEGATE_MEDICALREIM_APP_REQUEST';
        MedicalReimWFEventCodeApproveMedicalReimAppReq: Label '65002_APPROVE_MEDICALREIM_APP_REQUEST';
        MedicalReimWFEventCodeReleaseMedicalReim: Label '65002_RELEASE_MEDICALREIM';
        MedicalReimWFResponseCodePending: Label '65002_UPDATE_STATUS_PENDING';
        MedicalReimWFResponseCodeOpen: Label '65002_UPDATE_STATUS_OPEN';
        MedicalReimWFResponseCodeRelease: Label '65002_UPDATE_STATUS_RELEASED';
        MedicalReimWFResponseCodeCreateAppChain: Label '65002_CREATE_APPROVAL_CHAIN';
        MedicalReimWFResponseCodeRunAppChain: Label '65002_RUN_APPROVAL_CHAIN';
        MedicalReimWFResponseCodeDelegateAppChain: Label '65002_DELEGATE_APPROVAL_CHAIN';
        MedicalReimWFResponseCodeRejectAppChain: Label '65002_REJECT_APPROVAL_CHAIN';
        MedicalReimWFResponseCodeCancelAppChain: Label '65002_CANCEL_APPROVAL_CHAIN';



        //UNCONDITIONAL LEAVE
        UncondLeaveWFEventCodeSendUncondLeaveAppReq: Label '65007_SEND_UNCONDLEAVE_APP_REQUEST';
        UncondLeaveWFEventCodeCancelUncondLeaveAppReq: Label '65007_CANCEL_UNCONDLEAVE_APP_REQUEST';
        UncondLeaveWFEventCodeRejectUncondLeaveAppReq: Label '65007_REJECT_UNCONDLEAVE_APP_REQUEST';
        UncondLeaveWFEventCodeDelegateUncondLeaveAppReq: Label '65007_DELEGATE_UNCONDLEAVE_APP_REQUEST';
        UncondLeaveWFEventCodeApproveUncondLeaveAppReq: Label '65007_APPROVE_UNCONDLEAVE_APP_REQUEST';
        UncondLeaveWFEventCodeReleaseUncondLeave: Label '65007_RELEASE_MEDICALREIM';
        UncondLeaveWFResponseCodePending: Label '65007_UPDATE_STATUS_PENDING';
        UncondLeaveWFResponseCodeOpen: Label '65007_UPDATE_STATUS_OPEN';
        UncondLeaveWFResponseCodeRelease: Label '65007_UPDATE_STATUS_RELEASED';
        UncondLeaveWFResponseCodeCreateAppChain: Label '65007_CREATE_APPROVAL_CHAIN';
        UncondLeaveWFResponseCodeRunAppChain: Label '65007_RUN_APPROVAL_CHAIN';
        UncondLeaveWFResponseCodeDelegateAppChain: Label '65007_DELEGATE_APPROVAL_CHAIN';
        UncondLeaveWFResponseCodeRejectAppChain: Label '65007_REJECT_APPROVAL_CHAIN';
        UncondLeaveWFResponseCodeCancelAppChain: Label '65007_CANCEL_APPROVAL_CHAIN';


        GLSetup: Record "General Ledger Setup";
        GlobalInstance: Codeunit GlobalInstanceDRE;
        NotifSetup: Record "Notification Setup";
        SalesLineBuff: Record "Sales Line" temporary;


    /*
    [EventSubscriber(ObjectType::Table, 50000, 'OnBeforeInsertAdvanceHeader', '', true, true)]
    local procedure CustomPostingDateDanNoDocGeneralPaymentKhususHRIS(
    var AdvanceHeader: Record "Advance Header"; var IsHandled: Boolean)
    begin
        
    end;


    [EventSubscriber(ObjectType::Codeunit, 50001, 'OnAfterApproveAdvance', '', true, true)]
    local procedure GPApprovedSeveranceLeaveDisbursement(var AdvanceHeader: Record "Advance Header")
    begin

    end;
    */


    [EventSubscriber(ObjectType::Table, 50000, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CekJikaHapusAdvanceHader(var Rec: Record "Advance Header")
    begin
        if (Rec."Document Type" = Rec."Document Type"::"General Payment") and
           (Rec."Disbursement Type" <> 0) then
            if not Rec."Delete via HR" then
                Error('This document was created thru HRIS. It can only be deleted by HR admin.');
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CekJikaHapusGenJnlLine(var Rec: Record "Gen. Journal Line")
    begin
        if (Rec.TipeDuit <> 0) then
            if not Rec."Delete via HR" then
                Error('This line was created thru HRIS. It can only be deleted by HR admin.');
    end;


    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterDeleteEvent', '', true, true)]
    local procedure ErrorKaloHapusMSI(var Rec: Record Employee)
    begin
        if Rec."User ID" = 'MSI' then
            Error('This employee is for testing purpose. Please do not delete.');
    end;

    //Cek saat open, jika USERID yg online tidak sama dengan USERID di employee card,
    //maka error.
    //Pengecualian untuk Pak Erwin dan MSI.
    //Yang ini untuk ONOPEN
    [EventSubscriber(ObjectType::Page, 5200, 'OnOpenPageEvent', '', true, true)]
    local procedure CegahUserLihatCardEmployeeLain(var Rec: Record Employee)
    begin
        //sementara di hardcoded dulu untuk 2 user di bawah ini
        // MANSUR_HASAN, KUSUMA_WARDANI, LUKI_KURNIAWAN
        // MSI

        Rec.CalcFields("User ID");
        if (UserId <> 'MANSUR_HASAN') and (UserId <> 'MSI') and (UserId <> 'LUKI_KURNIAWAN')
            and (UserId <> 'KUSUMA_WARDANI') then
            if Rec."User ID" <> UserId then
                Error('You can only access your own employee card.');

    end;


    //Cek saat open, jika USERID yg online tidak sama dengan USERID di employee card,
    //maka error.
    //Pengecualian untuk Pak Erwin dan MSI.
    //Yang ini untuk ONAFTERGETRECORD
    [EventSubscriber(ObjectType::Page, 5200, 'OnAfterGetRecordEvent', '', true, true)]
    local procedure CegahUserLihatCardEmployeeLain2(var Rec: Record Employee)
    begin
        //sementara di hardcoded dulu untuk 2 user di bawah ini
        // MANSUR_HASAN, KUSUMA_WARDANI, LUKI_KURNIAWAN
        // MSI

        Rec.CalcFields("User ID");
        if (UserId <> 'MANSUR_HASAN') and (UserId <> 'MSI') and (UserId <> 'LUKI_KURNIAWAN')
        and (UserId <> 'KUSUMA_WARDANI') then
            if Rec."User ID" <> UserId then
                Error('You can only access your own employee card.');

    end;


    //saat create employee card baru, itu berarti karyawan baru
    //dan field NEWLY HIRED harus di flag
    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterInsertEvent', '', true, true)]
    local procedure OnInsertNewEmployee(var Rec: Record Employee)
    begin
        Rec."Newly Hired" := true;
    end;


    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingSendUncondLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeSendUncondLeaveAppReq,
        Database::"Unconditional Leave Request", 'Approval of UNCONDITIONAL LEAVE document is requested', 0, true);
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingSendCTOReqApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeSendCTOReqAppReq,
        Database::"CTO Request Header", 'Approval of CTO Request document is requested', 0, true);
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingSendCTORealApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeSendCTORealAppReq,
        Database::"CTO Realization Header", 'Approval of CTO Realization document is requested', 0, true);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingSendAnnualLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeSendAnnualLeaveAppReq,
        Database::"Leave Request", 'Approval of Annual Leave document is requested', 0, true);
    end;


    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingSendMedicalReimApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeSendMedicalReimAppReq,
        Database::"Medical Reimbursement Header", 'Approval of Medical Reimbursement document is requested', 0, true);
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingCancelUncondLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeCancelUncondLeaveAppReq,
        Database::"Unconditional Leave Request", 'Approval of UNCONDITIONAL LEAVE document is canceled', 0, false);
    end;



    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingCancelCTOReqApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeCancelCTOReqAppReq,
        Database::"CTO Request Header", 'Approval of CTO Request document is canceled', 0, false);
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingCancelCTORealApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeCancelCTORealAppReq,
        Database::"CTO Realization Header", 'Approval of CTO Realization document is canceled', 0, false);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingCancelAnnualLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeCancelAnnualLeaveAppReq,
        Database::"Leave Request", 'Approval of Annual Leave document is canceled', 0, false);
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingCancelMedicalReimApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeCancelMedicalReimAppReq,
        Database::"Medical Reimbursement Header", 'Approval of Medical Reimbursement document is canceled', 0, false);
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingApproveUncondLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeApproveUncondLeaveAppReq,
        Database::"Unconditional Leave Request", 'Approval of UNCONDITIONAL LEAVE document is approved', 0, false);
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingApproveCTOReqApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeApproveCTOReqAppReq,
        Database::"CTO Request Header", 'Approval of CTO Request document is approved', 0, false);
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingApproveCTORealApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeApproveCTORealAppReq,
        Database::"CTO Realization Header", 'Approval of CTO Realization document is approved', 0, false);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingApproveAnnualLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeApproveAnnualLeaveAppReq,
        Database::"Leave Request", 'Approval of Annual Leave document is approved', 0, false);
    end;


    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingApproveMedicalReimApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeApproveMedicalReimAppReq,
        Database::"Medical Reimbursement Header", 'Approval of Medical Reimbursement document is approved', 0, false);
    end;


    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingRejectUncondLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeRejectUncondLeaveAppReq,
        Database::"Unconditional Leave Request", 'Approval of UNCONDITIONAL LEAVE document is rejected', 0, false);
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingRejectCTOReqApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeRejectCTOReqAppReq,
        Database::"CTO Request Header", 'Approval of CTO Request document is rejected', 0, false);
    end;



    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingRejectCTORealApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeRejectCTORealAppReq,
        Database::"CTO Realization Header", 'Approval of CTO Realization document is rejected', 0, false);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingRejectAnnualLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeRejectAnnualLeaveAppReq,
        Database::"Leave Request", 'Approval of Annual Leave document is rejected', 0, false);
    end;


    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingRejectMedicalReimApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeRejectMedicalReimAppReq,
        Database::"Medical Reimbursement Header", 'Approval of Medical Reimbursement document is rejected', 0, false);
    end;


    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingDelegateUncondLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeDelegateUncondLeaveAppReq,
        Database::"Unconditional Leave Request", 'Approval of UNCONDITIONAL LEAVE document is delegated', 0, false);
    end;

    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingDelegateCTOReqApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeDelegateCTOReqAppReq,
        Database::"CTO Request Header", 'Approval of CTO Request document is delegated', 0, false);
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingDelegateCTORealApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeDelegateCTORealAppReq,
        Database::"CTO Realization Header", 'Approval of CTO Realization document is delegated', 0, false);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingDelegateAnnualLeaveApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeDelegateAnnualLeaveAppReq,
        Database::"Leave Request", 'Approval of Annual Leave document is delegated', 0, false);
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingDelegateMedicalReimApprovalRequest()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeDelegateMedicalReimAppReq,
        Database::"Medical Reimbursement Header", 'Approval of Medical Reimbursement document is delegated', 0, false);
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingReleaseUncondLeave()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(UncondLeaveWFEventCodeReleaseUncondLeave,
        Database::"Unconditional Leave Request", 'An UNCONDITIONAL LEAVE document is released', 0, false);
    end;



    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingReleaseCTOReq()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTOReqWFEventCodeReleaseCTOReq,
        Database::"CTO Request Header", 'A CTO Request document is released', 0, false);
    end;

    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingReleaseCTOReal()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(CTORealWFEventCodeReleaseCTOReal,
        Database::"CTO Realization Header", 'A CTO Realization document is released', 0, false);
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingReleaseAnnualLeave()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(AnnualLeaveWFEventCodeReleaseAnnualLeave,
        Database::"Leave Request", 'An Annual Leave document is released', 0, false);
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure CUWorkFlowEventHandlingReleaseMedicalReim()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MedicalReimWFEventCodeReleaseMedicalReim,
        Database::"Medical Reimbursement Header", 'A Medical Reimbursement document is released', 0, false);
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddUncondLeaveUpdateStatusPending()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodePending,
        Database::"Unconditional Leave Request", 'Update status UNCONDITIONAL LEAVE document to Pending Approval', 'GROUP 65007');
    end;



    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTOReqUpdateStatusPending()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodePending,
        Database::"CTO Request Header", 'Update status CTO Request document to Pending Approval', 'GROUP 60037');
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTORealUpdateStatusPending()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodePending,
        Database::"CTO Realization Header", 'Update status CTO Realization document to Pending Approval', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddAnnualLeaveUpdateStatusPending()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodePending,
        Database::"Leave Request", 'Update status Annual Leave document to Pending Approval', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddMedicalReimUpdateStatusPending()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodePending,
        Database::"Medical Reimbursement Header", 'Update status Medical Reimbursement document to Pending Approval', 'GROUP 65002');
    end;


    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddUncondLeaveUpdateStatusOpen()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeOpen,
        Database::"Unconditional Leave Request", 'Update status UNCONDITIONAL LEAVE document to Open', 'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTOReqUpdateStatusOpen()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeOpen,
        Database::"CTO Request Header", 'Update status CTO Request document to Open', 'GROUP 60037');
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTORealUpdateStatusOpen()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeOpen,
        Database::"CTO Realization Header", 'Update status CTO Realization document to Open', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddAnnualLeaveUpdateStatusOpen()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeOpen,
        Database::"Leave Request", 'Update status Annual Leave document to Open', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddMedicalReimUpdateStatusOpen()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeOpen,
        Database::"Medical Reimbursement Header", 'Update status Medical Reimbursement document to Open', 'GROUP 65002');
    end;




    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddUncondLeaveUpdateStatusRelease()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeRelease,
        Database::"Unconditional Leave Request", 'Update status UNCONDITIONAL LEAVE document to Released', 'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTOReqUpdateStatusRelease()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeRelease,
        Database::"CTO Request Header", 'Update status CTO Request document to Released', 'GROUP 60037');
    end;

    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTORealUpdateStatusRelease()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeRelease,
        Database::"CTO Realization Header", 'Update status CTO Realization document to Released', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddAnnualLeaveUpdateStatusRelease()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeRelease,
        Database::"Leave Request", 'Update status Annual Leave document to Released', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddMedicalReimUpdateStatusRelease()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeRelease,
        Database::"Medical Reimbursement Header", 'Update status Medical Reimbursement document to Released', 'GROUP 65002');
    end;




    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddUncondLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeCreateAppChain,
        Database::"Unconditional Leave Request", 'Create approval chain for UNCONDITIONAL LEAVE document', 'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTOReqApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeCreateAppChain,
        Database::"CTO Request Header", 'Create approval chain for CTO Request document', 'GROUP 60037');
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddCTORealApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeCreateAppChain,
        Database::"CTO Realization Header", 'Create approval chain for CTO Realization document', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddAnnualLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeCreateAppChain,
        Database::"Leave Request", 'Create approval chain for Annual Leave document', 'GROUP 60020');
    end;


    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_AddMedicalReimApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeCreateAppChain,
        Database::"Medical Reimbursement Header", 'Create approval chain for Medical Reimbursement document', 'GROUP 65002');
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RunUncondLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeRunAppChain,
        Database::"Unconditional Leave Request", 'Run approval chain for UNCONDITIONAL LEAVE document', 'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RunCTOReqApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeRunAppChain,
        Database::"CTO Request Header", 'Run approval chain for CTO Request document', 'GROUP 60037');
    end;

    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RunCTORealApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeRunAppChain,
        Database::"CTO Realization Header", 'Run approval chain for CTO Realization document', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RunAnnualLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeRunAppChain,
        Database::"Leave Request", 'Run approval chain for Annual Leave document', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RunMedicalReimApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeRunAppChain,
        Database::"Medical Reimbursement Header", 'Run approval chain for Medical Reimbursement document', 'GROUP 65002');
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_DelegateUncondLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeDelegateAppChain,
        Database::"Unconditional Leave Request", 'Delegate approval request for UNCONDITIONAL LEAVE document', 'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_DelegateCTOReqApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeDelegateAppChain,
        Database::"CTO Request Header", 'Delegate approval request for CTO Request document', 'GROUP 60037');
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_DelegateCTORealApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeDelegateAppChain,
        Database::"CTO Realization Header", 'Delegate approval request for CTO Realization document', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_DelegateAnnualLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeDelegateAppChain,
        Database::"Leave Request", 'Delegate approval request for Annual Leave document', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_DelegateMedicalReimApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeDelegateAppChain,
        Database::"Medical Reimbursement Header", 'Delegate approval request for Medical Reimbursement document', 'GROUP 65002');
    end;



    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RejectUncondLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(UncondLeaveWFResponseCodeRejectAppChain,
        Database::"Unconditional Leave Request", 'Reject approval request for UNCONDITIONAL LEAVE document',
        'GROUP 65007');
    end;


    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RejectCTOReqApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTOReqWFResponseCodeRejectAppChain,
        Database::"CTO Request Header", 'Reject approval request for CTO Request document', 'GROUP 60037');
    end;


    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RejectCTORealApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CTORealWFResponseCodeRejectAppChain,
        Database::"CTO Realization Header", 'Reject approval request for CTO Realization document', 'GROUP 60039');
    end;


    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RejectAnnualLeaveApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(AnnualLeaveWFResponseCodeRejectAppChain,
        Database::"Leave Request", 'Reject approval request for Annual Leave document', 'GROUP 60020');
    end;



    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure CUWorkFlowResponseHandling_RejectMedicalReimApprovalChain()
    var
        WorkflowResponseHandling: codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MedicalReimWFResponseCodeRejectAppChain,
        Database::"Medical Reimbursement Header", 'Reject approval request for Medical Reimbursement document', 'GROUP 65002');
    end;




    //UNCONDITIONAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure CUWorkFlowResponseHandling_ExecUncondLeaveWorkflowResponses(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        _WorkflowResponse: Record "Workflow Response";
        _AppCustMgt: Codeunit "Approval DRE2";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _AppEntry3: Record "Approval Entry";
        _AppEntryBuffer: Record "Approval Entry" temporary;
        _PostedAppEntry: Record "Posted Approval Entry";
        _WorkflowMgt: Codeunit "Workflow Management";
        _EntryNo: Integer;


        //APPROVAL EMAIL
        //_AppEmailNotif: Codeunit "Approval Email Notification";

        _AppCommentLine: Record "Approval Comment Line";
    begin
        IF _WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE _WorkflowResponse."Function Name" OF
                UncondLeaveWFResponseCodePending:
                    BEGIN
                        //pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenUnconditionalLeave(Variant, 2);
                        _AppCommentLine.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppCommentLine.DeleteAll();
                        ResponseExecuted := TRUE;
                    END;
                UncondLeaveWFResponseCodeOpen:
                    begin
                        _AppCustMgt.ReleaseReopenUnconditionalLeave(Variant, 0);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;
                UncondLeaveWFResponseCodeRelease:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenUnconditionalLeave(Variant, 1);
                        //Sementara, fungsi di CTO Req hanya me-release document aja. 
                        //Blom ada fungsi lain, makanya matikan dulu
                        //_AppCustMgt.ApproveAdvance(Variant);
                        ResponseExecuted := TRUE;
                    end;
                UncondLeaveWFResponseCodeCreateAppChain:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        GlobalInstance.SetActive(true);
                        _AppCustMgt.CreateApprovalUnconditionalLeaveGroup(Variant, ResponseWorkflowStepInstance, GlobalInstance.GetNewFirstEntryNoDeletedRec);
                        ResponseExecuted := TRUE;
                    end;
                UncondLeaveWFResponseCodeRunAppChain:
                    begin
                        //nanti pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);


                        GlobalInstance.SetActive(true);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Validate(Status, _AppEntry.Status::Approved);
                            _AppEntry.Modify(true);
                            _AppEntry.SetRange(Status, _AppEntry.Status::Created);
                            if _AppEntry.FindFirst() then begin
                                _AppEntry.Validate(Status, _AppEntry.Status::Open);
                                _AppEntry.Modify(true);
                                _AppEntry.Reset();
                                _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                _AppEntry.FindFirst;
                                GlobalInstance.SetFirstEntryNoDeletedRec(_AppEntry."Entry No.");
                                repeat
                                    _AppEntryBuffer.Init();
                                    _AppEntryBuffer.TransferFields(_AppEntry);
                                    _AppEntryBuffer.Insert();
                                until _AppEntry.Next = 0;
                                //_AppEntry.DeleteAll();
                                _AppEntry.ModifyAll(Status, _AppEntry.Status::Canceled);
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(true);
                                if _WorkflowMgt.CanExecuteWorkflow(Variant, GetUncondLeaveWFEventCodeSendUncondLeaveAppReq) then begin
                                    _WorkflowMgt.HandleEvent(GetUncondLeaveWFEventCodeSendUncondLeaveAppReq, Variant);
                                    _AppEntryBuffer.FindFirst;
                                    repeat
                                        _AppEntry2.Get(_AppEntryBuffer."Entry No.");
                                        _AppEntry2.Validate("Sender ID", _AppEntryBuffer."Sender ID");
                                        _AppEntry2.Validate("Approver ID", _AppEntryBuffer."Approver ID");
                                        _AppEntry2.Validate("Date-Time Sent for Approval", _AppEntryBuffer."Date-Time Sent for Approval");
                                        _AppEntry2.Validate("Last Date-Time Modified", _AppEntryBuffer."Last Date-Time Modified");
                                        _AppEntry2.Validate("Last Modified By User ID", _AppEntryBuffer."Last Modified By User ID");
                                        _AppEntry2.Validate(Status, _AppEntryBuffer.Status);
                                        _AppEntry2.Modify(true);
                                    until _AppEntryBuffer.Next = 0;
                                end else
                                    Error('Cannot re-run the Unconditional Leave event');
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(false);
                            end else begin
                                _PostedAppEntry.LockTable();
                                _PostedAppEntry.Reset();
                                if _PostedAppEntry.FindLast() then
                                    _EntryNo := _PostedAppEntry."Entry No."
                                else
                                    _EntryNo := 0;
                                _AppEntry3.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                if _AppEntry3.FindFirst() then
                                    repeat
                                        _EntryNo += 1;
                                        _PostedAppEntry.Init();
                                        _PostedAppEntry.TransferFields(_AppEntry3);
                                        _PostedAppEntry."Entry No." := _EntryNo;
                                        _PostedAppEntry.Insert();
                                    until _AppEntry3.Next() = 0;


                                //Pake checkline sendiri nanti
                                //_AppCustMgt.CheckLine(Variant);


                                _AppCustMgt.ReleaseReopenUnconditionalLeave(Variant, 1);
                                _AppCustMgt.ApproveUnconditionalLeave(Variant);
                                _AppEntry3.DeleteAll();
                            end;
                        end else begin
                            //Pake checkline sendiri nanti
                            //_AppCustMgt.CheckLine(Variant);

                            _AppCustMgt.ReleaseReopenUnconditionalLeave(Variant, 1);
                            _AppCustMgt.ApproveUnconditionalLeave(Variant);
                        end;
                        ResponseExecuted := true;
                    end;
                UncondLeaveWFResponseCodeDelegateAppChain:
                    ResponseExecuted := true;
                UncondLeaveWFResponseCodeRejectAppChain:
                    begin
                        _AppCustMgt.RejectCTOReq(Variant);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Status := _AppEntry.Status::Rejected;
                            _AppEntry.Modify();
                        end;
                        _AppEntry.Reset();
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;

                UncondLeaveWFResponseCodeCancelAppChain:
                    ResponseExecuted := true;

            END;
    end;




    //CTOREQ
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure CUWorkFlowResponseHandling_ExecCTOReqWorkflowResponses(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        _WorkflowResponse: Record "Workflow Response";
        _AppCustMgt: Codeunit "Approval DRE2";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _AppEntry3: Record "Approval Entry";
        _AppEntryBuffer: Record "Approval Entry" temporary;
        _PostedAppEntry: Record "Posted Approval Entry";
        _WorkflowMgt: Codeunit "Workflow Management";
        _EntryNo: Integer;


        //APPROVAL EMAIL
        //_AppEmailNotif: Codeunit "Approval Email Notification";

        _AppCommentLine: Record "Approval Comment Line";
    begin
        IF _WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE _WorkflowResponse."Function Name" OF
                CTOReqWFResponseCodePending:
                    BEGIN
                        //pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenCTOReq(Variant, 2);
                        _AppCommentLine.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppCommentLine.DeleteAll();
                        ResponseExecuted := TRUE;
                    END;
                CTOReqWFResponseCodeOpen:
                    begin
                        _AppCustMgt.ReleaseReopenCTOReq(Variant, 0);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;
                CTOReqWFResponseCodeRelease:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenCTOReq(Variant, 1);
                        //Sementara, fungsi di CTO Req hanya me-release document aja. 
                        //Blom ada fungsi lain, makanya matikan dulu
                        //_AppCustMgt.ApproveAdvance(Variant);
                        ResponseExecuted := TRUE;
                    end;
                CTOReqWFResponseCodeCreateAppChain:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        GlobalInstance.SetActive(true);
                        _AppCustMgt.CreateApprovalCTOReqGroup(Variant, ResponseWorkflowStepInstance, GlobalInstance.GetNewFirstEntryNoDeletedRec);
                        ResponseExecuted := TRUE;
                    end;
                CTOReqWFResponseCodeRunAppChain:
                    begin
                        //nanti pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);


                        GlobalInstance.SetActive(true);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Validate(Status, _AppEntry.Status::Approved);
                            _AppEntry.Modify(true);
                            _AppEntry.SetRange(Status, _AppEntry.Status::Created);
                            if _AppEntry.FindFirst() then begin
                                _AppEntry.Validate(Status, _AppEntry.Status::Open);
                                _AppEntry.Modify(true);
                                _AppEntry.Reset();
                                _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                _AppEntry.FindFirst;
                                GlobalInstance.SetFirstEntryNoDeletedRec(_AppEntry."Entry No.");
                                repeat
                                    _AppEntryBuffer.Init();
                                    _AppEntryBuffer.TransferFields(_AppEntry);
                                    _AppEntryBuffer.Insert();
                                until _AppEntry.Next = 0;
                                //_AppEntry.DeleteAll();
                                _AppEntry.ModifyAll(Status, _AppEntry.Status::Canceled);
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(true);
                                if _WorkflowMgt.CanExecuteWorkflow(Variant, GetCTOReqWFEventCodeSendCTOReqAppReq) then begin
                                    _WorkflowMgt.HandleEvent(GetCTOReqWFEventCodeSendCTOReqAppReq, Variant);
                                    _AppEntryBuffer.FindFirst;
                                    repeat
                                        _AppEntry2.Get(_AppEntryBuffer."Entry No.");
                                        _AppEntry2.Validate("Sender ID", _AppEntryBuffer."Sender ID");
                                        _AppEntry2.Validate("Approver ID", _AppEntryBuffer."Approver ID");
                                        _AppEntry2.Validate("Date-Time Sent for Approval", _AppEntryBuffer."Date-Time Sent for Approval");
                                        _AppEntry2.Validate("Last Date-Time Modified", _AppEntryBuffer."Last Date-Time Modified");
                                        _AppEntry2.Validate("Last Modified By User ID", _AppEntryBuffer."Last Modified By User ID");
                                        _AppEntry2.Validate(Status, _AppEntryBuffer.Status);
                                        _AppEntry2.Modify(true);
                                    until _AppEntryBuffer.Next = 0;
                                end else
                                    Error('Cannot re-run the CTO Request event');
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(false);
                            end else begin
                                _PostedAppEntry.LockTable();
                                _PostedAppEntry.Reset();
                                if _PostedAppEntry.FindLast() then
                                    _EntryNo := _PostedAppEntry."Entry No."
                                else
                                    _EntryNo := 0;
                                _AppEntry3.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                if _AppEntry3.FindFirst() then
                                    repeat
                                        _EntryNo += 1;
                                        _PostedAppEntry.Init();
                                        _PostedAppEntry.TransferFields(_AppEntry3);
                                        _PostedAppEntry."Entry No." := _EntryNo;
                                        _PostedAppEntry.Insert();
                                    until _AppEntry3.Next() = 0;


                                //Pake checkline sendiri nanti
                                //_AppCustMgt.CheckLine(Variant);


                                _AppCustMgt.ReleaseReopenCTOReq(Variant, 1);
                                _AppCustMgt.ApproveCTOReq(Variant);
                                _AppEntry3.DeleteAll();
                            end;
                        end else begin
                            //Pake checkline sendiri nanti
                            //_AppCustMgt.CheckLine(Variant);

                            _AppCustMgt.ReleaseReopenCTOReq(Variant, 1);
                            _AppCustMgt.ApproveCTOReq(Variant);
                        end;
                        ResponseExecuted := true;
                    end;
                CTOReqWFResponseCodeDelegateAppChain:
                    ResponseExecuted := true;
                CTOReqWFResponseCodeRejectAppChain:
                    begin
                        _AppCustMgt.RejectCTOReq(Variant);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Status := _AppEntry.Status::Rejected;
                            _AppEntry.Modify();
                        end;
                        _AppEntry.Reset();
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;

                CTOReqWFResponseCodeCancelAppChain:
                    ResponseExecuted := true;

            END;
    end;




    //CTOREAL
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure CUWorkFlowResponseHandling_ExecCTORealWorkflowResponses(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        _WorkflowResponse: Record "Workflow Response";
        _AppCustMgt: Codeunit "Approval DRE2";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _AppEntry3: Record "Approval Entry";
        _AppEntryBuffer: Record "Approval Entry" temporary;
        _PostedAppEntry: Record "Posted Approval Entry";
        _WorkflowMgt: Codeunit "Workflow Management";
        _EntryNo: Integer;

        //APPROVAL EMAIL
        //_AppEmailNotif: Codeunit "Approval Email Notification";

        _AppCommentLine: Record "Approval Comment Line";
    begin
        IF _WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE _WorkflowResponse."Function Name" OF
                CTORealWFResponseCodePending:
                    BEGIN
                        //pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenCTOReal(Variant, 2);
                        _AppCommentLine.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppCommentLine.DeleteAll();
                        ResponseExecuted := TRUE;
                    END;
                CTORealWFResponseCodeOpen:
                    begin
                        _AppCustMgt.ReleaseReopenCTOReal(Variant, 0);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;
                CTORealWFResponseCodeRelease:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenCTOReal(Variant, 1);

                        //Sementara, fungsi di CTO Req hanya me-release document aja. 
                        //Blom ada fungsi lain, makanya matikan dulu
                        //_AppCustMgt.ApproveAdvance(Variant);
                        ResponseExecuted := TRUE;
                    end;
                CTORealWFResponseCodeCreateAppChain:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        GlobalInstance.SetActive(true);
                        _AppCustMgt.CreateApprovalCTORealGroup(Variant, ResponseWorkflowStepInstance, GlobalInstance.GetNewFirstEntryNoDeletedRec);
                        ResponseExecuted := TRUE;
                    end;
                CTORealWFResponseCodeRunAppChain:
                    begin
                        //nanti pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);


                        GlobalInstance.SetActive(true);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Validate(Status, _AppEntry.Status::Approved);
                            _AppEntry.Modify(true);
                            _AppEntry.SetRange(Status, _AppEntry.Status::Created);
                            if _AppEntry.FindFirst() then begin
                                _AppEntry.Validate(Status, _AppEntry.Status::Open);
                                _AppEntry.Modify(true);
                                _AppEntry.Reset();
                                _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                _AppEntry.FindFirst;
                                GlobalInstance.SetFirstEntryNoDeletedRec(_AppEntry."Entry No.");
                                repeat
                                    _AppEntryBuffer.Init();
                                    _AppEntryBuffer.TransferFields(_AppEntry);
                                    _AppEntryBuffer.Insert();
                                until _AppEntry.Next = 0;
                                //_AppEntry.DeleteAll();
                                _AppEntry.ModifyAll(Status, _AppEntry.Status::Canceled);
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(true);
                                if _WorkflowMgt.CanExecuteWorkflow(Variant, GetCTORealWFEventCodeSendCTORealAppReq) then begin
                                    _WorkflowMgt.HandleEvent(GetCTORealWFEventCodeSendCTORealAppReq, Variant);
                                    _AppEntryBuffer.FindFirst;
                                    repeat
                                        _AppEntry2.Get(_AppEntryBuffer."Entry No.");
                                        _AppEntry2.Validate("Sender ID", _AppEntryBuffer."Sender ID");
                                        _AppEntry2.Validate("Approver ID", _AppEntryBuffer."Approver ID");
                                        _AppEntry2.Validate("Date-Time Sent for Approval", _AppEntryBuffer."Date-Time Sent for Approval");
                                        _AppEntry2.Validate("Last Date-Time Modified", _AppEntryBuffer."Last Date-Time Modified");
                                        _AppEntry2.Validate("Last Modified By User ID", _AppEntryBuffer."Last Modified By User ID");
                                        _AppEntry2.Validate(Status, _AppEntryBuffer.Status);
                                        _AppEntry2.Modify(true);
                                    until _AppEntryBuffer.Next = 0;
                                end else
                                    Error('Cannot re-run the CTO Request event');
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(false);
                            end else begin
                                _PostedAppEntry.LockTable();
                                _PostedAppEntry.Reset();
                                if _PostedAppEntry.FindLast() then
                                    _EntryNo := _PostedAppEntry."Entry No."
                                else
                                    _EntryNo := 0;
                                _AppEntry3.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                if _AppEntry3.FindFirst() then
                                    repeat
                                        _EntryNo += 1;
                                        _PostedAppEntry.Init();
                                        _PostedAppEntry.TransferFields(_AppEntry3);
                                        _PostedAppEntry."Entry No." := _EntryNo;
                                        _PostedAppEntry.Insert();
                                    until _AppEntry3.Next() = 0;


                                //Pake checkline sendiri nanti
                                //_AppCustMgt.CheckLine(Variant);


                                _AppCustMgt.ReleaseReopenCTOReal(Variant, 1);
                                _AppCustMgt.ApproveCTOReal(Variant);
                                _AppEntry3.DeleteAll();
                            end;
                        end else begin
                            //Pake checkline sendiri nanti
                            //_AppCustMgt.CheckLine(Variant);

                            _AppCustMgt.ReleaseReopenCTOReal(Variant, 1);
                            _AppCustMgt.ApproveCTOReal(Variant);
                        end;
                        ResponseExecuted := true;
                    end;
                CTORealWFResponseCodeDelegateAppChain:
                    ResponseExecuted := true;
                CTORealWFResponseCodeRejectAppChain:
                    begin
                        _AppCustMgt.RejectCTOReal(Variant);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Status := _AppEntry.Status::Rejected;
                            _AppEntry.Modify();
                        end;
                        _AppEntry.Reset();
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;

                CTORealWFResponseCodeCancelAppChain:
                    ResponseExecuted := true;

            END;
    end;



    //ANNUAL LEAVE
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure CUWorkFlowResponseHandling_ExecAnnualLeaveWorkflowResponses(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        _WorkflowResponse: Record "Workflow Response";
        _AppCustMgt: Codeunit "Approval DRE2";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _AppEntry3: Record "Approval Entry";
        _AppEntryBuffer: Record "Approval Entry" temporary;
        _PostedAppEntry: Record "Posted Approval Entry";
        _WorkflowMgt: Codeunit "Workflow Management";
        _EntryNo: Integer;

        //APPROVAL EMAIL
        //_AppEmailNotif: Codeunit "Approval Email Notification";

        _AppCommentLine: Record "Approval Comment Line";
    begin
        IF _WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE _WorkflowResponse."Function Name" OF
                AnnualLeaveWFResponseCodePending:
                    BEGIN
                        //pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenAnnualLeave(Variant, 2);
                        _AppCommentLine.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppCommentLine.DeleteAll();
                        ResponseExecuted := TRUE;
                    END;
                AnnualLeaveWFResponseCodeOpen:
                    begin
                        _AppCustMgt.ReleaseReopenAnnualLeave(Variant, 0);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;
                AnnualLeaveWFResponseCodeRelease:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenAnnualLeave(Variant, 1);

                        //Sementara, fungsi di CTO Req hanya me-release document aja. 
                        //Blom ada fungsi lain, makanya matikan dulu
                        //_AppCustMgt.ApproveAdvance(Variant);
                        ResponseExecuted := TRUE;
                    end;
                AnnualLeaveWFResponseCodeCreateAppChain:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        GlobalInstance.SetActive(true);
                        _AppCustMgt.CreateApprovalAnnualLeaveGroup(Variant, ResponseWorkflowStepInstance, GlobalInstance.GetNewFirstEntryNoDeletedRec);
                        ResponseExecuted := TRUE;
                    end;
                AnnualLeaveWFResponseCodeRunAppChain:
                    begin
                        //nanti pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);


                        GlobalInstance.SetActive(true);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Validate(Status, _AppEntry.Status::Approved);
                            _AppEntry.Modify(true);
                            _AppEntry.SetRange(Status, _AppEntry.Status::Created);
                            if _AppEntry.FindFirst() then begin
                                _AppEntry.Validate(Status, _AppEntry.Status::Open);
                                _AppEntry.Modify(true);
                                _AppEntry.Reset();
                                _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                _AppEntry.FindFirst;
                                GlobalInstance.SetFirstEntryNoDeletedRec(_AppEntry."Entry No.");
                                repeat
                                    _AppEntryBuffer.Init();
                                    _AppEntryBuffer.TransferFields(_AppEntry);
                                    _AppEntryBuffer.Insert();
                                until _AppEntry.Next = 0;
                                //_AppEntry.DeleteAll();
                                _AppEntry.ModifyAll(Status, _AppEntry.Status::Canceled);
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(true);
                                if _WorkflowMgt.CanExecuteWorkflow(Variant, GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq) then begin
                                    _WorkflowMgt.HandleEvent(GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq, Variant);
                                    _AppEntryBuffer.FindFirst;
                                    repeat
                                        _AppEntry2.Get(_AppEntryBuffer."Entry No.");
                                        _AppEntry2.Validate("Sender ID", _AppEntryBuffer."Sender ID");
                                        _AppEntry2.Validate("Approver ID", _AppEntryBuffer."Approver ID");
                                        _AppEntry2.Validate("Date-Time Sent for Approval", _AppEntryBuffer."Date-Time Sent for Approval");
                                        _AppEntry2.Validate("Last Date-Time Modified", _AppEntryBuffer."Last Date-Time Modified");
                                        _AppEntry2.Validate("Last Modified By User ID", _AppEntryBuffer."Last Modified By User ID");
                                        _AppEntry2.Validate(Status, _AppEntryBuffer.Status);
                                        _AppEntry2.Modify(true);
                                    until _AppEntryBuffer.Next = 0;
                                end else
                                    Error('Cannot re-run the CTO Request event');
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(false);
                            end else begin
                                _PostedAppEntry.LockTable();
                                _PostedAppEntry.Reset();
                                if _PostedAppEntry.FindLast() then
                                    _EntryNo := _PostedAppEntry."Entry No."
                                else
                                    _EntryNo := 0;
                                _AppEntry3.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                if _AppEntry3.FindFirst() then
                                    repeat
                                        _EntryNo += 1;
                                        _PostedAppEntry.Init();
                                        _PostedAppEntry.TransferFields(_AppEntry3);
                                        _PostedAppEntry."Entry No." := _EntryNo;
                                        _PostedAppEntry.Insert();
                                    until _AppEntry3.Next() = 0;


                                //Pake checkline sendiri nanti
                                //_AppCustMgt.CheckLine(Variant);


                                _AppCustMgt.ReleaseReopenAnnualLeave(Variant, 1);
                                _AppCustMgt.ApproveAnnualLeave(Variant);
                                _AppEntry3.DeleteAll();
                            end;
                        end else begin
                            //Pake checkline sendiri nanti
                            //_AppCustMgt.CheckLine(Variant);

                            _AppCustMgt.ReleaseReopenAnnualLeave(Variant, 1);
                            _AppCustMgt.ApproveAnnualLeave(Variant);
                        end;
                        ResponseExecuted := true;
                    end;
                AnnualLeaveWFResponseCodeDelegateAppChain:
                    ResponseExecuted := true;
                AnnualLeaveWFResponseCodeRejectAppChain:
                    begin
                        _AppCustMgt.RejectAnnualLeave(Variant);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Status := _AppEntry.Status::Rejected;
                            _AppEntry.Modify();
                        end;
                        _AppEntry.Reset();
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;

                AnnualLeaveWFResponseCodeCancelAppChain:
                    ResponseExecuted := true;

            END;
    end;





    //MEDICAL REIMBURSEMENT
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure CUWorkFlowResponseHandling_ExecMedicalReimWorkflowResponses(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        _WorkflowResponse: Record "Workflow Response";
        _AppCustMgt: Codeunit "Approval DRE2";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _AppEntry3: Record "Approval Entry";
        _AppEntryBuffer: Record "Approval Entry" temporary;
        _PostedAppEntry: Record "Posted Approval Entry";
        _WorkflowMgt: Codeunit "Workflow Management";
        _EntryNo: Integer;

        //APPROVAL EMAIL
        //_AppEmailNotif: Codeunit "Approval Email Notification";

        _AppCommentLine: Record "Approval Comment Line";
    begin
        IF _WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            CASE _WorkflowResponse."Function Name" OF
                MedicalReimWFResponseCodePending:
                    BEGIN
                        //pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenMedicalReim(Variant, 2);
                        _AppCommentLine.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppCommentLine.DeleteAll();
                        ResponseExecuted := TRUE;
                    END;
                MedicalReimWFResponseCodeOpen:
                    begin
                        _AppCustMgt.ReleaseReopenMedicalReim(Variant, 0);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;
                MedicalReimWFResponseCodeRelease:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        _AppCustMgt.ReleaseReopenMedicalReim(Variant, 1);

                        //Sementara, fungsi di CTO Req hanya me-release document aja. 
                        //Blom ada fungsi lain, makanya matikan dulu
                        //_AppCustMgt.ApproveAdvance(Variant);
                        ResponseExecuted := TRUE;
                    end;
                MedicalReimWFResponseCodeCreateAppChain:
                    begin
                        //Pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);
                        GlobalInstance.SetActive(true);
                        _AppCustMgt.CreateApprovalMedicalReimGroup(Variant, ResponseWorkflowStepInstance, GlobalInstance.GetNewFirstEntryNoDeletedRec);
                        ResponseExecuted := TRUE;
                    end;
                MedicalReimWFResponseCodeRunAppChain:
                    begin
                        //nanti pake checkline sendiri
                        //_AppCustMgt.CheckLine(Variant);


                        GlobalInstance.SetActive(true);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Validate(Status, _AppEntry.Status::Approved);
                            _AppEntry.Modify(true);
                            _AppEntry.SetRange(Status, _AppEntry.Status::Created);
                            if _AppEntry.FindFirst() then begin
                                _AppEntry.Validate(Status, _AppEntry.Status::Open);
                                _AppEntry.Modify(true);
                                _AppEntry.Reset();
                                _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                _AppEntry.FindFirst;
                                GlobalInstance.SetFirstEntryNoDeletedRec(_AppEntry."Entry No.");
                                repeat
                                    _AppEntryBuffer.Init();
                                    _AppEntryBuffer.TransferFields(_AppEntry);
                                    _AppEntryBuffer.Insert();
                                until _AppEntry.Next = 0;
                                //_AppEntry.DeleteAll();
                                _AppEntry.ModifyAll(Status, _AppEntry.Status::Canceled);
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(true);
                                if _WorkflowMgt.CanExecuteWorkflow(Variant, GetMedicalReimWFEventCodeSendMedicalReimAppReq) then begin
                                    _WorkflowMgt.HandleEvent(GetMedicalReimWFEventCodeSendMedicalReimAppReq, Variant);
                                    _AppEntryBuffer.FindFirst;
                                    repeat
                                        _AppEntry2.Get(_AppEntryBuffer."Entry No.");
                                        _AppEntry2.Validate("Sender ID", _AppEntryBuffer."Sender ID");
                                        _AppEntry2.Validate("Approver ID", _AppEntryBuffer."Approver ID");
                                        _AppEntry2.Validate("Date-Time Sent for Approval", _AppEntryBuffer."Date-Time Sent for Approval");
                                        _AppEntry2.Validate("Last Date-Time Modified", _AppEntryBuffer."Last Date-Time Modified");
                                        _AppEntry2.Validate("Last Modified By User ID", _AppEntryBuffer."Last Modified By User ID");
                                        _AppEntry2.Validate(Status, _AppEntryBuffer.Status);
                                        _AppEntry2.Modify(true);
                                    until _AppEntryBuffer.Next = 0;
                                end else
                                    Error('Cannot re-run the Medical Reimbursement event');
                                GlobalInstance.SetSkipValidateCreateApprovalAdvanceGroup(false);
                            end else begin
                                _PostedAppEntry.LockTable();
                                _PostedAppEntry.Reset();
                                if _PostedAppEntry.FindLast() then
                                    _EntryNo := _PostedAppEntry."Entry No."
                                else
                                    _EntryNo := 0;
                                _AppEntry3.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                                if _AppEntry3.FindFirst() then
                                    repeat
                                        _EntryNo += 1;
                                        _PostedAppEntry.Init();
                                        _PostedAppEntry.TransferFields(_AppEntry3);
                                        _PostedAppEntry."Entry No." := _EntryNo;
                                        _PostedAppEntry.Insert();
                                    until _AppEntry3.Next() = 0;


                                //Pake checkline sendiri nanti
                                //_AppCustMgt.CheckLine(Variant);


                                _AppCustMgt.ReleaseReopenMedicalReim(Variant, 1);
                                _AppCustMgt.ApproveMedicalReim(Variant);
                                _AppEntry3.DeleteAll();
                            end;
                        end else begin
                            //Pake checkline sendiri nanti
                            //_AppCustMgt.CheckLine(Variant);

                            _AppCustMgt.ReleaseReopenMedicalReim(Variant, 1);
                            _AppCustMgt.ApproveMedicalReim(Variant);
                        end;
                        ResponseExecuted := true;
                    end;
                MedicalReimWFResponseCodeDelegateAppChain:
                    ResponseExecuted := true;
                MedicalReimWFResponseCodeRejectAppChain:
                    begin
                        _AppCustMgt.RejectMedicalReim(Variant);
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.SetRange(Status, _AppEntry.Status::Open);
                        if _AppEntry.FindFirst() then begin
                            _AppEntry.Status := _AppEntry.Status::Rejected;
                            _AppEntry.Modify();
                        end;
                        _AppEntry.Reset();
                        _AppEntry.SetRange("Record ID to Approve", ResponseWorkflowStepInstance."Record ID");
                        _AppEntry.DeleteAll();
                        ResponseExecuted := true;
                    end;

                MedicalReimWFResponseCodeCancelAppChain:
                    ResponseExecuted := true;

            END;
    end;


    [EventSubscriber(ObjectType::Table, database::"Approval Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure AppEntryOnAfterInsertEvent(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        _AppEmailNotif: Codeunit "Email Notification DRE";
    begin
        GLSetup.Get();
        if (GLSetup."Enable Approval by Email") and (Rec.Status = Rec.Status::Open) then begin
            //0 berarti email untuk lanjut
            _AppEmailNotif.SendApprovalEmail(Rec, 0);
        end;
    end;



    [EventSubscriber(ObjectType::Table, database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure AppEntryOnAfterModifyEvent(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        _AppEmailNotif: Codeunit "Email Notification DRE";
        _AppovalEntry: Record "Approval Entry";
    begin
        GLSetup.Get();
        if (GLSetup."Enable Approval by Email") and (Rec.Status = Rec.Status::Rejected) then begin
            //1 berarti email untuk rejected
            _AppEmailNotif.SendApprovalEmail(Rec, 1);
        end;


        if (GLSetup."Enable Approval by Email") and (Rec.Status = Rec.Status::Approved) then begin
            _AppovalEntry.SetRange("Table ID", Rec."Table ID");
            _AppovalEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
            if _AppovalEntry.FindLast() then
                if _AppovalEntry.Status = _AppovalEntry.Status::Approved then
                    //2 berarti email untuk approved
                    _AppEmailNotif.SendApprovalEmail(Rec, 2);
        end;
    end;



    //UNCONDITIONAL LEAVE
    procedure GetUncondLeaveWFEventCodeSendUncondLeaveAppReq(): code[50];
    begin
        exit(UncondLeaveWFEventCodeSendUncondLeaveAppReq);
    end;

    procedure GetUncondLeaveWFEventCodeCancelUncondLeaveAppReq(): code[50];
    begin
        exit(UncondLeaveWFEventCodeCancelUncondLeaveAppReq);
    end;

    procedure GetUncondLeaveWFEventCodeApproveUncondLeave(): code[50];
    begin
        exit(UncondLeaveWFEventCodeApproveUncondLeaveAppReq);
    end;

    procedure GetUncondLeaveWFEventCodeRejectUncondLeaveAppReq(): code[50];
    begin
        exit(UncondLeaveWFEventCodeRejectUncondLeaveAppReq);
    end;

    procedure GetUncondLeaveWFEventCodeDelegateUncondLeaveAppReq(): code[50];
    begin
        exit(UncondLeaveWFEventCodeDelegateUncondLeaveAppReq);
    end;

    procedure GetUncondLeaveWFEventCodeReleaseUncondLeave(): code[50];
    begin
        exit(UncondLeaveWFEventCodeReleaseUncondLeave);
    end;



    //CTOREQ
    procedure GetCTOReqWFEventCodeSendCTOReqAppReq(): code[50];
    begin
        exit(CTOReqWFEventCodeSendCTOReqAppReq);
    end;

    procedure GetCTOReqWFEventCodeCancelCTOReqAppReq(): code[50];
    begin
        exit(CTOReqWFEventCodeCancelCTOReqAppReq);
    end;

    procedure GetCTOReqWFEventCodeApproveCTOReq(): code[50];
    begin
        exit(CTOReqWFEventCodeApproveCTOReqAppReq);
    end;

    procedure GetCTOReqWFEventCodeRejectCTOReqAppReq(): code[50];
    begin
        exit(CTOReqWFEventCodeRejectCTOReqAppReq);
    end;

    procedure GetCTOReqWFEventCodeDelegateCTOReqAppReq(): code[50];
    begin
        exit(CTOReqWFEventCodeDelegateCTOReqAppReq);
    end;

    procedure GetCTOReqWFEventCodeReleaseCTOReq(): code[50];
    begin
        exit(CTOReqWFEventCodeReleaseCTOReq);
    end;



    //CTOREAL
    procedure GetCTORealWFEventCodeSendCTORealAppReq(): code[50];
    begin
        exit(CTORealWFEventCodeSendCTORealAppReq);
    end;

    procedure GetCTORealWFEventCodeCancelCTORealAppReq(): code[50];
    begin
        exit(CTORealWFEventCodeCancelCTORealAppReq);
    end;

    procedure GetCTORealWFEventCodeApproveCTOReal(): code[50];
    begin
        exit(CTORealWFEventCodeApproveCTORealAppReq);
    end;

    procedure GetCTORealWFEventCodeRejectCTORealAppReq(): code[50];
    begin
        exit(CTORealWFEventCodeRejectCTORealAppReq);
    end;

    procedure GetCTORealWFEventCodeDelegateCTORealAppReq(): code[50];
    begin
        exit(CTORealWFEventCodeDelegateCTORealAppReq);
    end;

    procedure GetCTORealWFEventCodeReleaseCTOReal(): code[50];
    begin
        exit(CTORealWFEventCodeReleaseCTOReal);
    end;



    //ANNUAL LEAVE
    procedure GetAnnualLeaveWFEventCodeSendAnnualLeaveAppReq(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeSendAnnualLeaveAppReq);
    end;

    procedure GetAnnualLeaveWFEventCodeCancelAnnualLeaveAppReq(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeCancelAnnualLeaveAppReq);
    end;

    procedure GetAnnualLeaveWFEventCodeApproveAnnualLeave(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeApproveAnnualLeaveAppReq);
    end;

    procedure GetAnnualLeaveWFEventCodeRejectAnnualLeaveAppReq(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeRejectAnnualLeaveAppReq);
    end;

    procedure GetAnnualLeaveWFEventCodeDelegateAnnualLeaveAppReq(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeDelegateAnnualLeaveAppReq);
    end;

    procedure GetAnnualLeaveWFEventCodeReleaseAnnualLeave(): code[50];
    begin
        exit(AnnualLeaveWFEventCodeReleaseAnnualLeave);
    end;




    //MEDICAL REIMBURSEMENT
    procedure GetMedicalReimWFEventCodeSendMedicalReimAppReq(): code[50];
    begin
        exit(MedicalReimWFEventCodeSendMedicalReimAppReq);
    end;

    procedure GetMedicalReimWFEventCodeCancelMedicalReimAppReq(): code[50];
    begin
        exit(MedicalReimWFEventCodeCancelMedicalReimAppReq);
    end;

    procedure GetMedicalReimWFEventCodeApproveMedicalReim(): code[50];
    begin
        exit(MedicalReimWFEventCodeApproveMedicalReimAppReq);
    end;

    procedure GetMedicalReimWFEventCodeRejectMedicalReimAppReq(): code[50];
    begin
        exit(MedicalReimWFEventCodeRejectMedicalReimAppReq);
    end;

    procedure GetMedicalReimWFEventCodeDelegateMedicalReimAppReq(): code[50];
    begin
        exit(MedicalReimWFEventCodeDelegateMedicalReimAppReq);
    end;

    procedure GetMedicalReimWFEventCodeReleaseMedicalReim(): code[50];
    begin
        exit(MedicalReimWFEventCodeReleaseMedicalReim);
    end;





    procedure GetNoActiveWFErrorMessage(): Text;
    begin
        exit('There is no active workflow.');
    end;

    procedure UpdateCFEntry()
    var
        _GLEntry: Record "G/L Entry";
        _GLEntry2: Record "G/L Entry";
    begin
        _GLEntry.SETRANGE("Source Type", _GLEntry."Source Type"::"Bank Account");
        _GLEntry.FINDFIRST;
        REPEAT
            _GLEntry2.SETRANGE("Transaction No.", _GLEntry."Transaction No.");
            _GLEntry2.MODIFYALL("Cash Flow Entry", TRUE);
        UNTIL _GLEntry.NEXT = 0;
        MESSAGE('Done');
    end;

    procedure UpdateFCYDetEmpLedgEntry()
    var
        _DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry";
    begin
        if _DtldEmplLedgEntry.FindFirst() then
            repeat
                if _DtldEmplLedgEntry."Currency Code (FCY)" = '' then begin
                    _DtldEmplLedgEntry."Amount (FCY)" := _DtldEmplLedgEntry.Amount;
                    _DtldEmplLedgEntry.Modify();
                end else
                    if _DtldEmplLedgEntry."Amount (FCY)" = 0 then begin
                        _DtldEmplLedgEntry."Amount (FCY)" := _DtldEmplLedgEntry.Amount;
                        _DtldEmplLedgEntry.Modify();
                    end
            until _DtldEmplLedgEntry.Next() = 0;
        MESSAGE('Done');
    end;
}

