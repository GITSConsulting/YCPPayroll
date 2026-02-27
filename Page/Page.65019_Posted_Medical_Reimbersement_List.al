page 65019 "Posted Medical Reimbu List"
{
    Caption = 'Posted Medical Reimbursement List';
    PageType = List;
    RefreshOnActivate = true;
    Editable = false;
    SourceTable = "Medical Reimbursement Header";
    SourceTableView = where("Posted Document" = filter(true));
    // ApplicationArea = All;
    UsageCategory = Administration;
    // CardPageId = "Medical Reimbursement Card";

    layout
    {
        area(Content)
        {
            repeater(MyGroup)
            {
                field(Code; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                }


                //dre
                field("Approver ID"; Rec."Approver ID")
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
            action("Undo Medical Reimbersement")
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    MedicalMgt: Codeunit "Proses Medical Reimbersement";
                    ApprovalChain: Record "Approval Chain Setup";
                begin
                    ApprovalChain.Reset();
                    ApprovalChain.SetRange("Document Type", ApprovalChain."Document Type"::"Medical Reimbursement");
                    ApprovalChain.SetRange(ID, UserId);
                    if not ApprovalChain.FindFirst() then
                        Error('You have to be an approver to undo Medical Reimbersement.');
                    // else
                    //     if not ApprovalChain."Able to Undo CTO Request" then
                    //         Error('You are not authorized to undo Medical Reimbersement.');

                    Rec.TestField(Status, Rec.Status::Released);

                    if not confirm('This process will create reversal Medical entries\' +
                                   'as a correction, and then reopen this document. \' +
                                   '\' +
                                   'Are you sure to continue?') then
                        exit;

                    MedicalMgt.undoProcessMedicalBalance(Rec."No.");

                    CurrPage.Update();

                    Message('Succesfully undo Medical Reimbersement %1. The status is now open, \' +
                            'Medical Balance for Employee %1 is REVERSED.',
                            Rec."No.", Rec.NamaEmployee(Rec."Employee No."));
                end;
            }
        }
    }

    var
        myInt: Integer;
}