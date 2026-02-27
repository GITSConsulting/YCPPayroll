page 60111 "Process THR Page"
{
    Caption = 'Process THR/13th Salary';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Process THR Setup Table";
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
                    Caption = 'Tanggal Hari Raya/13th Salary';
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
                        Caption = 'To Be Processed THR/13th Salary';
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
                        Error('Tanggal hari raya must be filled by calculating THR Amount.');

                    if PostingDateLastPayroll = 0D then
                        Error('There is no data for last payroll.');

                    if Rec.PostingDate < PostingDateLastPayroll then
                        Error('Tanggal Hari Ray must be equal or bigger than last payroll date.');

                    if not Confirm(Judul + '\Are you sure to continue?') then exit;

                    Window.Open('Posting....please wait..');

                    if isMuslim then begin
                        Filternya := 2;
                        OpsiDisbursement := 1
                    end else begin
                        Filternya := 3;
                        OpsiDisbursement := 2;
                    end;

                    THRPost.LoopEmployeeForTHR(EmployeeTHR, Rec.PostingDate, PostingDateLastPayroll,
                    OpsiDisbursement, StrGPDocNo, StrGPTaxDocNo);
                    Window.Close();

                    Message('THR process period: %1\With %2 employee is completed.\' + StrGPDocNo + StrGPTaxDocNo,
                             FORMAT(Rec.PostingDate, 0, '<Day> <Month Text> <Year>'), ToBeProcessedTHR);

                    CurrPage.Close();
                    SingleInstance.SetFilterList(Filternya);
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
        OpsiDisbursement: Integer;
        PleaseBeInformed: Text;
        THRList: Page "THR List";
        SingleInstance: Codeunit SingleInstanceDRE;
        Filternya: Integer;

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if isMuslim then
            Filternya := 2
        else
            Filternya := 3;

        SingleInstance.SetFilterList(Filternya);
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

        if isMuslim then begin
            EmployeeTHR.SetRange("With Muslim THR Disbursement", true);
            Judul := 'This will process employees with muslim THR disbursement.';
        end else begin
            EmployeeTHR.SetRange("With Muslim THR Disbursement", false);
            Judul := 'This will process employees with non-muslim THR disbursement.';
        end;
        EmployeeTHR.FindSet();

        ToBeProcessedTHR := EmployeeTHR.Count;
        PleaseBeInformed := 'Please be informed that the baseline for calculation is last payroll date: ' +
                            Format(PostingDateLastPayroll, 0, '<Day> <Month Text> <Year4>');

    end;

    procedure checkIsMuslim(IdulFitri: Boolean; TanggalGajianTerakhir: Date)
    begin
        isMuslim := IdulFitri;
        PostingDateLastPayroll := TanggalGajianTerakhir;
    end;

}