codeunit 60015 "Troubleshoot Approval Entry"
{
    //ANNUAL LEAVE
    procedure CreateApprovalAnnualLeaveGroup(var LeaveRequest: Record "Leave Request"; var ResponseWorkflowStepInstance: Record "Workflow Step Instance"; StartingEntryNo: Integer)
    var
        _AppChainSetup: Record "Approval Chain Setup";
        _AppEntry: Record "Approval Entry";
        _AppEntry2: Record "Approval Entry";
        _NewAmount: Decimal;
        _EntryNo: Integer;
        _Employee: Record Employee;
        i: Integer;
    begin
        _AppEntry.Reset();
        if StartingEntryNo = 0 then begin
            _AppEntry.LockTable();
            if _AppEntry.FindLast() then
                _EntryNo := _AppEntry."Entry No."
            else
                _EntryNo := 0
        end else
            _EntryNo := StartingEntryNo - 1;

        if not _AppEntry2.Get(_EntryNo + 1) then begin

            _AppChainSetup.SETRANGE("Document Type", _AppChainSetup."Document Type"::"Annual Leave");
            //_AppChainSetup.SETFILTER("Min. Approval Amount", '<=%1', _NewAmount);
            //_AppChainSetup.SETFILTER("Max. Approval Amount", '>=%1|0', _NewAmount);
            //If not AdvanceHeader."Emergency Advance" then
            //    _AppChainSetup.SetRange("Emergency Advance", false);
            //if not AdvanceHeader."International Travel" then
            //    _AppChainSetup.SetRange("International Travel", false);
            if _AppChainSetup.FindFirst then begin
                repeat
                    i += 1;
                    _EntryNo += 1;
                    _AppEntry.Init();
                    _AppEntry."Table ID" := Database::"Leave Request";
                    _AppEntry."Document Type" := _AppEntry."Document Type"::" ";
                    _AppEntry."Document No." := LeaveRequest."No.";
                    _AppEntry."Sequence No." := 1;
                    _AppEntry."Approval Code" := ResponseWorkflowStepInstance."Workflow Code";

                    //harus dipastikan, apakah employee no ini yg diambil
                    _Employee.GET(LeaveRequest."Employee No.");


                    _Employee.CALCFIELDS("User ID");
                    IF _Employee."User ID" <> '' THEN
                        _AppEntry."Sender ID" := _Employee."User ID"
                    ELSE begin
                        _Employee.TestField("MSI_HRIS Admin By");
                        _AppEntry."Sender ID" := _Employee."MSI_HRIS Admin By";
                    end;


                    if not GlobalInstance.GetSkipValidateCreateApprovalAdvanceGroup then
                        if _AppChainSetup."Approver Type" = _AppChainSetup."Approver Type"::Supervisor then begin
                            _AppChainSetup.TestField(id, '');
                            _Employee.TestField("Manager User ID");
                            _AppEntry."Approver ID" := _Employee."Manager User ID";
                        end else
                            if _AppChainSetup."Approver Type" = _AppChainSetup."Approver Type"::Director then begin
                                _AppChainSetup.TESTFIELD(ID, '');
                                _Employee.TESTFIELD("Director User ID");
                                _AppEntry."Approver ID" := _Employee."Director User ID";
                            end else begin
                                _AppChainSetup.TestField(ID);
                                _AppEntry."Approver ID" := _AppChainSetup.ID;
                            end;
                    if i = 1 then
                        _AppEntry.Status := _AppEntry.Status::Open
                    else
                        _AppEntry.Status := _AppEntry.Status::Created;
                    _AppEntry."Date-Time Sent for Approval" := CurrentDateTime();
                    _AppEntry."Due Date" := Today();
                    _AppEntry."Approval Type" := _AppEntry."Approval Type"::Approver;
                    _AppEntry."Limit Type" := _AppEntry."Limit Type"::"No Limits";
                    _AppEntry."Record ID to Approve" := ResponseWorkflowStepInstance."Record ID";
                    _AppEntry."Entry No." := _EntryNo;
                    _AppEntry."Workflow Step Instance ID" := ResponseWorkflowStepInstance.ID;

                    _AppEntry."Approval Chain Doc. Type" := _AppChainSetup."Document Type";
                    _AppEntry."Approval Chain Line No." := _AppChainSetup."Line No.";
                    _AppEntry."Verificator" := _AppChainSetup.Verificator;

                    _AppEntry.Insert();

                until _AppChainSetup.Next = 0;
            end
            else
                Error('No approval chain are specified.');
        end;

    end;


    var
        GlobalInstance: Codeunit GlobalInstanceDRE;
}