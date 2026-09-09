CLASS zcl_fill_priority_053 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_priority_053 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_priorities TYPE STANDARD TABLE OF zdt_priority_053.

    " Limpiar tabla
    DELETE FROM zdt_priority_053.

    lt_priorities = VALUE #(
            ( priority_code = 'B' priority_description = 'Baja' )
            ( priority_code = 'M' priority_description = 'Media' )
            ( priority_code = 'A' priority_description = 'Alta' )
        ).

    MODIFY zdt_priority_053 FROM TABLE @lt_priorities.

    IF sy-subrc = 0.
        COMMIT WORK.
    ELSE.
        ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
