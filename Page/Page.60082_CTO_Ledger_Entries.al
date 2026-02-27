page 60082 "CTO Ledger Entries"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CTO Ledger Entry";
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
                field("CTO Type"; Rec."CTO Type")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Task Date"; Rec."Task Date")
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
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    trigger
                    OnDrillDown()
                    var
                        DetailedCTOLedgerEntry: Record "Detailed CTO Ledger Entry";
                        PageDetailedCTOLedgerEntries: Page "Detailed CTO Ledger Entries";
                    begin
                        DetailedCTOLedgerEntry.Reset();
                        DetailedCTOLedgerEntry.SetRange("CTO Ledger Entry No.", Rec."Entry No.");
                        //DetailedCTOLedgerEntry.SetRange("Task ID", Rec."Task ID");
                        if DetailedCTOLedgerEntry.FindFirst() then begin
                            PageDetailedCTOLedgerEntries.SetTableView(DetailedCTOLedgerEntry);
                            PageDetailedCTOLedgerEntries.Run();
                        end;
                    end;
                }
                field("Day Balance"; Rec."Day Balance")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Request Approval Date"; Rec."Request Approval Date")
                {
                    ApplicationArea = all;
                    Visible = false;

                }
                field("Request Expired Date"; Rec."Request Expired Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field(Used; rec.Used)
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Document Use For"; rec."Document Use For")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        if Rec.Expired then
            Merah := true
        else
            Merah := false;
    end;

    var
        Merah: Boolean;
}