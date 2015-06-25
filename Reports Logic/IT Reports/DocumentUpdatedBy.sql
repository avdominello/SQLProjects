/* DO NOT COPY THIS SECTION INTO BIDS!!! */
DECLARE @updatedate DATE;
DECLARE @docstatus INT;

SET @updatedate = '2015-01-01';
SET @docstatus = 40;

/* COPY ONLY SQL CODE BELOW THIS LINE INTO REPORT DEFINITION   */
SELECT m.DocumentName
	,m.AlternateName
	,m.DocumentDescription
	,m.StatusUpdatedOn
	,s.DocumentStatusName
	,u.UserId
	,url.DirectoryName
	,url.URL
	,url.URLMappingDesc
FROM DocumentMain m
INNER JOIN UserMain u
	ON m.UpdatedByUserKey = u.UserKey
INNER JOIN DocumentStatusRef s
	ON m.DocumentStatusCode = s.DocumentStatusCode
INNER JOIN [URLMapping] url
	ON m.DocumentVersionKey = url.TargetDocumentVersionKey
WHERE m.DocumentTypeCode = 'CON'
	AND m.DocumentStatusCode IN (@docstatus)
	AND m.StatusUpdatedOn >= @updatedate
