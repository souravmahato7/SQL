

-- The following SQL Script you can execute to grant specific permission to SQL so that SCOM can run the workflows. 
-- You just need to replace the account name here : SET @accountname = 'domain\test';


--For SQL2017+, you need to run the below Script. This is when User account is not created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command1 nvarchar(MAX);
DECLARE @command2 nvarchar(MAX);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command1 = 'USE [master];
CREATE LOGIN ['+@accountname+'] FROM WINDOWS WITH DEFAULT_DATABASE=[master];';
SET @command2 = '';
SELECT @command2 =@command2 + 'USE ['+db.name+'];
CREATE USER ['+@accountname+'] FOR LOGIN ['+@accountname+'];' FROM sys.databases db 
LEFT JOIN sys.dm_hadr_availability_replica_states hadrstate 
ON db.replica_id = hadrstate.replica_id 
WHERE db.database_id <> 2 AND db.user_access = 0 AND db.state = 0 AND db.is_read_only = 0 
AND (hadrstate.role = 1 or hadrstate.role is null);
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT EXECUTE ON xp_readerrorlog TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
GRANT EXECUTE ON msdb.dbo.sp_help_job to ['+@accountname+']; 
GRANT EXECUTE ON msdb.dbo.sp_help_jobactivity to ['+@accountname+']; 
GRANT SELECT ON sysjobs_view to ['+@accountname+']; 
GRANT SELECT ON sysschedules to ['+@accountname+']; 
GRANT SELECT ON sysjobschedules to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_history_detail to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_secondary to ['+@accountname+']; 
GRANT SELECT ON log_shipping_secondary_databases to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_primary to ['+@accountname+']; 
GRANT SELECT ON log_shipping_primary_databases to ['+@accountname+']; 
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command1;
EXECUTE sp_executesql @command2;
EXECUTE sp_executesql @command3;

--For (SQL2012 - SQL2016), you need to run the below Script. This is when User account is not created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command1 nvarchar(MAX);
DECLARE @command2 nvarchar(MAX);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command1 = 'USE [master];
CREATE LOGIN ['+@accountname+'] 
FROM WINDOWS WITH DEFAULT_DATABASE=[master];';
SET @command2 = '';
SELECT @command2 =@command2 + 'USE ['+db.name+'];
CREATE USER ['+@accountname+'] 
FOR LOGIN ['+@accountname+'];' 
FROM sys.databases db 
left join sys.dm_hadr_availability_replica_states hadrstate 
on db.replica_id = hadrstate.replica_id 
WHERE db.database_id <> 2 
AND db.user_access = 0 
AND db.state = 0 
AND db.is_read_only = 0 
AND (hadrstate.role = 1 or hadrstate.role is null);
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command1;
EXECUTE sp_executesql @command2;
EXECUTE sp_executesql @command3;


--For SQL 2008, you need to run the below Script. This is when User account is not created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command1 nvarchar(MAX);
DECLARE @command2 nvarchar(MAX);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command1 = 'USE [master];
CREATE LOGIN ['+@accountname+'] 
FROM WINDOWS WITH DEFAULT_DATABASE=[master];';
SET @command2 = '';
SELECT @command2 = @command2 + 'USE ['+name+'];
CREATE USER ['+@accountname+'] 
FOR LOGIN ['+@accountname+'];' 
FROM sys.databases db 
WHERE db.database_id <> 2 
AND db.user_access = 0 
AND db.state = 0 
AND db.is_read_only = 0;
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command1;
EXECUTE sp_executesql @command2;
EXECUTE sp_executesql @command3;

--#############################################################################################################################################

--If User account is already present, then you need to run the following:

--For SQL2017+, you need to run the below Script. This is when User account is already created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT EXECUTE ON xp_readerrorlog TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
GRANT EXECUTE ON msdb.dbo.sp_help_job to ['+@accountname+']; 
GRANT EXECUTE ON msdb.dbo.sp_help_jobactivity to ['+@accountname+']; 
GRANT SELECT ON sysjobs_view to ['+@accountname+']; 
GRANT SELECT ON sysschedules to ['+@accountname+']; 
GRANT SELECT ON sysjobschedules to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_history_detail to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_secondary to ['+@accountname+']; 
GRANT SELECT ON log_shipping_secondary_databases to ['+@accountname+']; 
GRANT SELECT ON log_shipping_monitor_primary to ['+@accountname+']; 
GRANT SELECT ON log_shipping_primary_databases to ['+@accountname+']; 
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command3;

--For (SQL2012 - SQL2016), you need to run the below Script. This is when User account is already created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command3;


--For SQL 2008, you need to run the below Script. This is when User account is already created.
--#############################################################################################################################################

SET NOCOUNT ON;
DECLARE @accountname nvarchar(128);
DECLARE @command3 nvarchar(MAX);
SET @accountname = 'domain\test';
SET @command3 = 'USE [master];
GRANT VIEW ANY DATABASE TO ['+@accountname+'];
GRANT VIEW ANY DEFINITION TO ['+@accountname+'];
GRANT VIEW SERVER STATE TO ['+@accountname+'];
GRANT SELECT on sys.database_mirroring_witnesses to ['+@accountname+'];
USE [msdb];
EXEC sp_addrolemember @rolename=''PolicyAdministratorRole'', @membername='''+@accountname+''';
EXEC sp_addrolemember @rolename=''SQLAgentReaderRole'', @membername='''+@accountname+''';';
EXECUTE sp_executesql @command3;


