/*

When this script runs, it identifies potentially missing indexes.

This script combines three closely-related DMVs to get a very useful 
missing index query. It uses the various statistics stored regarding
data access patterns to calculate the possible 'advantage' of adding 
a certain index; The higher the index_advantage, the bigger the impact.

The results are only as good as the statistics, so they may be spurious 
if you have recently added new indexes - which resets all the statistics 
for that table.

Beware that this script may not recommend the best column order,
it does not consider filtered indexes, and is very eager to suggest new indexes.

Always examine the results of these recommendations and consider their
impact before applying them; is there already an index that will suffice? 
Is the query that caused the recommendation rarely called? (check the 
last_user_seek column) What impact would adding another index have on 
your (potentially write heavy) table?

*/
SELECT user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage]
	,migs.last_user_seek
	,mid.[statement] AS [Database.Schema.Table]
	,mid.equality_columns
	,mid.inequality_columns
	,mid.included_columns
	,migs.unique_compiles
	,migs.user_seeks
	,migs.avg_total_user_cost
	,migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK) ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK) ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY index_advantage DESC;
