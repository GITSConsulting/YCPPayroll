report 65029 "Posted Med. Rmb. Claim"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65029_PostedMedicalRmbClaim.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Posted MR Header"; "Posted MR Header")
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(Medical_Type_1; "Medical Type 1") { }
            column(Medical_Type_2; "Medical Type 2") { }
            column(Medical_Type_3; "Medical Type 3") { }
            column(Medical_Type_4; "Medical Type 4") { }
            column(surgical; surgical) { }
            column(jasaPerawatan; jasaPerawatan) { }
            column(Employee_No_; "Employee No.") { }
            column(Date_of_Claim; "Posting Date") { }
            column(Employeename; Employeename) { }
            column(Age_of_Patient; "Age of Patient") { }
            column(Gender; Gender) { }
            column(Name_of_Hospital; "Name of Hospital") { }
            column(Address_of_hospital; "Address of hospital") { }
            column(Hospital_Benefit; "Hospital Benefit") { }
            column(Place_of_Accident; "Place of Accident") { }
            column(Total_Allowance; "Total Allowance") { }
            column(Time; Time) { }
            column(Rekening_no_; "Rekening no.") { }
            column(From_Date; "From Date") { }
            column(To_Date; "To Date") { }
            column(Revision_Date; "Revision Date") { }
            column(type1; type1) { }
            column(type2; type2) { }
            column(type3; type3) { }
            column(type4; type4) { }
            column(siapaPasien1; siapaPasien1) { }
            column(siapaPasien2; siapaPasien2) { }
            column(siapaPasien3; siapaPasien3) { }
            column(getnama1; getnama[1]) { }
            column(getnama2; getnama[2]) { }
            column(getnama3; getnama[3]) { }
            column(getnama4; getnama[4]) { }

            dataitem("Posted MR Line"; "Posted MR Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.") { }
                column(Medical_Value; frz_DescMedicalValues) { }
                column(Medical_Value2; "Medical Value") { }
                column(Claim_Amount; "Paid Amount") { }
                column(Day; "Quantity 2") { }
                column(frz_AmountPerDay; frz_AmountPerDay) { }
                trigger OnAfterGetRecord()
                var
                    frz_MedivalValues: Record "Medical Values";
                begin
                    frz_AmountPerDay := 0;
                    if "Quantity 2" > 0 then
                        frz_AmountPerDay := "Paid Amount" / "Quantity 2";

                    // medical values descriotionnya
                    frz_MedivalValues.Reset();
                    frz_MedivalValues.SetRange(Code, "Posted MR Line"."Medical Value");
                    if frz_MedivalValues.FindFirst() then
                        frz_DescMedicalValues := frz_MedivalValues.Description;
                end;
            }
            trigger OnAfterGetRecord()
            var
                frz_MedicalLines: Record "Posted MR Line";
            begin
                frz_MedicalLines.Reset();
                frz_MedicalLines.SetRange("Document No.", "No.");
                if frz_MedicalLines.FindFirst() then begin
                    if frz_MedicalLines."Rawat Inat Type" = frz_MedicalLines."Rawat Inat Type"::Pembedahan then
                        surgical := true;
                    if frz_MedicalLines."Rawat Inat Type" = frz_MedicalLines."Rawat Inat Type"::"Biaya Jasa Perawatan" then
                        jasaPerawatan := true;
                end;

                GetEmployeeNamee("Employee No.");

                if "Medical Type 1" = true then
                    type1 := true else
                    type1 := false;
                if "Medical Type 2" = true then
                    type2 := true else
                    type2 := false;
                if "Medical Type 3" = true then
                    type3 := true else
                    type3 := false;
                if "Medical Type 4" = true then
                    type4 := true else
                    type4 := false;

                if "Status Patient" = "Status Patient"::Employee then
                    siapaPasien1 := true else
                    siapaPasien1 := false;
                if "Status Patient" = "Status Patient"::"Employee's spouse" then
                    siapaPasien2 := true else
                    siapaPasien2 := false;
                if "Status Patient" = "Status Patient"::"Employee's child" then
                    siapaPasien3 := true else
                    siapaPasien3 := false;

                getnama[1] := 'Optical';
                getnama[2] := 'Outpatient';
                getnama[3] := 'Hospitalization';
                getnama[4] := 'Maternity';
            end;
        }
    }

    var
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        type1: Boolean;
        type2: Boolean;
        type3: Boolean;
        type4: Boolean;
        siapaPasien1: Boolean;
        siapaPasien2: Boolean;
        siapaPasien3: Boolean;
        getnama: array[4] of Text;
        frz_AmountPerDay: Decimal;
        frz_DescMedicalValues: Text;
        Employeename: Text;
        surgical: Boolean;
        jasaPerawatan: Boolean;

    local procedure GetEmployeeNamee(EmployeeNo: Text): Text
    var
        Employee: Record Employee;
    begin
        if Employee.get(EmployeeNo) then begin
            Employeename := Employee.FullName()
        end else begin
            employee.Reset();
            employee.setrange("User ID", UserId);
            if employee.FindFirst() then begin
                Employeename := Employee.FullName();
            end;
        end;
    end;


}