page 60127 "Process THR Compensation Page"
{
    Caption = 'Process THR/13th Compensation';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Process THR Compensation Table";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(PleaseBeInformed; PleaseBeInformed)
            {
                ShowCaption = false;
                Editable = false;
                ApplicationArea = all;
                Style = StrongAccent;
                StyleExpr = true;
            }
            group(GENERAL)
            {
                field(PostingDate; Rec.PostingDate)
                {
                    Caption = 'THR Compensation Date';
                    ApplicationArea = All;
                    //Editable = false;
                }
            }
            group("EMPLOYEES RECAP")
            {
                group(atas)
                {
                    ShowCaption = false;
                    field(AllActive; AllActive)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'All Active Employee';
                    }
                }
                group(bawah)
                {
                    ShowCaption = false;
                    field(ToBeProcessedTHR; ToBeProcessedTHR)
                    {
                        ApplicationArea = all;
                        Editable = false;
                        Caption = 'THR Compensation to be Processed';
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = all;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Window: Dialog;
                    StrGPDocNo: Text;
                    StrGPTaxDocNo: Text;
                begin
                    if Rec.PostingDate = 0D then
                        Error('Compensation date must be filled by calculating THR Amount.');

                    if PostingDateLastPayroll = 0D then
                        Error('There is no data for last payroll.');

                    if Rec.PostingDate < PostingDateLastPayroll then
                        Error('THR compensation date must be equal or bigger than last payroll date.');

                    if not Confirm(Judul + '\Are you sure to continue?') then exit;

                    Window.Open('Posting....please wait..');
                    THRPost.LoopEmployeeForTHR(EmployeeTHR, Rec.PostingDate, PostingDateLastPayroll, 3,
                    StrGPDocNo, StrGPTaxDocNo);
                    Window.Close();

                    Message('THR compensation period: %1\With %2 employee is completed.\' + StrGPDocNo + StrGPTaxDocNo,
                             FORMAT(Rec.PostingDate, 0, '<Day> <Month Text> <Year>'), ToBeProcessedTHR);

                    CurrPage.Close();
                    SingleInstance.SetFilterList(4);
                    THRList.Run();
                end;
            }
        }
    }

    var
        THRPost: Codeunit "THR Post";
        isMuslim: Boolean;
        AllActive: Integer;
        ToBeProcessedTHR: Integer;
        EmployeeTHR: Record Employee;
        Judul: Text;
        PostingDateLastPayroll: Date;
        PleaseBeInformed: Text;
        THRList: Page "THR List";
        SingleInstance: Codeunit SingleInstanceDRE;


    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    begin
        SingleInstance.SetFilterList(4);
        THRList.Run();
    end;


    trigger
    OnOpenPage()
    begin
        EmployeeTHR.Reset();
        EmployeeTHR.SetRange(Status, EmployeeTHR.Status::Active);
        EmployeeTHR.SetFilter("First Name", '<>MSI');
        EmployeeTHR.FindSet();
        AllActive := EmployeeTHR.Count;

        Judul := 'This will process THR compensation, ';

        EmployeeTHR.SetRange("MSI_HRIS THR Compensation", true);
        EmployeeTHR.FindSet();

        ToBeProcessedTHR := EmployeeTHR.Count;
        PleaseBeInformed := 'Please be informed that the baseline for calculation is last payroll date: ' +
                            Format(PostingDateLastPayroll, 0, '<Day> <Month Text> <Year4>');

    end;

    procedure SetTanggalTerakhirPayroll(TanggalGajianTerakhir: Date)
    begin
        PostingDateLastPayroll := TanggalGajianTerakhir;
    end;

}