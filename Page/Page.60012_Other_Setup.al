page 60012 "Other Setup"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payroll General Setup";
    DataCaptionExpression = 'Setup';

    layout
    {
        area(Content)
        {
            group("Biaya Jabatan")
            {
                field("Yearly Brutto Inc. Percentage"; Rec."Yearly Brutto Inc. Percentage")
                {
                    ApplicationArea = all;
                }
                field("Monthly Max Income"; Rec."Monthly Max Income")
                {
                    ApplicationArea = all;
                }
                field("Yearly Max Income"; Rec."Yearly Max Income")
                {
                    ApplicationArea = all;
                }
            }
            group("Dimension")
            {
                field("Shortcut Dimension Code Used"; Rec."Shortcut Dimension Code Used")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Dimension Code"; StrDimension)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Department; rec.Department)
                {
                    ApplicationArea = all;
                }
            }
            group(Numbering)
            {
                field("Paid Leave Request Nos."; Rec."Paid Leave Request Nos.")
                {
                    ApplicationArea = all;
                }
                field("Unpaid Leave Request Nos."; Rec."Unpaid Leave Request Nos.")
                {
                    ApplicationArea = all;
                }
                field("Other Attendance Request Nos."; rec."Other Attendance Request Nos.")
                {
                    ApplicationArea = all;
                }
                field("Employee Charging Nos."; Rec."Employee Charging Nos.")
                {
                    ApplicationArea = all;
                }
                field("Overtime Nos."; Rec."Overtime Nos.")
                {
                    ApplicationArea = all;
                }
                field("CTO Nos."; Rec."CTO Nos.")
                {
                    ApplicationArea = all;
                }
                field("CTO Realization Nos."; Rec."CTO Realization Nos.")
                {
                    ApplicationArea = all;
                }
                field("Medical Reimbursement Nos."; Rec."Medical Reimbursement Nos.")
                {
                    ApplicationArea = all;
                }
                field("Unconditional Leave Nos."; Rec."Unconditional Leave Nos.")
                {
                    ApplicationArea = all;
                }
                field("Attendance Nos."; rec."Attendance Nos.")
                {
                    ApplicationArea = all;
                }
                field("Severance Nos."; Rec."Severance Nos.")
                {
                    ApplicationArea = all;
                }
                field("Cuti Dibayar Nos."; Rec."Cuti Dibayar Nos.")
                {
                    ApplicationArea = all;
                }
            }
            group(Other)
            {
                field(Live; Rec.Live)
                {
                    ApplicationArea = all;
                }
                field("Activate Approval"; Rec."Activate Approval")
                {
                    ApplicationArea = all;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = all;
                }
                field("Base Calendar Shift-1"; rec."Base Calendar Shift-1")
                {
                    Caption = 'Shift Sore';
                    ApplicationArea = all;
                }
                field("Base Calendar Shift-2"; rec."Base Calendar Shift-2")
                {
                    Caption = 'Shift Malam';
                    ApplicationArea = all;
                }
            }
            group("Clock Schedule")
            {
                field("Working Start"; rec."Working Start")
                {
                    ApplicationArea = all;
                }
                field("Working Out"; rec."Working Out")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        StrDimension: Code[20];
        GeneralLedgerSetup: Record "General Ledger Setup";

    trigger
    OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    trigger
    OnAfterGetRecord()
    begin
        GeneralLedgerSetup.Get();
        case Rec."Shortcut Dimension Code Used" of
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 1 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 2 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 3 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 3 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 4 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 5 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 6 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 7 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension Code Used"::"Shortcut Dimension 8 Code":
                StrDimension := GeneralLedgerSetup."Shortcut Dimension 8 Code";
        end;
    end;
}