

Use OperationsManager
SELECT SourceObjectDisplayName FROM RelationshipGenericView
WHERE TargetObjectDisplayName like '%server.domain.root%'
AND SourceObjectDisplayName IN
(SELECT ManagedEntityGenericView.DisplayName
FROM ManagedEntityGenericView INNER JOIN
(SELECT BaseManagedEntityId
FROM BaseManagedEntity WITH (NOLOCK)
WHERE (BaseManagedEntityId = TopLevelHostEntityId) AND (BaseManagedEntityId NOT IN
(SELECT R.TargetEntityId
FROM Relationship AS R WITH (NOLOCK) INNER JOIN
dbo.fn_ContainmentRelationshipTypes() AS CRT ON R.RelationshipTypeId = CRT.RelationshipTypeId
WHERE (R.IsDeleted = 0)))) AS GetTopLevelEntities ON
GetTopLevelEntities.BaseManagedEntityId = ManagedEntityGenericView.Id INNER JOIN
(SELECT DISTINCT BaseManagedEntityId
FROM TypedManagedEntity WITH (NOLOCK)
WHERE (ManagedTypeId IN
(SELECT DerivedManagedTypeId
FROM dbo.fn_DerivedManagedTypes(dbo.fn_ManagedTypeId_Group()) AS fn_DerivedManagedTypes_1))) AS GetOnlyGroups ON
GetOnlyGroups.BaseManagedEntityId = ManagedEntityGenericView.Id)
ORDER BY SourceObjectDisplayName
