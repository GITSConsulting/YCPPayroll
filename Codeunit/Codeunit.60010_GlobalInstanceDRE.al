codeunit 60010 GlobalInstanceDRE
{
    SingleInstance = true;

    trigger OnRun()
    begin

    end;

    var
        NewReset: Boolean;
        NewUserName: Code[50];
        NewCombFilter: Text;
        NewDimCode: Code[20];
        NewChartDate1: Date;
        NewDocNo: Text;
        NewRequestorName: Text[100];
        NewAmount: Decimal;
        NewTextDocno: Text;
        NewTextDocno2: Text;
        NewTextname: Text;
        NewPeriodNum: Integer;
        NewFirstEntryNoDeletedRec: Integer;
        SkipValidateCreateApprovalAdvanceGroup: Boolean;
        NewFilterFileName: Text;
        NewFilterReportType: Text;
        NewFilterFundCode: Text;
        NewFilterRequestor: Text;

    procedure SetFilterRequestor(_NewFilterRequestor: Text)
    begin
        NewFilterRequestor := _NewFilterRequestor;
    end;

    procedure GetFilterRequestor(): Text
    begin
        EXIT(NewFilterRequestor);
    end;

    procedure SetFilterFileName(_NewFilterFileName: Text)
    begin
        NewFilterFileName := _NewFilterFileName;
    end;

    procedure GetFilterFileName(): Text
    var
        _Saying: Codeunit Saying;
    begin
        EXIT('*' + NewFilterFileName + '*|*' + UpperCase(NewFilterFileName) + '*|*' +
            _Saying.MakeCamelCaseText(NewFilterFileName) + '*');
    end;

    procedure SetFilterFundCode(_NewFilterFundCode: Text)
    begin
        NewFilterFundCode := _NewFilterFundCode;
    end;

    procedure GetFilterFundCode(): Text
    begin
        EXIT(NewFilterFundCode);
    end;

    procedure SetFilterReportType(_NewFilterReportType: Text)
    begin
        NewFilterReportType := _NewFilterReportType;
    end;

    procedure GetFilterReportType(): Text
    begin
        EXIT(NewFilterReportType);
    end;

    procedure SetSkipValidateCreateApprovalAdvanceGroup(Value: Boolean)
    begin
        SkipValidateCreateApprovalAdvanceGroup := Value;
    end;

    procedure GetSkipValidateCreateApprovalAdvanceGroup(): Boolean
    begin
        exit(SkipValidateCreateApprovalAdvanceGroup);
    end;

    procedure SetFirstEntryNoDeletedRec(_NewFirstEntryNoDeletedRec: Integer)
    begin
        NewFirstEntryNoDeletedRec := _NewFirstEntryNoDeletedRec;
    end;

    procedure GetNewFirstEntryNoDeletedRec(): Integer
    begin
        exit(NewFirstEntryNoDeletedRec);
    end;

    procedure SetActive(_NewReset: Boolean)
    begin
        NewReset := _NewReset;
    end;

    procedure GetActive(): Boolean
    begin
        EXIT(NewReset);
    end;

    procedure SetUserName(_NewUserName: Code[50])
    begin
        NewUserName := _NewUserName;
    end;

    procedure GetUserName(): Code[50]
    begin
        EXIT(NewUserName);
    end;

    procedure SetChartDate1(_NewChartDate1: Date)
    begin
        NewChartDate1 := _NewChartDate1;
    end;

    procedure GetChartDate1(): Date
    begin
        EXIT(NewChartDate1);
    end;
}

