table 65003 "Medical Reimbursement Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Medical Reimbursement Header";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Day"; Integer)
        {
        }
        field(4; "Medical Type"; Enum "Type Medical")
        {
        }
        field(5; "Date"; Date)
        {
            trigger OnValidate()
            var
                frz_MEdicalHeader: Record "Medical Reimbursement Header";
            begin
                frz_MEdicalHeader.Reset();
                frz_MEdicalHeader.SetRange("No.", rec."Document No.");
                if frz_MEdicalHeader.FindFirst() then begin
                    if Rec.Date > frz_MEdicalHeader."Posting Date" then
                        Error('The date must be less than equal to Posting Date header');
                    if rec.Date < CalcDate('-CM', frz_MEdicalHeader."Posting Date") then
                        Error('From date can not be more than 1 month posting date');
                end;
            end;
        }
        field(6; "Claim Amount"; Decimal)
        {
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
        }
        field(8; "Total Claim"; Decimal)
        {
        }
        field(9; "Amount Day"; Decimal)
        {
        }
        field(10; "Employee No."; Code[20])
        {
        }
        field(11; Category; Enum "Categpry Medical")
        {
        }
        field(12; "Medical Value"; Code[20])
        {
            TableRelation = "Medical Values".Code;
        }
        field(13; Description; Text[100])
        {
        }
        field(14; Quantity; Integer)
        {
        }
        field(15; "Paid Amount"; Decimal)
        {
        }
        field(16; "Status Poin"; code[50])
        {
            TableRelation = "Master Point Status".Code;
        }
        field(17; "Poin"; Decimal)
        {
        }
        field(18; "Rawat Inat Type"; Enum "Rawat Inap Type") { }
        field(19; "Daily rate - room"; Boolean) { }
        field(20; Reversed; Boolean) { }
        field(21; "Quantity 2"; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(PK; "Document No.", "Medical Type", "Line No.")
        {
        }
    }
    trigger OnInsert()
    var
        rec_MedicalHeader: Record "Medical Reimbursement Header";
    begin
        ErrorEdit();
        // get employee number
        rec_MedicalHeader.SetRange("No.", Rec."Document No.");
        if rec_MedicalHeader.FindFirst() then
            Rec."Employee No." := rec_MedicalHeader."Employee No.";
    end;

    trigger OnModify()
    begin
        ErrorEdit();
    end;

    trigger OnDelete()
    begin
        ErrorEdit();
    end;

    procedure ErrorEdit()
    var
        frz_MedicalHeader: Record "Medical Reimbursement Header";
    begin
        frz_MedicalHeader.Reset();
        frz_MedicalHeader.SetRange("No.", "Document No.");
        if frz_MedicalHeader.FindFirst() then begin
            if frz_MedicalHeader.Status <> frz_MedicalHeader.Status::Open then
                Error('Status must be equal to Open');
        end;
    end;

}