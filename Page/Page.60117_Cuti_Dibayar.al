page 60117 "Cuti Dibayar"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cuti Dibayar Header";
    Caption = 'Unused Annual Leave Payment';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger
                    OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(Subform; "Cuti Dibayar Subform")
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
            action(Release)
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CekLine: Record "Cuti Dibayar Line";
                begin
                    CekLine.Reset();
                    CekLine.SetRange("Document No.", Rec."No.");
                    CekLine.FindFirst();
                    repeat
                        CekLine.TestField("Employee No.");
                        CekLine.TestField("Cuti Dibayarkan");
                        CekLine.TestField("Actual Payment Date");
                    until CekLine.Next() = 0;

                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    LeaveMgt.PostUnusedLeave(Rec);
                end;
            }
        }
    }
}