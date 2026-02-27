codeunit 60000 "Headline RC HRIS"
{
    trigger OnRun()
    var
        HeadlineRCHRIS: Record "Headline RC HRIS";

    begin
        HeadlineRCHRIS.Get();
        WorkDate := HeadlineRCHRIS."Workdate for computations";
        OnComputeHeadlines();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnComputeHeadlines()
    begin
    end;

}