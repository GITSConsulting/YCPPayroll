page 60150 "Posted Cuti Dibayar"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted Cuti Dibayar Header";
    Caption = 'Posted Unused Annual Leave Payment';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
            }
            part(Subform; "Posted Cuti Dibayar Subform")
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
            action("Undo and Clear This Transaction")
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = gVisibleUndo;

                trigger
                OnAction()
                var
                    StrConfirm: Text;
                    SeveranceLedgerEntry: Record "Severance Ledger Entry";
                    GeneralPayment: Record "Advance Header";
                    GeneralPayment2: Record "Advance Header";
                    PostedCutiDibayarLine: Record "Posted Cuti Dibayar Line";
                    SummaryOfSeverance: Record "Summary Of Severance";
                    SisaCutiAccrualLedgerEntry: Record "Sisa Cuti Accrual Ledger Entry";
                    GenJnlLine: Record "Gen. Journal Line";
                    LeaveLedgerEntry: Record "Leave Ledger Entry";
                    EligibleLeaveLedgerEntry: Record "Leave Eligible Ledger Entry";
                begin
                    StrConfirm := 'This process will delete unused leave transaction ' + Rec."No." + '\' +
                    'as well as the entry in severance and the general payment.\' +
                    'Are you sure to proceed?';

                    if not Confirm(StrConfirm) then exit;

                    PostedCutiDibayarLine.Reset();
                    PostedCutiDibayarLine.SetRange("Document No.", Rec."No.");
                    PostedCutiDibayarLine.FindFirst();
                    repeat
                        SeveranceLedgerEntry.Reset();
                        SeveranceLedgerEntry.SetRange("Document Date", Rec."Document Date");
                        SeveranceLedgerEntry.SetRange("Employee No.", PostedCutiDibayarLine."Employee No.");
                        SeveranceLedgerEntry.SetRange("Unused Leave Doc. No.", Rec."No.");
                        if SeveranceLedgerEntry.FindFirst() then
                            if SeveranceLedgerEntry.Finished then
                                Error('There is a severance ledger entry for employee %1\' +
                                'You need to clear transaction via severance first', PostedCutiDibayarLine."Employee No.")
                            else begin
                                if not GeneralPaymentIsOpen(SeveranceLedgerEntry."GP No.") then
                                    Error('General payment %1 is already processed.\' +
                                          'You cannot undo/clear this transaction')
                                else begin
                                    GeneralPayment.Reset();
                                    GeneralPayment.SetRange("Document Type", GeneralPayment."Document Type"::"General Payment");
                                    GeneralPayment.SetRange("No.", SeveranceLedgerEntry."GP No.");
                                    GeneralPayment.SetRange("Voucher Type", GeneralPayment."Voucher Type"::" ");
                                    GeneralPayment.SetRange(Status, GeneralPayment.Status::Open);
                                    GeneralPayment.FindFirst();

                                    GeneralPayment."Delete via HR" := true;
                                    GeneralPayment.Modify();

                                    GenJnlLine.Reset();
                                    GenJnlLine.SetRange("Journal Template Name", GeneralPayment."Journal Template Name");
                                    GenJnlLine.SetRange("Journal Batch Name", GeneralPayment."Journal Batch Name");
                                    if GenJnlLine.FindSet() then
                                        GenJnlLine.ModifyAll("Delete via HR", true);

                                    GeneralPayment.Delete(true);

                                    SeveranceLedgerEntry.Delete();
                                end;
                            end;

                    until PostedCutiDibayarLine.Next() = 0;

                    SisaCutiAccrualLedgerEntry.Reset();
                    SisaCutiAccrualLedgerEntry.SetRange("Entry Type", SisaCutiAccrualLedgerEntry."Entry Type"::Negative);
                    SisaCutiAccrualLedgerEntry.SetRange("Document No.", Rec."No.");
                    if SisaCutiAccrualLedgerEntry.FindSet() then
                        SisaCutiAccrualLedgerEntry.DeleteAll();

                    LeaveLedgerEntry.Reset();
                    LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Negative);
                    LeaveLedgerEntry.SetRange("Document No.", Rec."No.");
                    if LeaveLedgerEntry.FindSet() then
                        LeaveLedgerEntry.DeleteAll();

                    EligibleLeaveLedgerEntry.Reset();
                    EligibleLeaveLedgerEntry.SetRange(Type, EligibleLeaveLedgerEntry.Type::Negative);
                    EligibleLeaveLedgerEntry.SetRange("Document No.", Rec."No.");
                    if EligibleLeaveLedgerEntry.FindSet() then
                        EligibleLeaveLedgerEntry.DeleteAll();

                    SummaryOfSeverance.Reset();
                    SummaryOfSeverance.SetRange("Document Date", Rec."Document Date");
                    if SummaryOfSeverance.FindSet() then
                        SummaryOfSeverance.DeleteAll();

                    Rec.Delete(true);

                    Message('Document successfully cleared.');
                    CurrPage.Close();
                end;
            }
        }
    }


    procedure GeneralPaymentIsOpen(DocNo: Code[20]): Boolean
    var
        AdvanceHeader: Record "Advance Header";
    begin
        AdvanceHeader.Reset();
        AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
        AdvanceHeader.SetRange("No.", DocNo);
        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
        AdvanceHeader.SetRange(Status, AdvanceHeader.Status::Open);
        if AdvanceHeader.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    trigger OnOpenPage()
    var
        _Employee: Record Employee;
    begin
        gVisibleUndo := false;
        _Employee.SetRange("User ID", USERID);
        if _Employee.FindFirst() then begin
            if _Employee."Division Code" = 'HR' then
                gVisibleUndo := true
            else
                gVisibleUndo := false;
        end;
    end;

    var
        gVisibleUndo: Boolean;
}