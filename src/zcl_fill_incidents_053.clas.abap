CLASS zcl_fill_incidents_053 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES : if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_incidents_053 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_incidents TYPE STANDARD TABLE OF zdt_inct_053,
          lv_uuid TYPE sysuuid_x16.

    " Limpiar tabla
    DELETE FROM zdt_inct_053.

    " Incidente 1
    lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

    APPEND VALUE #(
        inc_uuid = lv_uuid
        incident_id = '00000001'
        title = 'SAP Error'
        description = 'Error during sales order creation'
        status = 'OP'
        priority = 'A'
        creation_date = sy-datum
        changed_date = sy-datum
        ) TO lt_incidents.

    " Incidente 2
    lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

    APPEND VALUE #(
        inc_uuid = lv_uuid
        incident_id = '00000002'
        title = 'Network Issue'
        description = 'Connection timeout'
        status = 'PR'
        priority = 'M'
        creation_date = sy-datum
        changed_date = sy-datum
        ) TO lt_incidents.

    " Incidente 3
    lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

    APPEND VALUE #(
        inc_uuid = lv_uuid
        incident_id = '00000003'
        title = 'Printer'
        description = 'Printer not responding'
        status = 'CL'
        priority = 'B'
        creation_date = sy-datum
        changed_date = sy-datum
        ) TO lt_incidents.

    MODIFY zdt_inct_053 FROM TABLE @lt_incidents.

    IF sy-subrc = 0.
        COMMIT WORK.
        out->write( |{ lines( lt_incidents ) } incidentes cargados correctamente.| ).
    ELSE.
        ROLLBACK WORK.
        out->write( 'Error al cargar los incidentes.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
