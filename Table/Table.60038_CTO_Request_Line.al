table 60038 "CTO Request Line"
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
        field(4; "Starting Time"; Time)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if Rec."Starting Time" <> xRec."Starting Time" then begin
                    "Ending Time" := 0T;
                    "Duration (Day)" := 0;
                    "Duration (Hour)" := 0;
                    "Duration (Minute)" := 0;
                end;
            end;
        }
        field(5; "Ending Time"; Time)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                LeaveMgt: Codeunit "Leave Management";
                lamaJam: Integer;
                lamaMenit: Integer;
            begin
                TestField("Starting Time");

                if "Ending Time" <= "Starting Time" then
                    Error('Ending Time must be bigger than Starting Time.');

                LeaveMgt.hitungDurasi("Starting Time", "Ending Time", lamaJam, lamaMenit);

                //DIV untuk menghitung hari (kelipatan 4 jam)
                //lamaJam DIV 4

                //MOD menghitung sisa durasi di bawah 4 jam
                //lamaJam MOD 4

                /*
                if lamaJam < 4 then begin
                    "Duration (Day)" := 0;
                    "Duration (Hour)" := lamaJam;
                end else begin
                    "Duration (Day)" := lamaJam div 4;
                    "Duration (Hour)" := lamaJam mod 4;
                end;
                */
                //LeaveMgt.projectedCTOBalance("Document No.");


                "Duration (Hour)" := lamaJam;
                "Duration (Minute)" := lamaMenit;
            end;
        }
        field(6; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                Header: Record "CTO Request Header";

                CTOHeader: Record "CTO Request Header";
                CTOLine: Record "CTO Request Line";
                PostedCTOHeader: Record "Posted CTO Request Header";
                PostedCTOLine: Record "Posted CTO Request Line";
            begin
                Header.Get("Document No.");
                if "Task Date" < Header."Document Date" then
                    Error('Task Date must be bigger or equal to Document Date.');

                // fadhil
                // cari tanggal yang sama pada document lain pada CTO Request
                CTOHeader.Reset();
                CTOHeader.SetRange("Employee No.", Header."Employee No.");
                CTOHeader.SetFilter("No.", '<> %1', rec."Document No.");
                if CTOHeader.FindFirst() then
                    repeat
                        CTOLine.Reset();
                        CTOLine.SetRange("Document No.", CTOHeader."No.");
                        if CTOLine.FindFirst() then
                            repeat
                                if CTOLine."Task Date" = rec."Task Date" then
                                    Error('The Date same with another document');
                            until CTOLine.Next() = 0;
                    until CTOHeader.Next() = 0;

                // cari tanggal yang sama pada document lain pada Posted CTO Request
                PostedCTOHeader.Reset();
                PostedCTOHeader.SetRange("Employee No.", Header."Employee No.");
                PostedCTOHeader.SetFilter("No.", '<> %1', rec."Document No.");
                if PostedCTOHeader.FindFirst() then
                    repeat
                        PostedCTOLine.Reset();
                        PostedCTOLine.SetRange("Document No.", PostedCTOHeader."No.");
                        if PostedCTOLine.FindFirst() then
                            repeat
                                if PostedCTOLine."Task Date" = rec."Task Date" then
                                    Error('The Date same with another document');
                            until PostedCTOLine.Next() = 0;
                    until PostedCTOHeader.Next() = 0;
                // fadhil //
            end;
        }
        field(7; "Duration (Day)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Duration (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Duration (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Task Date")
        {
            SumIndexFields = "Duration (Hour)";
        }
        key(SK2; "Document No.", "Task Date")
        {
            SumIndexFields = "Duration (Hour)";
        }
    }

    trigger
    OnModify()
    var
        Header: Record "CTO Request Header";
    begin
        Header.Get("Document No.");
        Header.TestField(Status, Header.Status::Open);

        Header."Projected Calculated" := false;
        Header."Projected CTO Balance" := 0;
        Header.Modify();
    end;
}