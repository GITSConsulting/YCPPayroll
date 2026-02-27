report 65010 "Attendance for Print"
{
    UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;
    RDLCLayout = './Report/Report.65010_Attendance_for_Print.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(Job_Title; "Job Title") { }
            column(FullName; FullName) { }
            column(Division_Code; "Division Code") { }
            column(Office_Location_Code; "Office Location Code") { }
            column(fromDate; fromDate) { }
            column(toDate; toDate) { }
            dataitem("Employee Attendance Header"; "Employee Attendance Header")
            {
                DataItemLink = "Employee No." = field("No.");
                column(No_HEader; "No.") { }
                column(efektiveDate; "Effective Date") { }
                column(Employee_No_; "Employee No.") { }
                column(From_Date; "From Date") { }
                column(Time_From; "Time From") { }
                column(Effective_Date; "Effective Date") { }
                column(Time_To; "Time To") { }
                column(Day; Day) { }
                column(Description; Description) { }
                column(Duration__Hour_; "Duration (Hour)") { }
                column(Duration__Minute_; "Duration (Minute)") { }
                column(Description_By_Employee; "Description By Employee") { }
                column(Quantity; Quantity) { }
                column(Divisi; Divisi) { }
                column(totaljam; totaljam) { }
                dataitem("Employee Absence Line"; "Employee Absence Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    column(Document_No_; "Document No.") { }
                    column(Entry_No_Header; "Entry No Header") { }
                    column(Date; Date) { }
                    column(Time_From_Line; "Time From Line") { }
                    column(Time_To_Line; "Time To Line") { }
                }
                column(Employeename; Employeename) { }
                trigger OnPreDataItem()
                begin
                    fromDate := CalcDate('-CM', Tanggal);
                    toDate := CalcDate('CM', Tanggal);
                    SetRange("Effective Date", fromDate, toDate);
                end;

                trigger OnAfterGetRecord()
                var
                    mixDuration: integer;
                    stringDuration: Text;
                begin
                    mixDuration := "Duration (Hour)" + "Duration (Minute)" + 00 + 'T';
                    GetEmployee("Employee No.");
                    totaljam := Format('030000T');
                end;
            }
            trigger OnPreDataItem()
            begin
                fromDate := CalcDate('-CM', Tanggal);
                toDate := CalcDate('CM', Tanggal);
            end;

            trigger OnAfterGetRecord()
            var
                recPositionLedEntry: Record "Position Ledger Entry";
            begin
                recPositionLedEntry.Reset();
                recPositionLedEntry.SetRange("Employee No.", "No.");
                if recPositionLedEntry.FindLast() then begin
                    // efektiveDate := recPositionLedEntry."Contract Start Date";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    field(Tanggal; Tanggal)
                    {
                        Caption = 'Filter Month & Year';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Employeename: text;
        Divisi: text;
        totaljam: text;
        Tanggal: date;
        fromDate: date;
        toDate: date;
        efektiveDate: date;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    local procedure GetEmployee(EmployeeNo: Text): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then begin
            Employeename := Employee.FullName();
            Divisi := Employee."Job Title";
        end;
    end;
}