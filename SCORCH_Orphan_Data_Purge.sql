For the Orphan instances to clean, please follow the below process.

--1. Take full backup of orchestrator database.

-- Need to stop the Runbook services on the Runbook servers.

--2. Execute below SQL queries to check tables (Policyinstances, Objectinstances, Objectinstancedata, Events, Policy_publish_queue) :

Select Count(*) From POLICYINSTANCES WITH (NOLOCK)
Select Count(*) From OBJECTINSTANCES WITH (NOLOCK)
Select Count(*) From OBJECTINSTANCEDATA WITH (NOLOCK)
Select Count(*) From EVENTS WITH (NOLOCK)
Select Count(*) From POLICY_PUBLISH_QUEUE WITH (NOLOCK)

--3. Execute below SQL queries to clean tables (Policyinstances, Objectinstances, Objectinstancedata, Events, Policy_publish_queue) if you see large number of rows in above SQL queries:

DELETE FROM POLICY_PUBLISH_QUEUE
GO
TRUNCATE TABLE EVENTS
TRUNCATE TABLE OBJECTINSTANCEDATA
TRUNCATE TABLE OBJECTINSTANCES
DELETE FROM POLICYINSTANCES
GO

--4. After above query is executed successfully, execute below mentioned query to disable "Logging" for all Runbooks:

--Before that I would suggest to take a note of all the policies for which logging is enabled. Please run the below query to get the details.
  
Select * from POLICIES where LogCommonData = 1
Select * from POLICIES where LogSpecificData = 1 

--Now you can run the below query to disable the logging.

update POLICIES set LogCommonData = 0 where LogCommonData = 1
update POLICIES set LogSpecificData = 0 where LogSpecificData = 1 


--5. After successful execution of above query, execute below SQL query to check orphaned Runbook instances:

select
pinst.[UniqueID],
pinst.[PolicyID]
from
[dbo].[POLICYINSTANCES] AS pinst, [dbo].[POLICY_REQUEST_HISTORY] AS prq
where
pinst.[PolicyID] = prq.[PolicyID] AND 
pinst.[SeqNumber] = prq.[SeqNumber] AND
pinst.[TimeEnded] IS NULL AND
prq.[Active] = 0 

--6. If output of above query is not blank, stop all running runbooks using below query:

use orchestrator
go
-- This section will cancel all active or pending jobs
DECLARE @JobId UNIQUEIDENTIFIER
DECLARE job_cursor CURSOR FOR
SELECT Id FROM [Microsoft.SystemCenter.Orchestrator.Runtime.Internal].Jobs
WHERE StatusId < 2
OPEN job_cursor
FETCH NEXT FROM job_cursor INTO @JobId 
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC [Microsoft.SystemCenter.Orchestrator.Runtime].CancelJob @JobId, 'S-1-5-500'
FETCH NEXT FROM job_cursor INTO @JobId
END
CLOSE job_cursor
DEALLOCATE job_cursor
GO

--7. After stopping all running runbooks, execute below query to clear orphaned runbook instances:

exec [Microsoft.SystemCenter.Orchestrator.Runtime.Internal].[ClearOrphanedRunbookInstances]

--8. Run below SQL query to do log purging:

DECLARE @Completed bit
SET @Completed = 0
WHILE @Completed = 0 EXEC sp_CustomLogCleanup @Completed OUTPUT, @FilterType=1,@XEntries=0

--9. Now, we need to check if orchestrator maintenance operation has been executed recently, for that use below SQL query:

SELECT 
[m].[Name], 
[m].[IsEnabled], 
[m].[IntervalInSeconds], 
[m].[LastExecutionTime] 
FROM [Orchestrator].[Microsoft.SystemCenter.Orchestrator.Maintenance].[MaintenanceTasks] [m]

--10. If output of above query states that maintenance operations have not executed recently, follow below procedure to execute maintenance operations:

--a. Execute below SQL query:

ALTER QUEUE [Microsoft.SystemCenter.Orchestrator.Maintenance].MaintenanceServiceQueue WITH STATUS = ON 

--b. After above query, execute below query:

TRUNCATE TABLE [Microsoft.SystemCenter.Orchestrator.Internal].AuthorizationCache 

--c. After above query, execute below query:

EXEC [Microsoft.SystemCenter.Orchestrator.Maintenance].[EnqueueRecurrentTask] @taskName = 'Statistics'
EXEC [Microsoft.SystemCenter.Orchestrator.Maintenance].[EnqueueRecurrentTask] @taskName = 'Authorization'
EXEC [Microsoft.SystemCenter.Orchestrator.Maintenance].[EnqueueRecurrentTask] @taskName = 'ClearAuthorizationCache'

--11. Execute below query again to check if maintenance operations are now executed recently:

SELECT 
[m].[Name], 
[m].[IsEnabled], 
[m].[IntervalInSeconds], 
[m].[LastExecutionTime] 
FROM [Orchestrator].[Microsoft.SystemCenter.Orchestrator.Maintenance].[MaintenanceTasks] [m]

--Note: Now we should see latest date.

--12. Now you can again Enable the logging which were disable in step 4.
  
update POLICIES set LogCommonData = 1 where UniqueID in (‘XX0,’ XX1’,’ XX2)
update POLICIES set LogSpecificData = 1 where UniqueID in (‘XX0,’ XX3’,’ XX24)
