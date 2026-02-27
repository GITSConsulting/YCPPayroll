page 60080 "Posted CTO Realization"
{
    Caption = 'Posted Realization of Compensatory Time Off';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted CTO Realization Header";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
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
                    Editable = false;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(EmpName; EmpName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Employee No. Replacement"; Rec."Employee No. Replacement")
                {
                    ApplicationArea = all;
                    Caption = 'My Replacement During Leave';
                }
                field(ReplaceName; ReplaceName)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Employee Replacement Name';
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Print CTO Realization")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    CTOHeader: Record "Posted CTO Realization Header";
                begin
                    CurrPage.SetSelectionFilter(CTOHeader);
                    Report.run(Report::"Posted CTO Realization", true, false, CTOHeader);
                end;
            }
            action("Undo")
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedOnly = true;
                trigger
                OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                    frz_CU_EmailUndo: Codeunit "Email Undo";
                begin
                    if not rec.Reversed then begin
                        frz_CU_EmailUndo.cekKomennye(rec."No.");
                        LeaveMgt.UndoCTORealization(Rec);
                        frz_CU_EmailUndo.SendEmailCTORealization(rec."No.");
                    end else
                        Message('This CTO Realization has been reversed before.');
                end;
            }
            // fadhil
            action(Comments)
            {
                // Visible = OpenApprovalEntriesExistForCurrUser;
                Caption = 'Comments Undo';
                Image = Comment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    frz_getComment: Codeunit getComment;
                begin
                    frz_getComment.RunApprovalCommentsPage(Rec."No.", 60021);
                end;
            }
        }
    }

    var
        EmpName: Text;
        ReplaceName: Text;

    trigger
    OnAfterGetRecord()
    begin
        if Rec."Employee No." <> '' then
            EmpName := Rec.NamaEmployee(Rec."Employee No.");

        if Rec."Employee No. Replacement" <> '' then
            ReplaceName := Rec.NamaEmployee(Rec."Employee No. Replacement");
    end;
}