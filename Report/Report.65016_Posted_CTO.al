report 65016 "Posted CTO Form"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65003_Compensatory_Time_Off_(CTO)_FORM.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Posted CTO Request Header"; "Posted CTO Request Header")
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Document_Date; "Document Date") { }
            column(Departemen; _Departemen) { }
            column(jobTitle; _jobTitle) { }
            column(NameEmployee; _NameEmployee) { }
            column(Position_Lokasi; _Position) { }
            column(NIK; _NIK) { }

            dataitem("Posted CTO Request Line"; "Posted CTO Request Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(Work_Description; "Work Description") { }
                column(Starting_Time; "Starting Time") { }
                column(Ending_Time; "Ending Time") { }
                column(Task_Date; "Task Date") { }
                column(Duration__Day_; "Duration (Day)") { }
                column(Duration__Hour_; "Duration (Hour)") { }
                column(Duration__Minute_; "Duration (Minute)") { }
            }
            trigger OnAfterGetRecord()
            var
                recEmployee: Record Employee;
                recLocation: Record "Dimension Value";
                recLocation2: Record "Dimension Value";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                PayrollGeneralSetup.Get();
                recEmployee.Reset();
                recEmployee.SetRange("No.", "Employee No.");
                if recEmployee.FindFirst() then begin

                    _jobTitle := recEmployee."Job Title";
                    _NameEmployee := recEmployee.FullName();

                    recLocation.Reset();
                    recLocation.SetRange(Code, recEmployee."Office Location Code");
                    recLocation.SetRange("Dimension Code", 'AREA');
                    if recLocation.FindFirst() then
                        _Position := recLocation.Name;

                    recLocation2.Reset();
                    recLocation2.SetRange(Code, recEmployee."MSI_HRIS Department");
                    recLocation2.SetRange("Dimension Code", PayrollGeneralSetup.Department);
                    if recLocation2.FindFirst() then
                        _Departemen := recLocation2.Name;

                end;
            end;
        }
    }

    var
        CompanyInformation: Record "Company Information";
        // g2
        _jobTitle: Text;
        _Position: Text;
        _NameEmployee: Text;
        _Departemen: Text;
        _LokasiTugas: Text;
        _NIK: Text;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}