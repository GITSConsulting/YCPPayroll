table 65024 "clock schedule"
{
    DataClassification = ToBeClassified;
    // DrillDownPageID = "Clock Schedule";
    // LookupPageID = "Clock Schedule";

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Starting Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Starting Date" <> 0D then
                    if "Ending Date" <> 0D then
                        if "Ending Date" < "Starting Date" then
                            Error('Ending period date cannot be smaller than starting period date.');
            end;
        }
        field(3; "Ending Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Ending Date" <> 0D then
                    if "Starting Date" <> 0D then
                        if "Ending Date" < "Starting Date" then
                            Error('Ending period date cannot be smaller than starting period date.');
            end;
        }
        field(4; "Working Start"; time)
        {
            trigger OnValidate()
            var
                PayrollGeneralSetup: Record "Payroll General Setup";
                TotalNormalTime: Duration;
                TotalPeriodeTime: Duration;
            begin
                if ("Working Start" <> 0T) and ("Working Out" <> 0T) then begin

                    PayrollGeneralSetup.FindSet();

                    if (PayrollGeneralSetup."Working Start" <> 0T) and (PayrollGeneralSetup."Working Out" <> 0T) then
                        TotalNormalTime := PayrollGeneralSetup."Working Out" - PayrollGeneralSetup."Working Start";

                    TotalPeriodeTime := "Working Out" - "Working Start";

                    "Total Time Duration" := TotalNormalTime - TotalPeriodeTime;
                    "Total Time Hours" := (TotalNormalTime - TotalPeriodeTime) div (60 * 60 * 1000);
                    "Total Time Minutes" := ((TotalNormalTime - TotalPeriodeTime) mod (60 * 60 * 1000)) div (60 * 1000);

                end;
            end;
        }
        field(5; "Working Out"; time)
        {
            trigger OnValidate()
            var
                PayrollGeneralSetup: Record "Payroll General Setup";
                TotalNormalTime: Duration;
                TotalPeriodeTime: Duration;
                timeee: time;
            begin
                if ("Working Start" <> 0T) and ("Working Out" <> 0T) then begin

                    PayrollGeneralSetup.FindSet();

                    if (PayrollGeneralSetup."Working Start" <> 0T) and (PayrollGeneralSetup."Working Out" <> 0T) then
                        TotalNormalTime := PayrollGeneralSetup."Working Out" - PayrollGeneralSetup."Working Start";

                    TotalPeriodeTime := "Working Out" - "Working Start";
                    "Total Time Duration" := TotalNormalTime - TotalPeriodeTime;
                    "Total Time Hours" := (TotalNormalTime - TotalPeriodeTime) div (60 * 60 * 1000);
                    "Total Time Minutes" := ((TotalNormalTime - TotalPeriodeTime) mod (60 * 60 * 1000)) div (60 * 1000);

                end;
            end;
        }
        field(6; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(7; "Total Time Hours"; Decimal)
        {

        }
        field(8; "Total Time Minutes"; Decimal)
        {

        }
        field(9; "Total Time Duration"; Duration)
        {

        }

    }

    keys
    {
        key(PK; "Starting Date", "Ending Date", "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;

}

