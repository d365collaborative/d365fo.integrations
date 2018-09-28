update dbo.BatchJob
set ORIGSTARTDATETIME = DATEFROMPARTS(year(getdate()),01,01)
,RECVERSION = RECVERSION +1 output deleted.CAPTION
where caption like 'Batch job for %' + @Name + '%'
and [status] = 1