codeunit 65002 "Unconditional Leave Manage"
{
    procedure PostLeaveRequest(UncoLeaveRequest: Record "Unconditional Leave Request")
    var
        PostedUnconLeaveRequest: Record "Posted Unco Leave Request";
    begin
        InsertLeaveLedgerEntry(UncoLeaveRequest, true, '', 0);

        PostedUnconLeaveRequest.Init();
        PostedUnconLeaveRequest.TransferFields(UncoLeaveRequest);
        PostedUnconLeaveRequest.Insert();

        UncoLeaveRequest.Delete();

        Message('Unconditional leave request is successfully posted.');
    end;

    procedure undoPostedLeaveRequest(PostedLeave: Record "Posted Unco Leave Request")
    var
        SourceLeaveLedger: Record "Uncon Leave Ledger Entry";
        TargetLeaveLedger: Record "Uncon Leave Ledger Entry";
        NoEntry: Integer;
        LeaveLedgerGitu: Record "Uncon Leave Ledger Entry";
    begin
        PostedLeave.TestField(Reversed, false);

        if not confirm('Are you sure to undo this posted leave?') then exit;

        LeaveLedgerGitu.LockTable();
        LeaveLedgerGitu.Reset();
        if LeaveLedgerGitu.FindLast() then
            NoEntry := LeaveLedgerGitu."Entry No." + 1
        else
            NoEntry := 1;

        SourceLeaveLedger.Reset();
        // SourceLeaveLedger.SetRange("Leave Type", PostedLeave."Leave Type");
        SourceLeaveLedger.SetRange("Document No.", PostedLeave."No.");
        SourceLeaveLedger.FindFirst();

        SourceLeaveLedger.Reversed := true;
        SourceLeaveLedger."Reversed by Entry No." := NoEntry;
        SourceLeaveLedger.Modify();

        TargetLeaveLedger.Init();
        TargetLeaveLedger.TransferFields(SourceLeaveLedger);
        TargetLeaveLedger."Entry No." := NoEntry;
        TargetLeaveLedger."Reverse Entry" := true;
        TargetLeaveLedger.Type := TargetLeaveLedger.Type::Positive;
        TargetLeaveLedger.Quantity := (SourceLeaveLedger.Quantity) * -1;
        TargetLeaveLedger.Description := 'Reverse transaction for ' + SourceLeaveLedger."Document No.";
        TargetLeaveLedger.Insert();

        PostedLeave.Reversed := true;
        PostedLeave.Modify();

        Message('Undo successfull for posted leave %1', PostedLeave."No.");
    end;

    procedure InsertLeaveLedgerEntry(__LeaveRequest: Record "Unconditional Leave Request"; isLeaveReq: Boolean; __EmpNo: Code[20]; JatahCutiTahunan: Decimal)
    var
        LeaveLedgerEntry: Record "Uncon Leave Ledger Entry";
        LeaveLedgerEntry2: Record "Uncon Leave Ledger Entry";
        Employee: Record Employee;
        EntryNo: Integer;
        EmpNoInsert: Code[20];
        PostingDate: Date;
        LeaveLedgerType: Option Negative,Positive;
        LeaveLedgerDesc: Text[100];
        LeaveLedgerDocNo: Code[20];
        LeaveQty: Decimal;
        DimCode1: Code[10];
        LeaveType: Option ,Paid,Unpaid;
        LeaveTypeCode: Code[50];
        PaidLeaveType: Option ,Annual,Sick,CTO,Other;
        UnpaidLeaveType: Option ,"Leave Without Pay","Absence Without Pay";
    begin
        LeaveLedgerEntry2.LockTable();
        LeaveLedgerEntry2.Reset();
        if LeaveLedgerEntry2.FindLast() then
            EntryNo := LeaveLedgerEntry2."Entry No." + 1
        else
            EntryNo := 1;


        if isLeaveReq then begin
            Employee.Get(__LeaveRequest."Employee No.");
            EmpNoInsert := __LeaveRequest."Employee No.";
            PostingDate := __LeaveRequest."Posting Date";
            LeaveLedgerType := LeaveLedgerType::Negative;
            LeaveLedgerDesc := 'Leave request for ';
            LeaveQty := -__LeaveRequest."Total Number of Days";
            DimCode1 := __LeaveRequest."Global Dimension 1 Code";
            LeaveLedgerDocNo := __LeaveRequest."No.";
            // LeaveTypeCode := __LeaveRequest."Leave Type Code";
            // PaidLeaveType := __LeaveRequest."Paid Leave Type";
            // UnpaidLeaveType := __LeaveRequest."Unpaid Leave Type";
            LeaveLedgerType := LeaveLedgerType::Negative;
        end else begin
            Employee.Get(__EmpNo);
            EmpNoInsert := __EmpNo;
            PostingDate := Today;
            LeaveLedgerType := LeaveLedgerType::Positive;
            LeaveLedgerDesc := 'OBAL Leave slot for ';
            LeaveQty := JatahCutiTahunan;
            //DimCode1 := blom jelas ini kalo leave slot pake dimension apa
            // LeaveType := LeaveType::Paid;
            // PaidLeaveType := PaidLeaveType::Annual;
            LeaveLedgerDocNo := 'OBAL';
        end;

        LeaveLedgerDesc := LeaveLedgerDesc + Employee.FullName();

        LeaveLedgerEntry.Init();
        LeaveLedgerEntry."Entry No." := EntryNo;
        LeaveLedgerEntry."Employee No." := EmpNoInsert;
        LeaveLedgerEntry."Posting Date" := PostingDate;
        LeaveLedgerEntry.Type := LeaveLedgerType;

        LeaveLedgerEntry.Description := LeaveLedgerDesc;
        LeaveLedgerEntry.Quantity := LeaveQty;

        LeaveLedgerEntry."Global Dimension 1 Code" := DimCode1;
        LeaveLedgerEntry."Document No." := LeaveLedgerDocNo;

        LeaveLedgerEntry."Leave Type Code" := __LeaveRequest."Leave Type Code";

        // LeaveLedgerEntry."Paid Leave Type" := PaidLeaveType;
        // LeaveLedgerEntry."Unpaid Leave Type" := UnpaidLeaveType;

        LeaveLedgerEntry."Starting Date" := __LeaveRequest."Starting Date";
        LeaveLedgerEntry."Ending Date" := __LeaveRequest."Ending Date";
        LeaveLedgerEntry."Employee No. Replacement" := __LeaveRequest."Employee No. Replacement";
        LeaveLedgerEntry.Insert();
    end;
}