CLASS zcl_fill_status_053 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_status_053 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_status TYPE STANDARD TABLE OF zdt_status_053.

    " Limpiar tabla
    DELETE FROM zdt_status_053.

    lt_status = VALUE #(
            ( status_code = 'OP' status_description = 'Open' )
            ( status_code = 'IP' status_description = 'In Progress' )
            ( status_code = 'PE' status_description = 'Pending' )
            ( status_code = 'CO' status_description = 'Completed' )
            ( status_code = 'CL' status_description = 'Closed' )
            ( status_code = 'CN' status_description = 'Canceled' )
        ).
    MODIFY zdt_status_053 FROM TABLE @lt_status.
    IF sy-subrc = 0.
        COMMIT WORK.
        out->write( 'Estados actualizados correctamente.' ).
    ELSE.
        ROLLBACK WORK.
        out->write( 'Error al actualizar los estados.' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
