CLASS zcl_fill_history_053 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_history_053 IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.

    DATA: lt_incidents TYPE STANDARD TABLE OF zdt_inct_053,
          lt_history TYPE STANDARD TABLE OF zdt_inct_h_053,
          lv_counter TYPE n LENGTH 8,
          lv_his_uuid TYPE sysuuid_x16.

    " Limpiar histórico
    DELETE FROM zdt_inct_h_053.

    " Leer incidentes
    SELECT *
    FROM zdt_inct_053
    INTO TABLE @lt_incidents.

    lv_counter = 1.

    LOOP AT lt_incidents INTO DATA(ls_incident).
        TRY.
            lv_his_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error INTO DATA(lx_uuid).
            out->write(
                |Error generando UUID: { lx_uuid->get_text( ) }|
            ).
            RETURN.
        ENDTRY.

        APPEND VALUE #(
*                his_uuid = cl_system_uuid=>create_uuid_x16_static( )
                his_uuid = lv_his_uuid
                inc_uuid = ls_incident-inc_uuid
                his_id = lv_counter
                previous_status = ls_incident-status
                new_status = ls_incident-status
                text = |Incidente { ls_incident-incident_id } creado con estado { ls_incident-status }|
            ) TO lt_history.

        lv_counter = lv_counter + 1.

    ENDLOOP.

    MODIFY zdt_inct_h_053 FROM TABLE @lt_history.

    IF sy-subrc = 0.
        COMMIT WORK.
        out->write(
                |{ lines( lt_history ) } registros de histórico cargados correctamente.|
            ).
    ELSE.
        ROLLBACK WORK.
        out->write(
            'Error al cargar el histórico.'
            ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
