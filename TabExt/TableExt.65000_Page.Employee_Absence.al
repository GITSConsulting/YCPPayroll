tableextension 65000 "Employee Absence" extends "Employee Absence"
{
    fields
    {
        field(65000; "Time From"; Time)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Time From" <> xRec."Time From" then begin
                    "Time To" := 0T;
                    "Duration (Day)" := 0;
                    "Duration (Hour)" := 0;
                    "Duration (Minute)" := 0;
                end;
            end;
        }
        field(65001; "Time To"; Time)
        {
            DataClassification = CustomerContent;
            trigger
           OnValidate()
            var
                LeaveMgt: Codeunit "Leave Management";
                lamaJam: Integer;
                lamaMenit: Integer;
                jamTerlambat: Integer;
                menitTerlambat: Integer;
            begin
                TestField("Time From");

                if "Time To" <= "Time From" then
                    Error('Time To must be bigger than Time From.');

                LeaveMgt.hitungDurasi("Time From", "Time To", lamaJam, lamaMenit);

                "Duration (Hour)" := lamaJam;
                "Duration (Minute)" := lamaMenit;

                hitungDurasiTerlambat("Time From", "Time To", jamTerlambat, menitTerlambat);
                if (menitTerlambat > 0) then begin
                    "Late Duration (Hours)" := jamTerlambat - 1;
                    if 60 - menitTerlambat = 60 then
                        "Late Duration (Minutes)" := 0
                    else
                        "Late Duration (Minutes)" := 60 - menitTerlambat;
                end else begin
                    "Late Duration (Hours)" := jamTerlambat;
                    if 60 - menitTerlambat = 60 then
                        "Late Duration (Minutes)" := 0
                    else
                        "Late Duration (Minutes)" := 60 - menitTerlambat;
                end;
            end;
        }
        field(65002; "Late Duration (Minutes)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65003; "Late Duration (Hours)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65004; "Total Work Hours"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(65005; "Day"; integer)
        {
            DataClassification = CustomerContent;
        }
        field(65006; "Duration (Day)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65007; "Duration (Hour)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65008; "Duration (Minute)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65009; "Created User ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(65010; "Approver ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(65011; "Description By Employee"; text[100])
        {
            DataClassification = CustomerContent;
        }
    }
    procedure hitungDurasiTerlambat(startingTime: Time; endingTime: Time;
    var intJamLambat: Integer; var intMenitLambat: Integer)
    var
        Selisih: BigInteger;
    begin
        Selisih := endingTime - startingTime;

        intJamLambat := Quantity - Selisih div (60 * 60 * 1000);
        intMenitLambat := (Selisih mod (60 * 60 * 1000)) div (60 * 1000);
    end;

    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;

    trigger OnAfterInsert()
    var
        // Employee: Record Employee;
        ved: page "Absence Registration";
    begin
        // Employee.SETRANGE("User ID", USERID);
        // Employee.FINDFIRST;
        // "Employee No." := Employee."No.";
        "Created User ID" := UserId;

        rec."From Date" := Today;
        rec.Day := 1;
        rec.Quantity := 8;
        rec."Time From" := Time;
    end;
}