codeunit 60001 "Progress Bar"
{
    trigger OnRun()
    begin

    end;

    var
        Window: Dialog;
        RefPostingState: enum RefPostingState;

    procedure UpdatePostingState(PostingState: Integer; LineNo: Integer)
    begin
        Window.UPDATE(3, STRSUBSTNO('%1 (%2)', GetPostingStateMsg(PostingState), LineNo));
    end;

    procedure UpdateDialog()
    var
        PostingState: Integer;
        LineNo: Integer;
        TotalLinesQty: Integer;
    begin
        UpdatePostingState(PostingState, LineNo);
        Window.UPDATE(2, GetProgressBarValue(PostingState, LineNo, TotalLinesQty));
    end;

    procedure GetPostingStateMsg(PostingState: Integer): Text
    begin
        CASE PostingState OF
            0:
                EXIT('Preparing employee');
            1:
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

    LOCAL procedure GetNumberOfPostingStages(): Integer
    begin
        EXIT(1);
    end;
}