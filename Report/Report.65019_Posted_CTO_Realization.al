report 65019 "Posted CTO Realization"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65018_CTO_Realization.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Posted CTO Realization Header"; "Posted CTO Realization Header")
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employeename; Employeename) { }
            column(Ending_Date; "Ending Date") { }
            column(Starting_Date; "Starting Date") { }
            column(Employee_No__Replacement2; "Employee No. Replacement") { }
            // column(Leave_Type; "Leave Type") { }
            // column(Leave_Type_Code; "Leave Type Code") { }
            column(Posting_Date; "Document Date") { }
            column(Total_Number_of_Days; "Total Number of Days") { }
            // column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Employee_No__Replacement; EmployeenameReplacement) { }
            column(locationwork; locationwork) { }
            column(titleReport; titleReport) { }
            column(divisi; divisi) { }
            column(frz_DescLeaveTypeCode; frz_DescLeaveTypeCode) { }
            trigger OnAfterGetRecord()
            var
                frz_MasterLeave: Record "Master Leave Unconditional";
            begin
                GetEmployeeNamee("Employee No.");
                GetEmployee2("Employee No. Replacement");
                // frz_MasterLeave.Reset();
                // frz_MasterLeave.SetRange(Code, "Leave Type Code");
                // if frz_MasterLeave.FindFirst() then
                //     frz_DescLeaveTypeCode := frz_MasterLeave.Description;

                // GetEmployeeNamee("Employee No.");
                // GetEmployee2("Employee No. Replacement");
                // if "Leave Type" = "Leave Type"::Paid then
                //     titleReport := 'PAID LEAVE';
                // if "Leave Type" = "Leave Type"::Unpaid then
                //     titleReport := 'UNPAID LEAVE';
                // if "Leave Type" = "Leave Type"::"Other Attendance" then
                //     titleReport := 'OTHER ATTENDANCE';
            end;
        }
    }
    var
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        TotalGaji: Decimal;
        Employeename: Text;
        divisi: text;
        locationwork: text;
        EmployeenameReplacement: Text;
        titleReport: text;
        frz_DescLeaveTypeCode: Text;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

    local procedure GetEmployeeNamee(EmployeeNo: Text): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then begin
            locationwork := Employee."Office Location Code";
            divisi := Employee."Job Title";
            Employeename := Employee.FullName()
        end else begin
            employee.Reset();
            employee.setrange("User ID", UserId);
            if employee.FindFirst() then begin
                locationwork := Employee."Office Location Code";
                divisi := Employee."Job Title";
                Employeename := Employee.FullName();
            end;
        end;
    end;

    local procedure GetEmployee2(EmployeeNo: Text): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then begin
            EmployeenameReplacement := Employee.FullName();
        end;
    end;

}