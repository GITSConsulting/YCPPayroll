table 65015 "Description of attendance"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Employee Attendance Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Activity Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Activity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Employee Name"; Text[100])
        {

        }
        field(8; Month; Text[100])
        {
        }
        field(9; Year; Integer)
        {
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(DateKey; "Document No.", Date)
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    var
        AbsenceHeader: Record "Employee Attendance Header";
        frz_CodeUnitMonth: Codeunit "Month Picker";
    begin
        AbsenceHeader.Reset();
        AbsenceHeader.SetRange("No.", rec."Document No.");
        if AbsenceHeader.FindFirst() then begin
            rec."Activity Date" := AbsenceHeader."Effective Date";
            rec."Employee No." := AbsenceHeader."Employee No.";
            rec."Employee Name" := AbsenceHeader."Name Employee";
            rec.Year := Date2DMY(AbsenceHeader."Effective Date", 3);
            rec.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(AbsenceHeader."Effective Date", 2));
        end;
    end;

    trigger OnModify()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        // if rec.SystemCreatedBy <> UserSecurityId() then begin
        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", "Document No.");
        if frz_AttendanceHeader.FindFirst() then begin
            rec."Employee No." := frz_AttendanceHeader."Employee No.";
        end;
        cekUser();
        // end;
    end;

    trigger OnDelete()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        // frz_AttendanceHeader.Reset();
        // frz_AttendanceHeader.SetRange("No.", "Document No.");
        // if frz_AttendanceHeader.FindFirst() then begin
        //     rec."Employee No." := frz_AttendanceHeader."Employee No.";
        // end;
        // frz_employee.Reset();
        // frz_employee.SetRange("User ID", UserId);
        // if frz_employee.FindFirst() then begin
        //     if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin
        //         if frz_employee."No." <> Rec."Employee No." then begin
        //             frz_employee_2.Reset();
        //             frz_employee_2.SetRange("MSI_HRIS Admin By", UserId);
        //             if frz_employee_2.FindFirst() then begin
        //                 if frz_employee_2."No." <> Rec."Employee No." then
        //                     Error('This line is not yours');
        //             end;
        //         end;
        //     end;
        // end;
        cekUser();
        // end;
    end;

    procedure cekUser()
    var
        frz_employee: Record Employee;
        frz_employee_2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then
            if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
                if frz_employee."No." <> Rec."Employee No." then begin
                    frz_employee_2.Reset();
                    frz_employee_2.SetRange("MSI_HRIS Admin By", UserId);
                    if frz_employee_2.FindFirst() then begin
                        if frz_employee_2."No." <> Rec."Employee No." then
                            Error('This line is not yours');
                    end;
                end;
    end;

    procedure cekOfficeLocation()
    var
        frz_employee: Record Employee;
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", rec."Document No.");
        frz_AttendanceHeader.FindFirst();

        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then
            if frz_employee."Office Location Code" <> frz_AttendanceHeader."Office Location Code" then
                Error('Office Location Employee does not match with the Office Location in the document header');
    end;


}