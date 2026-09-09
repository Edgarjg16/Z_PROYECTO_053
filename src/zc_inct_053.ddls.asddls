@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DD ZI_INCT_053'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_INCT_053 as select from ZI_INCT_053
{
    key IncUuid,
    IncidentId,
    Title,
    Description,
    Status,
    Priority,
    CreationDate,
    ChangedDate,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _History
}
