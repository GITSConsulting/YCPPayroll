table 60040 "CTO Realization Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Work Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Starting Time Realization"; Time)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if Rec."Starting Time Realization" <> xRec."Starting Time Realization" then begin
                    "Ending Time Realization" := 0T;
                    "Duration Realization (Day)" := 0;
                    "Duration Realization (Hour)" := 0;
                    "Duration Realization (Minute)" := 0;
                end;
            end;
        }
        field(11; "Ending Time Realization"; Time)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                LeaveMgt: Codeunit "Leave Management";
                lamaJam: Integer;
                lamaMenit: Integer;
            begin
                TestField("Starting Time Realization");

                if "Ending Time Realization" <= "Starting Time Realization" then
                    Error('Ending Time must be bigger than Starting Time.');

                LeaveMgt.hitungDurasi("Starting Time Realization", "Ending Time Realization",
                lamaJam, lamaMenit);

                //DIV untuk menghitung hari (kelipatan 4 jam)
                //lamaJam DIV 4

                //MOD menghitung sisa durasi di bawah 4 jam
                //lamaJam MOD 4

                if lamaJam < 4 then begin
                    "Duration Realization (Day)" := 0;
                    "Duration Realization (Hour)" := lamaJam;
                end else begin
                    "Duration Realization (Day)" := lamaJam div 4;
                    "Duration Realization (Hour)" := lamaJam mod 4;
                end;

                "Duration Realization (Minute)" := lamaMenit;
            end;
        }
        field(12; "Duration Realization (Day)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Duration Realization (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Duration Realization (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }


        //start flowfield doang
        field(15; "Starting Time (Requested)"; Time)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CTO Request Line"."Starting Time" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
            Editable = false;
        }
        field(16; "Ending Time (Requested)"; Time)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CTO Request Line"."Ending Time" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
            Editable = false;
        }
        field(17; "Duration Requested (Day)"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CTO Request Line"."Duration (Day)" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
            Editable = false;
        }
        field(18; "Duration Requested (Hour)"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CTO Request Line"."Duration (Hour)" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
            Editable = false;
        }
        field(19; "Duration Requested (Minute)"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("CTO Request Line"."Duration (Minute)" where("Document No." = field("Document No."),
            "Line No." = field("Line No.")));
            Editable = false;
        }
        //end flowfield doang


    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}