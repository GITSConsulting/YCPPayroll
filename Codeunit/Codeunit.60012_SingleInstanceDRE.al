codeunit 60012 SingleInstanceDRE
{
    SingleInstance = true;


    procedure SetFilterList(FilterListKiriman: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation")
    begin
        FilterList := FilterListKiriman;
    end;

    procedure GetFilterList(var FilterListKirimBalik: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation")
    begin
        FilterListKirimBalik := FilterList;
    end;



    var
        FilterList: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation";
}