page 60035 "Leave Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Leave Ledger Entry";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Period Start"; Rec."Period Start")
                {
                    Caption = 'Eligible Leave Controller (Start)';
                    ApplicationArea = all;
                }
                field("Period End"; Rec."Period End")
                {
                    Caption = 'Eligible Leave Controller (End)';
                    ApplicationArea = all;
                }
                field("Maximum Times of Accrual"; Rec."Maximum Times of Accrual")
                {
                    ApplicationArea = all;
                }
                field("Maximum Leave Disburtion"; Rec."Maximum Leave Disburtion")
                {
                    ApplicationArea = all;
                }
                field("Hiring Information Entry No."; Rec."Hiring Information Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Undo")
            {
                Image = Undo;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger
                OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                begin
                    Rec.TestField(Type, Rec.Type::Positive);
                    Rec.TestField(Reversed, false);
                    Rec.TestField("Document No.", 'OBAL');

                    LeaveMgt.UndoLeaveLedgerEntry(Rec);

                    CurrPage.Update();
                end;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Reversed then
            Merah := true
        else
            Merah := false;
    end;

    var
        Merah: Boolean;
}