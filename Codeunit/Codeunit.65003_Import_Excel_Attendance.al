codeunit 65003 "Import Excel Attendance"
{
    procedure ImportExcelnya(DocNo: Text)
    var
        frz_AttendanceLine_1: Record "Employee Absence Line";
    begin
        Tablenya.SetRange("No.", DocNo);
        if Tablenya.FindFirst() then
            Tablenya.FindFirst();

        if UploadIntoStream('Upload Excel', '', '', fileName, ReadInstream) then begin
            if fileName = '' then begin
                exit;
            end;
            SheetName := ExcelBuffer.SelectSheetsNameStream(ReadInstream);
            if SheetName = '' then begin
                exit;
            end;
        end;

        frz_AttendanceLine_1.LockTable();
        if frz_AttendanceLine_1.FindLast() then
            lastLine := frz_AttendanceLine_1."Line No." + 1 else
            lastLine := 1;

        ExcelBuffer.LockTable;
        ExcelBuffer.OpenBookStream(ReadInstream, SheetName);
        ExcelBuffer.ReadSheet;

        GetLastRowNo;

        for i := 2 to totalRow do begin
            lastLine += 1;
            insertData(i, lastLine);
        end;

    end;

    local procedure GetLastRowNo()
    begin
        Clear(totalRow);
        if ExcelBuffer.FindLast() then totalRow := ExcelBuffer."Row No.";
    end;

    local procedure insertData(RowNo: Integer; LastLinenya: integer)
    var
        frz_AttendanceLine: Record "Employee Absence Line";
        AbsenceManage: Codeunit "Employee Absence Management";
        lamaJam: Integer;
        lamaMenit: Integer;
        frz_EmployeeName: Record Employee;
        frz_DatePengecekan: Date;
        frz_CodeUnitMonth: Codeunit "Month Picker";
        frz_AbsenceManage: Codeunit "Employee Absence Management";

    begin
        Evaluate(frz_DatePengecekan, GetValueAtCell(RowNo, 3));
        // employee name
        frz_EmployeeName.Reset();
        frz_EmployeeName.SetRange("No.", GetValueAtCell(RowNo, 1));
        if frz_EmployeeName.FindFirst() then begin
            frz_AttendanceLine.Init();
            Evaluate(frz_AttendanceLine."Employee No.", GetValueAtCell(RowNo, 1));
            Evaluate(frz_AttendanceLine.Date, GetValueAtCell(RowNo, 3));
            Evaluate(frz_AttendanceLine."Time From Line", GetValueAtCell(RowNo, 6));
            Evaluate(frz_AttendanceLine."Time To Line", GetValueAtCell(RowNo, 7));
            Evaluate(frz_AttendanceLine."Activity Description", GetValueAtCell(RowNo, 8));
            frz_AttendanceLine."Entry No Header" := Tablenya."Entry No.";
            frz_AttendanceLine."Document No." := Tablenya."No.";
            frz_AttendanceLine."Activity Date" := Tablenya."Effective Date";
            frz_AttendanceLine."Line No." += LastLinenya;
            frz_AttendanceLine."Employee Name" := frz_EmployeeName.FullName();
            frz_AttendanceLine.WFH := frz_AbsenceManage.WFHChek(frz_AttendanceLine."Employee No.", frz_AttendanceLine.Date);

            frz_AttendanceLine.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2));
            frz_AttendanceLine.Year := Date2DMY(frz_DatePengecekan, 3);

            if (GetValueAtCell(RowNo, 6) = '') or (GetValueAtCell(RowNo, 7) = '') then begin
            end else begin
                AbsenceManage.hitungDurasiAbsence(frz_AttendanceLine."Time From Line", frz_AttendanceLine."Time To Line", lamaJam, lamaMenit);
                frz_AttendanceLine."Total Duration Hours" := lamaJam;
                frz_AttendanceLine."Total Duration Minutes" := lamaMenit;
            end;

            if (GetValueAtCell(RowNo, 6) = '') and (GetValueAtCell(RowNo, 7) = '') then begin
            end
            else
                frz_AttendanceLine.Insert();
        end;

    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        excelBuffer1: Record "Excel Buffer";
    begin
        if excelBuffer1.get(RowNo, ColNo) then
            exit(excelBuffer1."Cell Value as Text");
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        fileName: Text;
        SheetName: Text;
        ReadInstream: InStream;
        i: integer;
        totalRow: Integer;
        lastLine: Integer;
        Tablenya: Record "Employee Attendance Header";
}