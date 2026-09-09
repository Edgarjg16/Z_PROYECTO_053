@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incidents'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_INCT_053 as select from zdt_inct_053 

//association [0..*] to zi_dt_inct_h_053 as _History on _History.IncUuid = $projection.IncUuid
composition [0..*] of zi_dt_inct_h_053 as _History
{
    key inc_uuid as IncUuid,
    incident_id as IncidentId,
    title as Title,
    description as Description,
    status as Status,
    priority as Priority,
    creation_date as CreationDate,
    changed_date as ChangedDate,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _History // Make association public
}
