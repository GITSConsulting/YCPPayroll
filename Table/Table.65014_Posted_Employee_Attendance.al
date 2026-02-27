table 65014 "Posted Employee Attendance"
{
    DataClassification = ToBeClassified;
    // DataCaptionFields = "Employee No.";
    // DrillDownPageID = "Employee Attendance List";
    // LookupPageID = "Employee Attendance List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
        }
        field(16; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            var
                rec_AttendanceLine: Record "Employee Absence Line";
            begin
                rec_AttendanceLine.SetRange("Document No.", Rec."No.");
                if rec_AttendanceLine.FindFirst() then begin
                    repeat
                        rec_AttendanceLine."Employee No." := rec."Employee No.";
                        rec_AttendanceLine.Modify();
                    until rec_AttendanceLine.Next = 0;
                end;
                Employee.Get("Employee No.");
                if Employee."Privacy Blocked" then
                    Error(BlockedErr);
            end;
        }
        field(15; "Name Employee"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            trigger OnValidate()
            var
                rec_AttendanceLine: Record "Employee Absence Line";
            begin

                rec_AttendanceLine.SetRange("Document No.", Rec."No.");
                if rec_AttendanceLine.FindFirst() then begin
                    repeat
                        rec_AttendanceLine."Activity Date" := rec."Effective Date";
                        rec_AttendanceLine.Modify();
                    until rec_AttendanceLine.Next = 0;
                end;
            end;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(4; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(5; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                CauseOfAbsence.Get("Cause of Absence Code");
                Description := CauseOfAbsence.Description;
                Validate("Unit of Measure Code", CauseOfAbsence."Unit of Measure Code");
            end;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := UOMMgt.CalcBaseQty(Quantity, "Qty. per Unit of Measure");
            end;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate()
            begin
                HumanResUnitOfMeasure.Get("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                Validate(Quantity);
            end;
        }
        // field(11; Comment; Boolean)
        // {
        //     CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST("Employee Absence Header"),
        //                                                              "Table Line No." = FIELD("Entry No.")));
        //     Caption = 'Comment';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(12; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
            end;
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(65000; "Time From"; Time)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Time From" <> xRec."Time From" then begin
                    "Time To" := 0T;
                    "Duration (Day)" := 0;
                    "Duration (Hour)" := 0;
                    "Duration (Minute)" := 0;
                end;
            end;
        }
        field(65001; "Time To"; Time)
        {
            DataClassification = CustomerContent;
            trigger
           OnValidate()
            var
                LeaveMgt: Codeunit "Leave Management";
                lamaJam: Integer;
                lamaMenit: Integer;
                jamTerlambat: Integer;
                menitTerlambat: Integer;
            begin
                TestField("Time From");

                if "Time To" <= "Time From" then
                    Error('Time To must be bigger than Time From.');

                LeaveMgt.hitungDurasi("Time From", "Time To", lamaJam, lamaMenit);

                "Duration (Hour)" := lamaJam;
                "Duration (Minute)" := lamaMenit;

                hitungDurasiTerlambat("Time From", "Time To", jamTerlambat, menitTerlambat);
                if (menitTerlambat > 0) then begin
                    "Late Duration (Hours)" := jamTerlambat - 1;
                    if 60 - menitTerlambat = 60 then
                        "Late Duration (Minutes)" := 0
                    else
                        "Late Duration (Minutes)" := 60 - menitTerlambat;
                end else begin
                    "Late Duration (Hours)" := jamTerlambat;
                    if 60 - menitTerlambat = 60 then
                        "Late Duration (Minutes)" := 0
                    else
                        "Late Duration (Minutes)" := 60 - menitTerlambat;
                end;
            end;
        }
        field(65002; "Late Duration (Minutes)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65003; "Late Duration (Hours)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65004; "Total Work Hours"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(65005; "Day"; integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Employee Absence Line" where("Document No." = field("No.")));
        }
        field(65006; "Duration (Day)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65007; "Duration (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65008; "Duration (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65009; "Created User ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(65010; "Approver ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(65011; "Description By Employee"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(65012; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(65013; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(65014; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "--",Open,Released;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        frz_RecAttendanceLine: Record "Posted Employee Absence Line";
    begin
        frz_RecAttendanceLine.SetRange("Document No.", rec."No.");
        if frz_RecAttendanceLine.FindFirst() then
            frz_RecAttendanceLine.DeleteAll();
    end;

    trigger OnInsert()
    begin

        EmployeeAttendance.SetCurrentKey("Entry No.");
        if EmployeeAttendance.FindLast then
            "Entry No." := EmployeeAttendance."Entry No." + 1
        else begin
            CheckBaseUOM;
            "Entry No." := 1;
        end;
        "Created User ID" := UserId;

        rec."From Date" := Today;
        rec.Day := 1;
        rec.Quantity := 8;
        rec."Time From" := Time;

        "Document Date" := Today;
        if "No." = '' then
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
        // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
        // "Document Date", "No.", "No. Series");
    end;

    local procedure CheckBaseUOM()
    var
        HumanResourcesSetup: Record "Human Resources Setup";
    begin
        HumanResourcesSetup.Get();
        HumanResourcesSetup.TestField("Base Unit of Measure");
    end;

    procedure hitungDurasiTerlambat(startingTime: Time; endingTime: Time;
   var intJamLambat: Integer; var intMenitLambat: Integer)
    var
        Selisih: BigInteger;
    begin
        Selisih := endingTime - startingTime;

        intJamLambat := Quantity - Selisih div (60 * 60 * 1000);
        intMenitLambat := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    // procedure NamaEmployee(_noEmp: Code[20]): Text
    // var
    //     employee: Record Employee;
    // begin
    //     if employee.Get(_noEmp) then
    //         exit(employee.FullName());
    // end;

    // procedure AssistEdit(OldCTOHeader: Record "Employee Attendance Header"): Boolean;
    // var
    //     CTOHeader: Record "Employee Attendance Header";
    // begin
    //     CTOHeader := Rec;

    //     if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldCTOHeader."No. Series",
    //        "No. Series") then begin
    //         NoSeriesMgt.SetSeries(rec."No.");
    //         Rec := CTOHeader;
    //         exit(true);
    //     end;

    //     exit(false);
    // end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Attendance Nos.");
        exit(PayrollGenSetup."Attendance Nos.");
    end;

    var
        CauseOfAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        EmployeeAttendance: Record "Employee Attendance Header";
        HumanResUnitOfMeasure: Record "Human Resource Unit of Measure";
        BlockedErr: Label 'You cannot register absence because the employee is blocked due to privacy.';
        UOMMgt: Codeunit "Unit of Measure Management";
        NoSeriesMgt: Codeunit "No. Series";
        SalesHeader: Record "Medical Reimbursement Header";
        Text051: Label 'The stock release order %1 already exists.';
        SalesSetup: Record "Inventory Setup";
        SelectNoSeriesAllowed: Boolean;
        PayrollGenSetup: Record "Payroll General Setup";
}