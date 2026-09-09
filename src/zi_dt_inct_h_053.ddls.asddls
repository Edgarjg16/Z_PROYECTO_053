@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'historico Incidencias'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zi_dt_inct_h_053 as select from zdt_inct_h_053

//association [1..1] to ZI_INCT_053 as _iIncident on _iIncident.IncUuid = $projection.IncUuid
association to parent ZI_INCT_053 as _Incident on _Incident.IncUuid = $projection.IncUuid

{
    key his_uuid as HisUuid,
    key inc_uuid as IncUuid,
    his_id as HisId,
    previous_status as PreviousStatus,
    new_status as NewStatus,
    text as Text,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _Incident // Make association public
}
