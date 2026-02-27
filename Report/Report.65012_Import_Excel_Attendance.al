report 65012 "Import Excel Attendance"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Employee Attendance Header"; "Employee Attendance Header")
        {
            column(No_; "No.") { }
            column(Effective_Date; "Effective Date") { }
            column(Entry_No_; "Entry No.") { }
        }
    }
    requestpage
    {
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            getTect: text;
        begin
            if CloseAction = Action::OK then begin
                if UploadIntoStream('Upload Excel', '', '', fileName, ReadInstream) then begin
                    if fileName = '' then
                        exit(false);
                    SheetName := ExcelBuffer.SelectSheetsNameStream(ReadInstream);
                    if SheetName = '' then
                        exit(true);
                end;
            end;
        end;
    }

    trigger OnPreReport()
    var
        frz_AttendanceLine_1: Record "Employee Absence Line";
    begin
        if frz_AttendanceLine_1.FindLast() then
            lastLine := frz_AttendanceLine_1."Line No." + 1 else
            lastLine := 1;

        ExcelBuffer.LockTable;
        ExcelBuffer.OpenBookStream(ReadInstream, SheetName);
        ExcelBuffer.ReadSheet;

        GetLastRowNo;
        for i := 4 to totalRow do begin
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
    begin
        frz_AttendanceLine.Init();
        Evaluate(frz_AttendanceLine."Employee No.", GetValueAtCell(RowNo, 1));
        Evaluate(frz_AttendanceLine."Activity Description", GetValueAtCell(RowNo, 2));
        Evaluate(frz_AttendanceLine.Date, GetValueAtCell(RowNo, 3));
        Evaluate(frz_AttendanceLine."Time From Line", GetValueAtCell(RowNo, 4));
        Evaluate(frz_AttendanceLine."Time To Line", GetValueAtCell(RowNo, 5));
        frz_AttendanceLine."Entry No Header" := Tablenya."Entry No.";
        frz_AttendanceLine."Document No." := Tablenya."No.";
        frz_AttendanceLine."Activity Date" := Tablenya."Effective Date";
        frz_AttendanceLine."Line No." += LastLinenya;

        AbsenceManage.hitungDurasiAbsence(frz_AttendanceLine."Time From Line", frz_AttendanceLine."Time To Line", lamaJam, lamaMenit);
        frz_AttendanceLine."Total Duration Hours" := lamaJam;
        frz_AttendanceLine."Total Duration Minutes" := lamaMenit;
        frz_AttendanceLine.Insert();
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