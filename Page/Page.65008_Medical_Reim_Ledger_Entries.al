page 65008 "Medical Reim Ledger Entries"
{
    caption = 'Medical Reimbursement Ledger Entries';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Medical Reim Ledger Entries";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    ApplicationArea = all;
                }
                field("Medical Type"; rec."Medical Type")
                {
                    ApplicationArea = all;
                }
                field("Request Approval Date"; Rec."Request Approval Date")
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Caption = 'Date';
                }
                field("expired date optical"; rec."expired date optical")
                {
                    ApplicationArea = all;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Day Balance"; Rec."Quantity 2")
                {
                    ApplicationArea = all;
                }
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    ApplicationArea = all;
                }
                field("Request Expired Date"; Rec."Request Expired Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("New")
            {
                ApplicationArea = all;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = visiblenya;
                trigger OnAction()
                var
                    MedicalListPage: Page "MR Ledger Entries New";
                begin
                    MedicalListPage.GetEmployeeNo(rec."Employee No.");
                    MedicalListPage.Run();
                end;
            }
            action("Undo")
            {
                ApplicationArea = all;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = visiblenya;
                trigger OnAction()
                var
                    MedicalLedgEntry: Record "Medical Reim Ledger Entries";
                    MedicalLedgEntryReversal: Record "Medical Reim Ledger Entries";
                    MedicalLedgEntry2: Record "Medical Reim Ledger Entries";

                    EntryNo: Integer;
                    Window: Dialog;
                begin
                    if Rec."Entry Type" = rec."Entry Type"::Negative then
                        Error('Entry Type must be Positive');

                    Window.Open('Undoing balance....please wait..');

                    MedicalLedgEntry.Reset();
                    MedicalLedgEntry.SetRange("Entry No.", rec."Entry No.");
                    MedicalLedgEntry.SetRange("Document No.", rec."Document No.");
                    MedicalLedgEntry.SetRange("Entry Type", MedicalLedgEntry."Entry Type"::Positive);
                    if MedicalLedgEntry.FindFirst() then begin

                        MedicalLedgEntry2.Reset();
                        if MedicalLedgEntry2.FindLast() then
                            EntryNo := MedicalLedgEntry2."Entry No." + 1
                        else
                            EntryNo := 1;
                        //create record reversal-nya
                        MedicalLedgEntryReversal.Init();
                        MedicalLedgEntryReversal.TransferFields(MedicalLedgEntry);
                        MedicalLedgEntryReversal."Entry No." := EntryNo;
                        MedicalLedgEntryReversal."Reversal Entry" := true;
                        MedicalLedgEntryReversal."Entry Type" := MedicalLedgEntryReversal."Entry Type"::Negative;
                        MedicalLedgEntryReversal.Description := 'UNDO ENTRY';
                        MedicalLedgEntryReversal.Amount := MedicalLedgEntry.Amount * -1;
                        MedicalLedgEntryReversal."Quantity 2" := MedicalLedgEntry."Quantity 2" * -1;
                        MedicalLedgEntryReversal.Insert();

                    end;
                    Message('Undo Success');
                    Window.Close();
                end;
            }
            action("Print Balance Report")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = reportLedgerVisible_2;
                ApplicationArea = all;
                trigger OnAction()
                var
                    MedicalLedger: Record "Medical Reim Ledger Entries";
                begin
                    MedicalLedger.Reset();
                    MedicalLedger.SetRange("Employee No.", rec."Employee No.");

                    if rec."Medical Type" = rec."Medical Type"::"Rawat Inap" then begin
                        if rec."Daily rate - room" = true then
                            MedicalLedger.SetRange("Daily rate - room", true)
                        else begin
                            MedicalLedger.SetRange("Rawat Inat Type", rec."Rawat Inat Type");
                            MedicalLedger.SetRange("Daily rate - room", false);
                        end;
                        MedicalLedger.SetRange("Medical Type", rec."Medical Type");
                    end else
                        MedicalLedger.SetRange("Medical Type", rec."Medical Type");

                    if (rec."Medical Type" = rec."Medical Type"::Persalinan) or (rec."Medical Type" = rec."Medical Type"::Kacamata) then
                        MedicalLedger.SetRange("Medical Value", rec."Medical Value");

                    Report.run(Report::"Ledger MR Persalinan", true, false, MedicalLedger);
                end;
            }
            action("Print Balance Kacamata Report")
            {
                Caption = 'Print Balance Report';
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = reportLedgerVisible;
                ApplicationArea = all;
                trigger OnAction()
                var
                    MedicalLedger: Record "Medical Reim Ledger Entries";
                begin
                    MedicalLedger.Reset();
                    MedicalLedger.SetRange("Employee No.", rec."Employee No.");
                    MedicalLedger.SetRange("Medical Type", rec."Medical Type");
                    Report.run(Report::"Ledger MR Kacamata", true, false, MedicalLedger);
                end;
            }
        }
    }
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
        visiblenya: Boolean;
        reportLedgerVisible: Boolean;
        reportLedgerVisible_2: Boolean;

    trigger OnOpenPage()
    var
    begin
        visiblenya := frz_CodeUnit.AttendanceAdminCheck(UserId);
    end;

    trigger OnAfterGetRecord()
    begin
        if rec."Medical Type" = rec."Medical Type"::Kacamata then
            reportLedgerVisible := true else
            reportLedgerVisible_2 := true;
    end;
}