table 65004 "Medical Type Value"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Code; code[20]) { }
        field(2; "Medical Type"; Code[20])
        {
            TableRelation = "Medical Type";
        }
        field(3; Description; text[100]) { }
        field(4; "Line No."; Integer) { }
        field(5; Amount; Decimal)
        {
            // trigger OnValidate()
            // var
            //     recMedicalSlot: Record "Medical Slot";
            // begin
            //     recMedicalSlot.SetRange("Medical Code", rec.Code);
            //     if recMedicalSlot.FindFirst() then begin
            //         repeat
            //             if Rec.Poin > 0 then
            //                 recMedicalSlot."Max Amount Allowance" := rec.Amount * Poin
            //             else
            //                 recMedicalSlot."Max Amount Allowance" := rec.Amount;
            //             recMedicalSlot.Modify();
            //         until recMedicalSlot.next = 0;
            //     end;
            // end;
        }
        field(6; Note; Text[100]) { }
        field(7; Poin; Integer) { }
        field(10; "Amount Adjustments"; Decimal)
        {
        }
        field(9; "Total Amount"; Decimal)
        { }

        field(11; "Total Amount Adjustments"; Decimal) { }
        field(12; "Status Point Code"; Code[20])
        {
            TableRelation = "Master Point Status".Code;
        }
        field(13; "Status Update"; Boolean) { }
    }
    keys
    {
        key(PK; "Medical Type", Code, "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}