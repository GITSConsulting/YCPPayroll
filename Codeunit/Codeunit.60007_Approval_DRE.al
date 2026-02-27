codeunit 60007 "Approval DRE"
{

    [IntegrationEvent(true, false)]
    procedure OnSendCTOREQforApproval(var CTOREQHeader: Record "CTO Request Header")
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnApproveApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnRejectApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnDelegateApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
    end;

    procedure IsCTOREQWorkflowEnabled(var CTOREQHeader: Record "CTO Request Header"): Boolean
    begin
        exit(WorkFlowMgt.CanExecuteWorkflow(CTOREQHeader, RunWorkFlowOnSendCTOREQForApprovalCode()));
    end;

    procedure CheckCTOREQWorkFlowEnabled(var CTOREQ: Record "CTO Request Header"): Boolean
    begin
        if not IsCTOREQWorkflowEnabled(CTOREQ) then
            Error('No workflow enabled for CTO Request');
        exit(true);
    end;


    //KELOMPOK ONSEND  --start
    procedure RunWorkFlowOnSendCTOREQForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnSendCTOREQForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 60007, 'OnSendCTOREQforApproval', '', true, true)]
    procedure RunWorkFlowOnSendCTOREQForApproval(var CTOREQHeader: Record "CTO Request Header")
    begin
        WorkFlowMgt.HandleEvent(RunWorkFlowOnSendCTOREQForApprovalCode(), CTOREQHeader);
    end;
    //KELOMPOK ONSEND  --end




    //KELOMPOK ONAPPROVE  --start
    procedure RunWorkFlowOnApproveApprovalRequestForCTOREQCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnApproveApprovalRequestForCTOREQ'))
    end;

    [EventSubscriber(ObjectType::Codeunit, 60007, 'OnApproveApprovalRequestForCTOREQ', '', true, true)]
    procedure RunWorkFlowOnApproveApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkFlowMgt.HandleEventOnKnownWorkflowInstance(RunWorkFlowOnApproveApprovalRequestForCTOREQCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //KELOMPOK ONAPPROVE  --end




    //KELOMPOK ONREJECT  --start
    procedure RunWorkFlowOnRejectApprovalRequestForCTOREQCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnRejectApprovalRequestForCTOREQ'))
    end;

    [EventSubscriber(ObjectType::Codeunit, 60007, 'OnRejectApprovalRequestForCTOREQ', '', true, true)]
    procedure RunWorkFlowOnRejectApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkFlowMgt.HandleEventOnKnownWorkflowInstance(RunWorkFlowOnRejectApprovalRequestForCTOREQCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //KELOMPOK ONREJECT  --end




    //KELOMPOK ONDELEGATE  --start
    procedure RunWorkFlowOnDelegateApprovalRequestForCTOREQCode(): Code[128]
    begin
        exit(UpperCase('RunWorkFlowOnDelegateApprovalRequestForCTOREQ'))
    end;

    [EventSubscriber(ObjectType::Codeunit, 60007, 'OnDelegateApprovalRequestForCTOREQ', '', true, true)]
    procedure RunWorkFlowOnDelegateApprovalRequestForCTOREQ(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkFlowMgt.HandleEventOnKnownWorkflowInstance(RunWorkFlowOnDelegateApprovalRequestForCTOREQCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //KELOMPOK ONDELEGATE  --end



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure CreateEventsLibraryForCTOREQ()
    begin
        //Send Approval Request
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnSendCTOREQForApprovalCode(),
        Database::"CTO Request Header", SendApprovalRequestCTOREQ, 0, false);

        //Approve Approval Request
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnApproveApprovalRequestForCTOREQCode(),
        Database::"Approval Entry", ApproveRequestForCTOREQ, 0, false);

        //Reject Approval Request
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnRejectApprovalRequestForCTOREQCode(),
        Database::"Approval Entry", RejectRequestForCTOREQ, 0, false);

        //Delegate Approval Request
        WorkFlowEventHandling.AddEventToLibrary(RunWorkFlowOnDelegateApprovalRequestForCTOREQCode(),
        Database::"Approval Entry", DelegateRequestForCTOREQ, 0, false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary',
     '', true, true)]
    procedure CreateResponseLibraryForCTOREQ()
    begin
        //Send Approval Request
        WorkFlowResponseHandling.AddResponseToLibrary(RunWorkFlowOnSendCTOREQForApprovalCode(),
        Database::"CTO Request Header", SendApprovalRequestCTOREQ, 'GROUP 60037');

        //Approve Approval Request
        WorkFlowResponseHandling.AddResponseToLibrary(RunWorkFlowOnApproveApprovalRequestForCTOREQCode(),
        Database::"Approval Entry", ApproveRequestForCTOREQ, 'GROUP 60037');

        //Reject Approval Request
        WorkFlowResponseHandling.AddResponseToLibrary(RunWorkFlowOnRejectApprovalRequestForCTOREQCode(),
        Database::"Approval Entry", RejectRequestForCTOREQ, 'GROUP 60037');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry";
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CTOReqHeader: Record "CTO Request Header";
    begin
        case RecRef.Number of
            Database::"CTO Request Header":
                begin
                    RecRef.SetTable(CTOReqHeader);
                    ApprovalEntryArgument."Document No." := CTOReqHeader."No.";
                end;
        end;
    end;


    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    procedure CreateEventPredecessorLibraryForCTOREQ(EventFunctionName: Code[128])
    begin
        case EventFunctionName of

        end;
    end;
    */


    var
        WorkFlowMgt: Codeunit "Workflow Management";
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
        WorkFlowResponseHandling: Codeunit "Workflow Response Handling";
        SendApprovalRequestCTOREQ: Label 'Approval of CTO REQUEST is requested.';
        ApproveRequestForCTOREQ: Label 'An approval request for CTO REQUEST is approved.';
        RejectRequestForCTOREQ: Label 'An approval request for CTO REQUEST is rejected.';
        DelegateRequestForCTOREQ: Label 'An approval request for CTO REQUEST is delegated.';

}