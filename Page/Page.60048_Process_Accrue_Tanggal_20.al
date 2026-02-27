page 60048 "Process Accrue Tanggal 20"
{
    PageType = Card;
    UsageCategory = Administration;
    //ApplicationArea = all;

    layout
    {
        area(Content)
        {
            group("Please enter the posting date")
            {
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    ApplicationArea = all;
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
                    PayrollSetup: Record "Payroll General Setup";
                    EmployeeLocal: Record Employee;
                    OvertimeJnlLine: Record "Overtime Journal Line";
                    DimValEmployee: Record "Dimension Value Employee" temporary;
                    StrGetFilters: Text[100];
                begin
                    if PostingDate = 0D then
                        Error('Please fill the posting date.');

                    PayrollSetup.Get();
                    PayrollSetup.TestField("Salary Expense Acc. No.");

                    if not Confirm('Proceed with the salary accrue process?') then exit;

                    EmployeeGlobal.Reset();
                    EmployeeGlobal.SetFilter("MSI_HRIS Basic Salary", '>0');
                    EmployeeGlobal.FindFirst();
                    window.Open(ProgressBar2);

                    LineCount := 0;
                    NoOfRecords := EmployeeGlobal.COUNT;

                    Clear(DimValEmployee);

                    REPEAT
                        LineCount := LineCount + 1;
                        Bar := ROUND(100 * (100 * (LineCount / NoOfRecords)), 1);
                        Window.UPDATE(1, EmployeeGlobal."No.");
                        Window.UPDATE(2, EmployeeGlobal.FullName());
                        Window.UPDATE(3, Bar);
                        //proses calculate
                        CalculateAccrueNet.LoopThroughEmployee(EmployeeGlobal, Post, PostingDate, false, false);

                        //proses kosongin table overtime journal line, kalo ada isinya
                        //terhadap employee yg sedang looping.
                        OvertimeJnlLine.Reset();
                        OvertimeJnlLine.SetRange("Employee No.", EmployeeGlobal."No.");
                        OvertimeJnlLine.SetRange("Posting Date", PostingDate);
                        if OvertimeJnlLine.FindSet() then
                            OvertimeJnlLine.DeleteAll();

                    UNTIL EmployeeGlobal.NEXT = 0;

                    Window.Close();
                    CurrPage.Close();
                end;
            }
        }
    }



    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF NOT Post THEN
            IF NOT Confirm('Exit without post?') THEN error('');
    end;

    var
        CaptionPage: Text[50];
        CaptionGroup: text[50];
        PostingDate: date;
        Post: Boolean;
        EmployeeGlobal: Record Employee;
        CalculateAccrueNet: Codeunit "Calculate Accrue Net Salary";

        Window: Dialog;
        RefPostingState: Option string,"Preparing employee","Posting payroll";
        LineCount: Integer;
        NoOfRecords: Integer;
        CUProgressBar: Codeunit "Progress Bar";
        Bar: Integer;
        EmployeeNo: array[10000] of code[20];
        i: Integer;
        ProgressBar: Label 'Preparing employee @2@@@@@@@@@@@@@@@@@@';
        ProgressBar2: Label 'Calculating #1##############\\#2############################\\@3@@@@@@@@@@@@@@@@@@';
        isTHR: Boolean;

    procedure GetSelectedEmployee(VAR EmployeeLocal: Record Employee; ApakahTHR: Boolean)
    begin
        isTHR := ApakahTHR;

        EmployeeLocal.FINDFIRST;

        Window.OPEN(ProgressBar);

        LineCount := 0;
        NoOfRecords := EmployeeLocal.COUNT;

        REPEAT
            LineCount := LineCount + 1;
            EmployeeNo[LineCount] := EmployeeLocal."No.";
            Bar := ROUND(100 * (100 * (LineCount / NoOfRecords)), 1);
            Window.UPDATE(2, Bar);
            EmployeeGlobal.INIT;
            EmployeeGlobal.TRANSFERFIELDS(EmployeeLocal);
            EmployeeGlobal.INSERT;
        UNTIL EmployeeLocal.NEXT = 0;

        Window.CLOSE;
    end;

    procedure UpdatePostingState(PostingState: Integer; LineNo: Integer)
    begin
        Window.UPDATE(3, STRSUBSTNO('%1 (%2)', GetPostingStateMsg(PostingState), LineNo));
    end;

    procedure UpdateDialog(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer)
    begin
        UpdatePostingState(PostingState, LineNo);
        Window.UPDATE(2, GetProgressBarValue(PostingState, LineNo, TotalLinesQty));
    end;

    procedure GetPostingStateMsg(PostingState: Integer): Text
    begin
        CASE PostingState OF
            RefPostingState::"Preparing employee":
                EXIT('Preparing employee');
            RefPostingState::"Posting payroll":
                EXIT('Posting payroll');
        END;
    end;

    procedure GetProgressBarValue(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer): Integer
    begin
        EXIT(ROUND(100 * CalcProgressPercent(PostingState, GetNumberOfPostingStages, LineNo, TotalLinesQty), 1));
    end;

    procedure CalcProgressPercent(PostingState: Integer; NumberOfPostingStates: Integer; LineNo: Integer; TotalLinesQty: Integer): Decimal
    begin
        EXIT(100 / NumberOfPostingStates * (PostingState + LineNo / TotalLinesQty));
    end;

    local procedure GetNumberOfPostingStages(): Integer
    begin
        EXIT(1);
    end;
}