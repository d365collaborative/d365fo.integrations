
update b 
set b.ORIGSTARTDATETIME = DATEFROMPARTS(year(getdate()),01,01)
,RECVERSION = RECVERSION +1
from BATCHJOB b
where b.caption like 'Batch job for %'
and b.[status] = 1

