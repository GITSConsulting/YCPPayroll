codeunit 65015 EventSubscribe
{
    [EventSubscriber(ObjectType::Page, Page::"Base Calendar Entries Subform", 'OnAfterValidateEvent', 'Nonworking', false, false)]
    local procedure UpdateBaseCalendarChangesNonWorking(var Rec: Record "Customized Calendar Change"; xRec: Record "Customized Calendar Change")
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", Rec."Base Calendar Code");
        BaseCalendarChange.SetRange(Date, Rec.Date);
        if BaseCalendarChange.FindFirst then
            BaseCalendarChange.Delete();
        BaseCalendarChange.Init();
        BaseCalendarChange."Base Calendar Code" := Rec."Base Calendar Code";
        BaseCalendarChange.Date := Rec.Date;
        BaseCalendarChange.Description := Rec.Description;
        BaseCalendarChange.Nonworking := Rec.Nonworking;
        BaseCalendarChange.Day := Rec.Day;
        BaseCalendarChange.WFH := Rec.WFH;
        OnUpdateBaseCalendarChanges(BaseCalendarChange);
        BaseCalendarChange.Insert();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Base Calendar Entries Subform", 'OnAfterValidateEvent', 'WFH', false, false)]
    local procedure UpdateBaseCalendarChangesWFH(var Rec: Record "Customized Calendar Change"; xRec: Record "Customized Calendar Change")
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", Rec."Base Calendar Code");
        BaseCalendarChange.SetRange(Date, Rec.Date);
        if BaseCalendarChange.FindFirst then
            BaseCalendarChange.Delete();
        BaseCalendarChange.Init();
        BaseCalendarChange."Base Calendar Code" := Rec."Base Calendar Code";
        BaseCalendarChange.Date := Rec.Date;
        BaseCalendarChange.Description := Rec.Description;
        BaseCalendarChange.Nonworking := Rec.Nonworking;
        BaseCalendarChange.Day := Rec.Day;
        BaseCalendarChange.WFH := Rec.WFH;
        OnUpdateBaseCalendarChanges(BaseCalendarChange);
        BaseCalendarChange.Insert();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Base Calendar Entries Subform", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure UpdateBaseCalendarChangesDes(var Rec: Record "Customized Calendar Change"; xRec: Record "Customized Calendar Change")
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", Rec."Base Calendar Code");
        BaseCalendarChange.SetRange(Date, Rec.Date);
        if BaseCalendarChange.FindFirst then
            BaseCalendarChange.Delete();
        BaseCalendarChange.Init();
        BaseCalendarChange."Base Calendar Code" := Rec."Base Calendar Code";
        BaseCalendarChange.Date := Rec.Date;
        BaseCalendarChange.Description := Rec.Description;
        BaseCalendarChange.Nonworking := Rec.Nonworking;
        BaseCalendarChange.Day := Rec.Day;
        BaseCalendarChange.WFH := Rec.WFH;
        OnUpdateBaseCalendarChanges(BaseCalendarChange);
        BaseCalendarChange.Insert();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateBaseCalendarChanges(var BaseCalendarChange: Record "Base Calendar Change")
    begin
    end;
}