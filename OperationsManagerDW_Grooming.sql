Use OperationsManagerDW
DECLARE @ServerName AS NVARCHAR(50)

/* set variables */
SET @ServerName = 'Servername.domain.com' /* Insert FQDN of Agent to be removed here */

PRINT 'ServerName: ' + @ServerName

/*Start removal*/
/* Remove of ManagedEntity */
PRINT '== Remove of ManagedEntityRowId '
PRINT '1. MaintenanceModeStage:'

Delete from MaintenanceModeStage  where ManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '== Remove of ManagedEntityGuid '
PRINT '2. ManagedEntityStage:'

Delete from ManagedEntityStage Where ManagedEntityGuid in (Select ManagedEntityGuid from ManagedEntity where DisplayName like @ServerName)

PRINT '3. ManagedEntityStage:'

Delete from TypedManagedEntityStage Where ManagedEntityGuid in (Select ManagedEntityGuid from ManagedEntity where DisplayName like @ServerName)

PRINT '== Remove of ManagedEntityRowId '

PRINT '4. ManagedEntityManagementGroup:'

Delete from ManagedEntityManagementGroup where ManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '5. ManagedEntityProperty:'

Delete from ManagedEntityProperty where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '6. TypedManagedEntity:'

Delete from TypedManagedEntity where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '7. MaintenanceModeHistory:'

Delete from MaintenanceModeHistory where MaintenanceModeRowId in (Select MaintenanceModeRowId from MaintenanceMode where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '8. MaintenanceMode:'

Delete from MaintenanceMode where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '9. HealthServiceOutageStage:'

Delete from HealthServiceOutageStage where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '10. HealthServiceOutage:'

Delete from HealthServiceOutage where ManagedEntityRowId  in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName)

PRINT '== Remove of RelationshipRowId '
PRINT '11. RelationshipManagementGroup:'

Delete from RelationshipManagementGroup where RelationshipRowId in (Select RelationshipRowId from Relationship where TargetManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '12. RelationshipManagementGroup:'

Delete from RelationshipManagementGroup where RelationshipRowId in (Select RelationshipRowId from Relationship where SourceManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '13. RelationshipProperty:'

Delete from RelationshipProperty where RelationshipRowId in (Select RelationshipRowId from Relationship where TargetManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '14. RelationshipProperty:'

Delete from RelationshipProperty where RelationshipRowId in (Select RelationshipRowId from Relationship where SourceManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '15. Relationship:'

Delete from Relationship where RelationshipRowId in (Select RelationshipRowId from Relationship where TargetManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '16. Relationship:'

Delete from Relationship where RelationshipRowId in (Select RelationshipRowId from Relationship where SourceManagedEntityRowId in (Select ManagedEntityRowId from ManagedEntity where DisplayName like @ServerName))

PRINT '== Remove of TargetManagedEntityGuid '
PRINT '17. RelationshipStage:'

Delete from RelationshipStage where TargetManagedEntityGuid in (Select ManagedEntityGuid from ManagedEntity where DisplayName like @ServerName)

PRINT '== Remove of ManagedEntity '
PRINT '18. ManagedEntity:'

Delete from ManagedEntity where DisplayName like @ServerName
