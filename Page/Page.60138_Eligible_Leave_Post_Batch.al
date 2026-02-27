page 60138 "Eligible Leave Post Batch"
{
    PageType = StandardDialog;
    UsageCategory = Administration;
    Caption = 'Eligible Leave Post Batch';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field(EmployeeType; EmployeeType)
                {
                    Caption = 'Employee Type';
                    ApplicationArea = All;
                    OptionCaption = 'Staff,TDP';
                }
                field(Period; Period)
                {
                    Caption = 'Pick Period';
                    ApplicationArea = All;
                    trigger
                    OnValidate()
                    begin
                        PeriodText := Format(Period, 0, '<Month Text> <Year4>');
                    end;
                }
                field(PeriodText; PeriodText)
                {
                    Caption = 'Month';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Leave Slot"; 1.25)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(TotalActive; TotalActive)
                {
                    Caption = 'Active Employees';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Window: Dialog;
        StrConfirm: Text;
        Pegawai: Record Employee;
        LeaveMgt: Codeunit "Leave Management";
    begin
        StrConfirm := 'This will process eligible leave of period ' + PeriodText +
                      ' for ' + format(TotalActive) + ' employees.\' +
                      'Proceed?';

        if CloseAction = CloseAction::OK then begin
            if not Confirm(StrConfirm) then exit;

            Window.Open('Processing...please wait.');

            Pegawai.Reset();
            Pegawai.SetRange(Status, Pegawai.Status::Active);
            Pegawai.SetRange("Employee Type", EmployeeType);
            Pegawai.FindSet();

            repeat
                LeaveMgt.InsertEligibleLeaveLedgerEntry(Period, Pegawai, false, '', false);
            until Pegawai.Next() = 0;

            Window.Close();
            Message('Successfully posted.');
        end else
            Message('Process cancelled.');
    end;


    trigger OnOpenPage()
    begin
        Employee.Reset();
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.FindSet();
        TotalActive := Employee.Count;
    end;


    var
        Period: Date;
        PeriodText: Text;
        Employee: Record Employee;
        TotalActive: Integer;
        EmployeeType: Option "Staff","TDP";
}