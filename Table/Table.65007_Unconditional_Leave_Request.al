table 65007 "Unconditional Leave Request"
{
    Permissions = tabledata "Approval Entry" = rimd;

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Type"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No." where(Status = const(Active));
        }
        field(6; "Job Title"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Paid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Annual,Sick,CTO,Other;
        }
        field(9; "Unpaid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Leave Without Pay","Absence Without Pay";
        }
        field(10; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                frz_BaseCalendar: Record "Base Calendar Change";
                frz_BaseCalendar2: Record "Base Calendar Change";
                frz_ResourceDate: Record Date;
                frz_tglMerah: Integer;
                frz_SabMing: Integer;
                rec_PayrollGenSetup: Record "Payroll General Setup";
                frz_getTotal: Integer;
                frz_LeaveValue: Record "Master Leave Unconditional";
                FormatHari: text;
            begin
                rec.TestField("Leave Type Code");
                // if "Ending Date" <> 0D then
                // if "Starting Date" > "Ending Date" then begin
                //     Error('Starting period date cannot be bigger than ending period date.');

                //     if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then
                //         rec_PayrollGenSetup.FindFirst();
                //     frz_BaseCalendar.Reset();
                //     frz_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                //     frz_BaseCalendar.SetRange(Date, "Starting Date", "Ending Date");
                //     frz_BaseCalendar.SetRange(Nonworking, true);
                //     if frz_BaseCalendar.FindFirst() then
                //         frz_tglMerah := frz_BaseCalendar.Count;

                //     frz_SabMing := 0;
                //     frz_ResourceDate.Reset();
                //     frz_ResourceDate.SetRange("Period Start", "Starting Date", "Ending Date");
                //     if frz_ResourceDate.FindFirst() then
                //         repeat
                //             frz_BaseCalendar2.Reset();
                //             frz_BaseCalendar2.SetFilter("Base Calendar Code", '= %1', rec_PayrollGenSetup."Base Calendar Code");
                //             frz_BaseCalendar2.SetFilter(Date, '= %1', 0D);
                //             frz_BaseCalendar2.SetFilter(Day, '= %1', frz_ResourceDate."Period No.");
                //             frz_BaseCalendar2.SetFilter(Nonworking, '= %1', true);
                //             if frz_BaseCalendar2.FindFirst() then
                //                 frz_SabMing += frz_BaseCalendar2.Count;
                //         until frz_ResourceDate.Next = 0;
                //     // rec."Total Number of Days" := (("Ending Date" - "Starting Date") + 1) - (frz_tglMerah + frz_SabMing);
                //     frz_getTotal := 0;
                //     frz_getTotal := ((rec."Ending Date" - rec."Starting Date") + 1) - (frz_tglMerah + frz_SabMing);

                //     frz_LeaveValue.Reset();
                //     frz_LeaveValue.SetRange(Code, rec."Leave Type Code");
                //     if frz_getTotal > frz_LeaveValue."maximum leave" then begin
                //         if frz_LeaveValue."maximum leave" > 1 then begin
                //             FormatHari := '<+' + Format(frz_LeaveValue."maximum leave") + 'D>';
                //             rec."Ending Date" := CalcDate(FormatHari, "Starting Date");
                //         end else
                //             rec."Ending Date" := "Starting Date";

                //         rec."Total Number of Days" := frz_LeaveValue."maximum leave";
                //     end
                //     else
                //         rec."Total Number of Days" := frz_getTotal;
                //     // validate("Total Number of Days", "Ending Date" - "Starting Date" + 1);
                //     // "Total Number of Days" := "Ending Date" - "Starting Date" + 1;
                // end;
                rec."Ending Date" := 0D;
                rec."Total Number of Days" := 0;
                if rec."Total Number of Days" <> 0.5 then begin
                    rec."Leave-1" := false;
                    rec."Leave-2" := false;
                end;
            end;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                frz_BaseCalendar: Record "Base Calendar Change";
                frz_BaseCalendar2: Record "Base Calendar Change";
                frz_ResourceDate: Record Date;
                frz_tglMerah: Integer;
                frz_SabMing: Integer;
                rec_PayrollGenSetup: Record "Payroll General Setup";
                frz_getTotal: Integer;
                frz_LeaveValue: Record "Master Leave Unconditional";
                FormatHari: text;
            begin
                rec.TestField("Leave Type Code");
                if "Starting Date" <> 0D then
                    if "Ending Date" < "Starting Date" then
                        Error('Ending period date cannot be smaller than starting period date.');

                if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then begin
                    rec_PayrollGenSetup.FindFirst();
                    frz_BaseCalendar.Reset();
                    frz_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                    frz_BaseCalendar.SetRange(Date, "Starting Date", "Ending Date");
                    frz_BaseCalendar.SetRange(Nonworking, true);
                    frz_BaseCalendar.setfilter(Day, '<> %1', frz_BaseCalendar.Day::Sunday);
                    if frz_BaseCalendar.FindFirst() then
                        repeat
                            if frz_BaseCalendar.Day <> frz_BaseCalendar.day::Saturday then
                                frz_tglMerah += 1;
                        until frz_BaseCalendar.Next() = 0;

                    frz_SabMing := 0;
                    frz_ResourceDate.Reset();
                    frz_ResourceDate.SetRange("Period Start", "Starting Date", "Ending Date");
                    frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                    if frz_ResourceDate.FindFirst() then
                        repeat
                            frz_BaseCalendar2.Reset();
                            frz_BaseCalendar2.SetFilter("Base Calendar Code", '= %1', rec_PayrollGenSetup."Base Calendar Code");
                            frz_BaseCalendar2.SetFilter(Date, '= %1', 0D);
                            frz_BaseCalendar2.SetFilter(Day, '= %1', frz_ResourceDate."Period No.");
                            frz_BaseCalendar2.SetFilter(Nonworking, '= %1', true);
                            if frz_BaseCalendar2.FindFirst() then
                                frz_SabMing += frz_BaseCalendar2.Count;
                        until frz_ResourceDate.Next = 0;
                    // rec."Total Number of Days" := (("Ending Date" - "Starting Date") + 1) - (frz_tglMerah + frz_SabMing);
                    frz_getTotal := 0;
                    frz_getTotal := ((rec."Ending Date" - rec."Starting Date") + 1) - (frz_tglMerah + frz_SabMing);

                    frz_LeaveValue.Reset();
                    frz_LeaveValue.SetRange(Code, rec."Leave Type Code");
                    if frz_LeaveValue.FindFirst() then
                        if frz_getTotal > frz_LeaveValue."maximum leave" then begin
                            if frz_LeaveValue."maximum leave" > 1 then begin
                                FormatHari := '<+' + Format(frz_LeaveValue."maximum leave" - 1) + 'D>';
                                rec."Ending Date" := CalcDate(FormatHari, "Starting Date");
                            end else
                                rec."Ending Date" := "Starting Date";

                            rec."Total Number of Days" := frz_LeaveValue."maximum leave";
                        end
                        else
                            rec."Total Number of Days" := frz_getTotal
                    else
                        rec."Total Number of Days" := frz_getTotal;
                    // "Total Number of Days" := "Ending Date" - "Starting Date" + 1;
                    if rec."Total Number of Days" <> 0.5 then begin
                        rec."Leave-1" := false;
                        rec."Leave-2" := false;
                    end;
                end;
            end;
        }
        field(12; "Total Number of Days"; Decimal)
        {
            DecimalPlaces = 1;
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                TotalDays: Decimal;
                KuranginStengah: Decimal;
            begin
                Clear(TotalDays);
                Clear(KuranginStengah);

                if Rec."Total Number of Days" <> xRec."Total Number of Days" then begin
                    TestField("Ending Date");
                    TestField("Starting Date");

                    TotalDays := "Ending Date" - "Starting Date" + 1;
                    KuranginStengah := TotalDays - 0.5;

                    if ("Total Number of Days" <> TotalDays) and
                       ("Total Number of Days" <> KuranginStengah) then
                        Error('Total Number of Days is not valid.');

                    if rec."Total Number of Days" <> 0.5 then begin
                        rec."Leave-1" := false;
                        rec."Leave-2" := false;
                    end;
                end;
            end;
        }
        field(13; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No." where(Status = const(Active));
        }
        field(14; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(15; "Approver ID"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Approval Entry"."Approver ID" where("Document No." = field("No."),
            "Table ID" = const(65007), Status = const(Open)));
        }
        field(17; "Employee Name"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Leave Type Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Master Leave Unconditional".Code where("Document Type" = const("Unconditional Leave"));
        }
        field(19; "Document Type"; Enum "Document Type Leave")
        {
            DataClassification = CustomerContent;
        }
        field(20; "Leave-1"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Total Number of Days" <> 0.5 then
                    Error('Total number of days must be equal = 0.5');

                if rec."Leave-1" = true then
                    rec."Leave-2" := false;
            end;
        }
        field(21; "Leave-2"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Total Number of Days" <> 0.5 then
                    Error('Total number of days must be equal = 0.5');

                if rec."Leave-2" = true then
                    rec."Leave-1" := false;
            end;
        }
    }

    keys
    {
        key(PK; "Leave Type", "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";

    //DRE
    trigger
    OnDelete()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        if ApprovalEntry.FindSet() then
            ApprovalEntry.DeleteAll();
    end;



    trigger OnInsert()
    var
        frz_Employee: Record Employee;
    begin
        "Posting Date" := Today;

        if "No." = '' then
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date", false);
        // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
        // "Posting Date", "No.", "No. Series");

        // fadhil
        frz_Employee.Reset();
        frz_Employee.SetRange("User ID", UserId);
        if frz_Employee.FindFirst() then begin
            Rec."Employee No." := frz_Employee."No.";
            Rec."Employee Name" := frz_Employee.FullName();
        end;
        // fadhil tutup
    end;

    procedure GetEmployeeName(isEmployee: Boolean): Text;
    var
        xEmployee: Record Employee;
        xEmployeeReplacement: Record Employee;
    begin
        if isEmployee then begin
            if xEmployee.Get(Rec."Employee No.") then
                exit(xEmployee.FullName());
        end else begin
            if xEmployeeReplacement.Get(Rec."Employee No. Replacement") then
                exit(xEmployeeReplacement.FullName());
        end;
    end;


    procedure AssistEdit(OldLeaveRequest: Record "Unconditional Leave Request"): Boolean;
    var
        LeaveRequest: Record "Unconditional Leave Request";
    begin
        LeaveRequest := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldLeaveRequest."No. Series",
           "No. Series") then begin
            //NoSeriesMgt.SetSeries("No.");
            Rec."No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date", false);
            Rec := LeaveRequest;
            exit(true);
        end;

        exit(false);
    end;

    // procedure GetNoSeriesCode(): Code[10];
    // begin
    //     PayrollGenSetup.Get();

    //     if "Leave Type" = "Leave Type"::Paid then begin
    //         PayrollGenSetup.TestField("Paid Leave Request Nos.");
    //         exit(PayrollGenSetup."Paid Leave Request Nos.");
    //     end else begin
    //         PayrollGenSetup.TestField("Unpaid Leave Request Nos.");
    //         exit(PayrollGenSetup."Unpaid Leave Request Nos.");
    //     end;
    // end;
    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Unconditional Leave Nos.");
        exit(PayrollGenSetup."Unconditional Leave Nos.");
    end;
}