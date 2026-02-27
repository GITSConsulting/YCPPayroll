page 60123 "Leave Eligible Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Leave Eligible Ledger Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
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
                    DecimalPlaces = 3;
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
                    Rec.TestField("Document No.", 'ELIGIBLE');

                    LeaveMgt.UndoEligibleLeaveLedgerEntry(Rec);

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