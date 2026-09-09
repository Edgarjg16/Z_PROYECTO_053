CLASS lsc_zi_inct_053 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_inct_053 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_INCT_053 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zi_inct_053 RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_inct_053 RESULT result.

    METHODS changeStatus FOR MODIFY
      importing keys
      FOR ACTION Incident~changeStatus
      RESULT result.

    METHODS : setUuid
                FOR determine ON MODIFY
                importing keys FOR Incident~setUuid.

    METHODS : createHistory
                FOR DETERMINE ON SAVE
                IMPORTING keys FOR Incident~createHistory.

ENDCLASS.

CLASS lhc_ZI_INCT_053 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

 METHOD changeStatus.

    READ ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    LOOP AT lt_incidents INTO DATA(ls_incident).

    DATA(ls_key) = keys[
                        KEY entity
                        %tky = ls_incident-%tky
                        ].

    MODIFY ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    UPDATE FIELDS ( Status )
    WITH VALUE #(
        (
            %tky = ls_incident-%tky
            Status = ls_key-%param-NewStatus
        )
    ).

    ENDLOOP.
  ENDMETHOD.

  METHOD setuuid.

    DATA lv_uuid TYPE sysuuid_x16.

    LOOP AT keys INTO DATA(ls_key).

        TRY.
            lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

        MODIFY ENTITIES OF zi_inct_053 IN LOCAL MODE
        ENTITY Incident
        UPDATE FIELDS ( IncUuid )
        WITH VALUE #(
            (
                %tky = ls_key-%tky
                IncUuid = lv_uuid
            )
        ).

        CATCH cx_uuid_error.
            " No se genera UUID.
        ENDTRY.

    ENDLOOP.
  ENDMETHOD.

    METHOD createHistory.

    DATA:
    lv_his_uuid TYPE sysuuid_x16,
    lv_his_id TYPE n LENGTH 8.

    LOOP AT keys INTO DATA(ls_key).

        TRY.

            lv_his_uuid = cl_system_uuid=>create_uuid_x16_static( ).

        CATCH cx_uuid_error.
*            CONTINUE.

        ENDTRY.

        SELECT SINGLE MAX( his_id )
        FROM zdt_inct_h_053
        INTO @lv_his_id.

        lv_his_id = lv_his_id + 1.

        READ ENTITIES OF zi_inct_053 IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS
        WITH VALUE #( ( %tky = ls_key-%tky ) )
        RESULT DATA(lt_incidents).

        READ TABLE lt_incidents INTO DATA(ls_incident) INDEX 1.

        IF sy-subrc = 0.

            DATA ls_history TYPE zdt_inct_h_053.


                ls_history-his_uuid = lv_his_uuid.
                ls_history-inc_uuid = ls_incident-IncUuid.
                ls_history-his_id = lv_his_id.
                ls_history-previous_status = ''.
                ls_history-new_status = 'OP'.
                ls_history-text = 'First Incident'.

           INSERT zdt_inct_h_053 FROM @ls_history.
        ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
