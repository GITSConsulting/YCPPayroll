table 65013 "Posted Employee Absence Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Employee Attendance Header";
        }
        field(13; "Entry No Header"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Shortcut Dimension 1 Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('FUND CODE'));
        }
        field(4; "Shortcut Dimension 2 Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Time From Line"; Time)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Rec."Time From Line" <> xRec."Time To Line" then begin
                    "Time To Line" := 0T;
                    "Total Duration Hours" := 0;
                    "Total Duration Minutes" := 0;
                end;
            end;
        }
        field(6; "Time To Line"; Time)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                AbsenceManage: Codeunit "Employee Absence Management";
                lamaJam: Integer;
                lamaMenit: Integer;
            begin
                if "Time To Line" <= "Time From Line" then
                    Error('Time To must be bigger than Time From.');
                AbsenceManage.hitungDurasiAbsence("Time From Line", "Time To Line", lamaJam, lamaMenit);
                "Total Duration Hours" := lamaJam;
                "Total Duration Minutes" := lamaMenit;
            end;
        }
        field(7; "Total Duration Hours"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Total Duration Minutes"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Activity Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Activity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Office Location Code"; Code[50])
        {

        }
        field(15; "Employee Name"; Text[100])
        {

        }
    }

    keys
    {
        key(PK; "Document No.", "Entry No Header", "Line No.")
        {
            Clustered = true;
        }
    }
    var
    trigger OnInsert()
    var
        AbsenceHeader: Record "Employee Attendance Header";
    begin
        AbsenceHeader.SetRange("No.", rec."Document No.");
        if AbsenceHeader.FindFirst() then begin
            rec."Activity Date" := AbsenceHeader."Effective Date";
            rec."Employee No." := AbsenceHeader."Employee No.";
        end;
    end;

    //start -Andre 16 Sep 21
    procedure CheckLeaveSync(Tanggalnya: Date; EmployeeNo: Code[20])
    var
        LeaveRequest: Record "Leave Request";
        PostedLeaveRequest: Record "Posted Leave Request";
    begin
        LeaveRequest.Reset();
        LeaveRequest.SetRange("Employee No.", EmployeeNo);
        LeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        LeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if LeaveRequest.FindSet() then
            Error('There is a leave request for this date = %1\' +
                  'Please check.', Tanggalnya);

        PostedLeaveRequest.Reset();
        PostedLeaveRequest.SetRange("Employee No.", EmployeeNo);
        PostedLeaveRequest.SetFilter("Starting Date", '<=%1', Tanggalnya);
        PostedLeaveRequest.SetFilter("Ending Date", '>=%1', Tanggalnya);
        if PostedLeaveRequest.FindSet() then
            Error('There is a posted leave request for this date = %1\' +
                  'Please check.', Tanggalnya);
    end;
    //end -Andre

}