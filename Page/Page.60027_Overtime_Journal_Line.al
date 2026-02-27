page 60027 "Overtime Journal Line"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Overtime Journal Line";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    var
                        EmployeeLocal: Record Employee;
                    begin
                        EmployeeLocal.Get(Rec."Employee No.");
                        NamaKaryawan := EmployeeLocal.FullName();
                    end;
                }
                field(Name; NamaKaryawan)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    procedure GetPostingDate(_PostingDate: Date);
    begin
        PostingDateGitu := _PostingDate;
    end;

    var
        PostingDateGitu: date;
        NamaKaryawan: Text[100];

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Posting Date" := PostingDateGitu;
    end;
}