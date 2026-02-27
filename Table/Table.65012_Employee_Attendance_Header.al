table 65012 "Employee Attendance Header"
{
    DataClassification = ToBeClassified;

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
            TableRelation = Employee."No." where(Status = const(Active));

            trigger OnValidate()
            var
                rec_AttendanceLine: Record "Employee Absence Line";
            begin
                if rec."Employee No." <> xRec."Employee No." then
                    Delete_DoA();

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
                if rec."Employee No." <> xRec."Employee No." then begin

                    Delete_DoA();

                    rec_AttendanceLine.SetRange("Document No.", Rec."No.");
                    if rec_AttendanceLine.FindFirst() then begin
                        repeat
                            rec_AttendanceLine."Activity Date" := rec."Effective Date";
                            rec_AttendanceLine.Modify();
                        until rec_AttendanceLine.Next = 0;
                    end;

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
            OptionMembers = Open,Released;
        }
        field(65015; "Office Location Code"; Code[50])
        {

        }
        field(65016; Month; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(65017; Year; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65018; "Other Attendance Your Handle"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(65019; "Employee Filter"; Text[500])
        {
            FieldClass = FlowFilter;
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

    trigger OnInsert()
    var
        frz_employee: Record Employee;
        frz_codeUnit: Codeunit "User Setup Custome";
    begin
        Rec."Office Location Code" := frz_codeUnit.CheckLocationCode(UserId);

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

        frz_employee.reset;
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then begin
            // rec."Employee No." := frz_employee."No.";
            // rec."Name Employee" := frz_employee.FullName();
        end;
    end;

    trigger OnDelete()
    var
        frz_AttendanceLine: Record "Employee Absence Line";
    begin
        frz_AttendanceLine.Reset();
        frz_AttendanceLine.SetRange("Document No.", "No.");
        if frz_AttendanceLine.FindFirst() then
            frz_AttendanceLine.DeleteAll();
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

    procedure CekEffektivDate(Datenya: Date; Nonya: text; Location: code[50])
    var
        rec_AttendanceHeader: Record "Employee Attendance Header";
    begin
        rec_AttendanceHeader.SetFilter("No.", '<> %1', Nonya);
        rec_AttendanceHeader.SetRange("Effective Date", CalcDate('-CM', Datenya), CalcDate('CM', Datenya));
        rec_AttendanceHeader.SetRange("Employee No.", Location);
        if rec_AttendanceHeader.FindFirst() then begin
            Error('the month on the Effective Date field for this employee %1 already exists in the another document', Location);
        end;
    end;

    procedure AssistEdit(OldCTOHeader: Record "Employee Attendance Header"): Boolean;
    var
        CTOHeader: Record "Employee Attendance Header";
    begin
        CTOHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldCTOHeader."No. Series",
           "No. Series") then begin
            //NoSeriesMgt.SetSeries(rec."No.");
            Rec."No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := CTOHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Attendance Nos.");
        exit(PayrollGenSetup."Attendance Nos.");
    end;

    procedure Delete_DoA()
    var
        frz_DescriptionofAttendance: Record "Description of attendance";
    begin
        frz_DescriptionofAttendance.Reset();
        frz_DescriptionofAttendance.SetRange("Document No.", rec."No.");
        if frz_DescriptionofAttendance.FindFirst() then
            frz_DescriptionofAttendance.DeleteAll();
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