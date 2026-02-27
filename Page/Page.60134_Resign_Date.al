page 60134 "Input Resign Date"
{
    PageType = StandardDialog;
    UsageCategory = Administration;
    Caption = 'Input Resign/Termination Date';

    layout
    {
        area(Content)
        {
            field(EmployeeInfo; EmployeeInfo)
            {
                ShowCaption = false;
                Editable = false;
                ApplicationArea = all;
                Style = StrongAccent;
                StyleExpr = true;
            }
            group(GroupName)
            {
                field(ResignDate; ResignDate)
                {
                    Caption = 'Resign Date';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger
    OnOpenPage()
    var
        Employee: Record Employee;
    begin
        Employee.Get(NomorKuli);
        EmployeeInfo := Employee."No." + ' - ' + Employee.FullName();

        HiringInfo.Get(NomorKuli, NomorEntryCareerInfo);
        ResignDate := HiringInfo."Resign Date";
    end;

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then begin
            HiringInfo.Get(NomorKuli, NomorEntryCareerInfo);
            if (ResignDate <> 0D) and (ResignDate <= HiringInfo."Contract Start Date") then
                Error('Resign date must be bigger than contract start date.');

            HiringInfo."Resign Date" := ResignDate;
            HiringInfo.Modify();
        end else begin
            Message('No records updated.');
        end;
    end;


    procedure setRecord(EmpNo: Code[20]; HiringEntryNo: Integer)
    begin
        NomorKuli := EmpNo;
        NomorEntryCareerInfo := HiringEntryNo;
    end;

    var
        NomorEntryCareerInfo: Integer;
        NomorKuli: Code[20];
        EmployeeInfo: Text;
        HiringInfo: Record "Position Ledger Entry";
        ResignDate: Date;
}