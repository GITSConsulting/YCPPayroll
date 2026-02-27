page 65070 "MR Ledger Entries New"
{
    caption = 'Medical Reimbursement Ledger Entries';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Medical Reim Ledger Entries";
    SourceTableTemporary = true;
    // InsertAllowed = false;
    DeleteAllowed = false;
    // ModifyAllowed = false;
    // Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Medical Type"; rec."Medical Type")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if Rec."Medical Type" <> xRec."Medical Type" then begin
                            Rec."Medical Value" := '';
                            Rec."Quantity 2" := 0;
                            rec."Daily rate - room" := false;
                        end;
                    end;
                }
                field("Rawat Inat Type"; rec."Rawat Inat Type")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    ApplicationArea = all;
                    TableRelation = "Medical Values" where("Medical Type" = field("Medical Type"));
                }
                field("Posting Date"; Rec."Document Date")
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
                field("Request Approval Date"; Rec."Request Approval Date")
                {
                    ApplicationArea = all;
                    Visible = false;
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
            action("Post")
            {
                ApplicationArea = all;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    MedicalLedgEntry: Record "Medical Reim Ledger Entries";
                    MedicalLedgEntryReversal: Record "Medical Reim Ledger Entries";
                    MedicalLedgEntry2: Record "Medical Reim Ledger Entries";
                    EntryNo: Integer;
                begin
                    MedicalLedgEntry2.Reset();
                    if MedicalLedgEntry2.FindLast() then
                        EntryNo := MedicalLedgEntry2."Entry No." + 1
                    else
                        EntryNo := 1;
                    //create record reversal-nya
                    MedicalLedgEntryReversal.Init();
                    MedicalLedgEntryReversal.TransferFields(Rec);
                    MedicalLedgEntryReversal."Entry No." := EntryNo;
                    MedicalLedgEntryReversal."Entry Type" := MedicalLedgEntryReversal."Entry Type"::Positive;
                    MedicalLedgEntryReversal.Insert();

                    Message('Success Create Ledger');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec."Entry Type" := Rec."Entry Type"::Positive;
        rec."Employee No." := EmployeeNya;
    end;

    trigger OnAfterGetRecord()
    begin
        rec."Entry Type" := Rec."Entry Type"::Positive;
        rec."Employee No." := EmployeeNya;
    end;

    trigger OnInsertRecord(Boleann: Boolean): Boolean
    begin
        rec."Entry Type" := Rec."Entry Type"::Positive;
        rec."Employee No." := EmployeeNya;
    end;

    var
        EmployeeNya: Code[50];
        EntryTpenya: Option;

    procedure GetEmployeeNo(EmployeeNo: Code[50])
    begin
        EmployeeNya := EmployeeNo;
    end;
}