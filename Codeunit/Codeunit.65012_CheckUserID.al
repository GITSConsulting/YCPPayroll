codeunit 65012 "Check UserID"
{
    procedure CheckUserIDnya(Nonya: Code[20])
    var
        frz_rec_Employee: Record Employee;
        frz_rec_Employee2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin

            frz_rec_Employee.Reset();
            frz_rec_Employee.SetRange("User ID", UserId);
            if frz_rec_Employee.FindFirst() then begin
                if frz_rec_Employee."No." <> Nonya then begin

                    frz_rec_Employee2.Reset();
                    frz_rec_Employee2.SetRange("No.", Nonya);
                    if frz_rec_Employee2.FindFirst() then begin
                        if frz_rec_Employee2."MSI_HRIS Admin By" <> UserId then begin
                            error('This Employee not match for your user id');
                        end;
                    end;

                end;

            end else begin
                frz_rec_Employee2.Reset();
                frz_rec_Employee2.SetRange("No.", Nonya);
                if frz_rec_Employee2.FindFirst() then begin
                    if frz_rec_Employee2."MSI_HRIS Admin By" <> UserId then begin
                        error('This Employee not match for your user id');
                    end;
                end;
            end;
        end;
    end;
}