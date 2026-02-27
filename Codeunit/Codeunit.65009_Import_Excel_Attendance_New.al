codeunit 65009 "Import Excel Attendance New"
{
    procedure ImportExcelnya()
    var
        frz_AttendanceLine_1: Record "Employee Absence Line";
    begin
        if UploadIntoStream('Upload Excel', '', '', fileName, ReadInstream) then begin
            if fileName = '' then begin
                exit;
            end;
            SheetName := ExcelBuffer.SelectSheetsNameStream(ReadInstream);
            if SheetName = '' then begin
                exit;
            end;
        end;
        // frz_AttendanceLine_2.Reset();
        // frz_AttendanceLine_2.SetRange("Document No.", frz_AttendanceHeadernya."No.");
        // if frz_AttendanceLine_2.FindFirst() then
        //     frz_AttendanceLine_2.DeleteAll();
        frz_AttendanceLine_1.LockTable();
        if frz_AttendanceLine_1.FindLast() then
            lastLine := frz_AttendanceLine_1."Line No." + 1 else
            lastLine := 1;

        ExcelBuffer.LockTable;
        ExcelBuffer.OpenBookStream(ReadInstream, SheetName);
        ExcelBuffer.ReadSheet;

        GetLastRowNo;
        // loop for checking
        for i := 2 to totalRow do begin
            lastLine += 1;
            CheckLinesHeader(i, lastLine);
        end;
        // loop for insert
        for i := 2 to totalRow do begin
            lastLine += 1;
            insertData(i, lastLine);
        end;
        Message('Success Import');
    end;


    local procedure GetLastRowNo()
    begin
        Clear(totalRow);
        if ExcelBuffer.FindLast() then totalRow := ExcelBuffer."Row No.";
    end;

    local procedure insertData(RowNo: Integer; LastLinenya: integer)
    var
        frz_AttendanceLine: Record "Employee Absence Line";
        frz_AttendanceLine_2: Record "Employee Absence Line";
        AbsenceManage: Codeunit "Employee Absence Management";
        lamaJam: Integer;
        lamaMenit: Integer;
        frz_AttendanceHeader: Record "Employee Attendance Header";
        frz_EmployeeName: Record Employee;
        frz_DateFormat: Text;
        frz_Hari: Text;
        frz_Bulan: Text;
        frz_BulanTemp: Text;
        frz_Tahun: Text;
        frz_AttendanceHeadernya: Record "Employee Attendance Header";
        frz_DatePengecekan: Date;
        frz_CodeUnitMonth: Codeunit "Month Picker";
        frz_AttendanceCreateNew: Record "Employee Attendance Header";
        frz_AttendanceCreateOld: Record "Employee Attendance Header";
        frz_AttendanceCreateEntry: Record "Employee Attendance Header";

        frz_AbsenceManage: Codeunit "Employee Absence Management";
    begin
        Evaluate(frz_DatePengecekan, GetValueAtCell(RowNo, 3));
        frz_AttendanceHeadernya.Reset();
        frz_AttendanceHeadernya.SetRange(Year, Date2DMY(frz_DatePengecekan, 3));
        frz_AttendanceHeadernya.SetRange(Month, frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2)));
        frz_AttendanceHeadernya.SetRange("Employee No.", GetValueAtCell(RowNo, 1));
        if frz_AttendanceHeadernya.FindFirst() then begin

            frz_AttendanceLine.Init();
            Evaluate(frz_AttendanceLine."Employee No.", GetValueAtCell(RowNo, 1));
            Evaluate(frz_AttendanceLine.Date, GetValueAtCell(RowNo, 3));

            Evaluate(frz_AttendanceLine."Time From Line", Format(GetValueAtCell(RowNo, 6)));
            Evaluate(frz_AttendanceLine."Time To Line", format(GetValueAtCell(RowNo, 7)));
            Evaluate(frz_AttendanceLine."Activity Description", GetValueAtCell(RowNo, 8));
            frz_AttendanceLine."Entry No Header" := frz_AttendanceHeadernya."Entry No.";
            frz_AttendanceLine."Document No." := frz_AttendanceHeadernya."No.";
            frz_AttendanceLine."Activity Date" := frz_AttendanceHeadernya."Effective Date";
            frz_AttendanceLine."Data by Import" := true;
            frz_AttendanceLine.WFH := frz_AbsenceManage.WFHChek(frz_AttendanceLine."Employee No.", frz_AttendanceLine.Date);
            frz_AttendanceLine."Line No." += LastLinenya;

            frz_EmployeeName.Reset();
            frz_EmployeeName.SetRange("No.", GetValueAtCell(RowNo, 1));
            if frz_EmployeeName.FindFirst() then
                frz_AttendanceLine."Employee Name" := frz_EmployeeName.FullName();

            frz_AttendanceLine.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2));
            frz_AttendanceLine.Year := Date2DMY(frz_DatePengecekan, 3);

            if (GetValueAtCell(RowNo, 6) = '') OR (GetValueAtCell(RowNo, 7) = '') then begin
            end else begin
                AbsenceManage.hitungDurasiAbsence(frz_AttendanceLine."Time From Line", frz_AttendanceLine."Time To Line", lamaJam, lamaMenit);
                frz_AttendanceLine."Total Duration Hours" := lamaJam;
                frz_AttendanceLine."Total Duration Minutes" := lamaMenit;
            end;
            if (GetValueAtCell(RowNo, 6) = '') and (GetValueAtCell(RowNo, 7) = '') then begin
            end
            else begin
                frz_AttendanceLine.Insert();
            end;
        end else begin
            frz_AttendanceCreateNew.Year := Date2DMY(frz_DatePengecekan, 3);
            frz_AttendanceCreateNew.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2));
            frz_AttendanceCreateEntry.Reset();
            if frz_AttendanceCreateEntry.FindLast() then
                frz_AttendanceCreateNew."Entry No." := frz_AttendanceCreateEntry."Entry No." + 1;
            frz_AttendanceCreateNew."Effective Date" := DMY2DATE(1, Date2DMY(frz_DatePengecekan, 2), Date2DMY(frz_DatePengecekan, 3));
            frz_AttendanceCreateNew."Employee No." := GetValueAtCell(RowNo, 1);
            frz_EmployeeName.Reset();
            frz_EmployeeName.SetRange("No.", GetValueAtCell(RowNo, 1));
            if frz_EmployeeName.FindFirst() then
                frz_AttendanceCreateNew."Name Employee" := frz_EmployeeName.FullName();
            frz_AttendanceCreateNew.Insert(true);

            frz_AttendanceLine.Init();
            Evaluate(frz_AttendanceLine."Employee No.", GetValueAtCell(RowNo, 1));
            Evaluate(frz_AttendanceLine.Date, GetValueAtCell(RowNo, 3));
            Evaluate(frz_AttendanceLine."Time From Line", GetValueAtCell(RowNo, 6));
            Evaluate(frz_AttendanceLine."Time To Line", GetValueAtCell(RowNo, 7));
            frz_AttendanceLine."Entry No Header" := frz_AttendanceCreateNew."Entry No.";
            frz_AttendanceLine."Document No." := frz_AttendanceCreateNew."No.";
            frz_AttendanceLine."Activity Date" := frz_AttendanceCreateNew."Effective Date";
            frz_AttendanceLine."Data by Import" := true;
            frz_AttendanceLine.WFH := frz_AbsenceManage.WFHChek(frz_AttendanceLine."Employee No.", frz_AttendanceLine.Date);
            frz_AttendanceLine."Line No." += LastLinenya;

            frz_EmployeeName.Reset();
            frz_EmployeeName.SetRange("No.", GetValueAtCell(RowNo, 1));
            if frz_EmployeeName.FindFirst() then
                frz_AttendanceLine."Employee Name" := frz_EmployeeName.FullName();

            frz_AttendanceLine.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2));
            frz_AttendanceLine.Year := Date2DMY(frz_DatePengecekan, 3);

            if (GetValueAtCell(RowNo, 6) = '') OR (GetValueAtCell(RowNo, 7) = '') then begin
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

    local procedure CheckLinesHeader(RowNo: Integer; LastLinenya: integer)
    var
        frz_AttendanceLine: Record "Employee Absence Line";
        frz_AttendanceLine_2: Record "Employee Absence Line";
        frz_AttendanceHeadernya: Record "Employee Attendance Header";
        frz_AttendanceHeader: Record "Employee Attendance Header";
        frz_DatePengecekan: Date;
        frz_CodeUnitMonth: Codeunit "Month Picker";
    begin
        Evaluate(frz_DatePengecekan, GetValueAtCell(RowNo, 3));
        frz_AttendanceHeadernya.Reset();
        frz_AttendanceHeadernya.SetRange(Year, Date2DMY(frz_DatePengecekan, 3));
        frz_AttendanceHeadernya.SetRange(Month, frz_CodeUnitMonth.getNameMonth(Date2DMY(frz_DatePengecekan, 2)));
        frz_AttendanceHeadernya.SetRange("Employee No.", GetValueAtCell(RowNo, 1));
        if frz_AttendanceHeadernya.FindFirst() then begin
            frz_AttendanceLine.Reset();
            frz_AttendanceLine.SetRange("Document No.", frz_AttendanceHeadernya."No.");
            if frz_AttendanceLine.FindFirst() then
                frz_AttendanceLine.DeleteAll();
        end;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        excelBuffer1: Record "Excel Buffer";
    begin
        if excelBuffer1.get(RowNo, ColNo) then
            exit(excelBuffer1."Cell Value as Text");
    end;


    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Attendance Nos.");
        exit(PayrollGenSetup."Attendance Nos.");
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        DeprBook: Record "Depreciation Book";
        fileName: Text;
        SheetName: Text;
        ReadInstream: InStream;
        i: integer;
        totalRow: Integer;
        lastLine: Integer;
        Tablenya: Record "Employee Attendance Header";
        PayrollGenSetup: Record "Payroll General Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit "No. Series";
}