page 65067 "MR Line OPBAL"
{
    Caption = 'Medical Lines OPBAL';
    SourceTable = "Medical Reimbursement Line";
    PageType = ListPart;
    RefreshOnActivate = true;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    layout
    {
        area(content)
        {
            repeater(Line)
            {
                ShowCaption = false;
                field("Medical Type"; rec."Medical Type")
                {
                    Caption = 'Medical Claim Type';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        recHeader: Record "Medical Reimbursement Header";
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        recMedicalSlot: Record "Medical Values";
                    begin
                        // get deskripsi medical values
                        recMedicalSlot.SetRange(Code, Rec."Medical Value");
                        if recMedicalSlot.FindFirst() then
                            rec.Description := recMedicalSlot.Description;

                        CurrPage.Update();
                    end;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_MEdicalHeader: Record "Medical Reimbursement Header";
                    begin
                        frz_MEdicalHeader.Reset();
                        frz_MEdicalHeader.SetRange("No.", rec."Document No.");
                        if frz_MEdicalHeader.FindFirst() then begin
                            if Rec.Date > frz_MEdicalHeader."Posting Date" then
                                Error('The date must be less than equal to Posting Date header');
                        end;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Paid Amount"; rec."Paid Amount")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('FUND CODE'));
                }
            }
        }
    }
}
