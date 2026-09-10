CLASS lsc_zi_inct_053 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

*    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_inct_053 IMPLEMENTATION.

*  METHOD save_modified.
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_INCT_053 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Incident RESULT result.

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

    METHODS : validateMandatoryFields
                FOR VALIDATE ON SAVE
                IMPORTING keys FOR Incident~validateMandatoryFields.

    METHODS : validateDates
                FOR VALIDATE ON SAVE
                IMPORTING keys FOR Incident~validateDates.

    METHODS : validateResponsible
                FOR VALIDATE ON SAVE
                keys FOR Incident~validateResponsible.
ENDCLASS.

CLASS lhc_ZI_INCT_053 IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD changeStatus.
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    READ ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    LOOP AT lt_incidents INTO DATA(ls_incident).

*        IF lv_user <> ls_incident-Responsible
*          AND lv_user <> gc_admin.
*
*            APPEND VALUE #(
*                %tky = ls_incident-%tky
*                ) TO failed-Incident.
*
**            APPEND VALUE #(
**                %tky = ls_incident-%tky
**                %msg = new_message(
**                id = 'ZMC_INCT_053'
**                number = '030'
**                severity = if_abap_behv_message=>severity-error )
**            ) TO reported-Incident.
*            APPEND VALUE #( %tky = ls_incident-%tky
*                            %msg = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-error
*                            text     = 'Solo el usuario responsable o un administrador pueden cambiar el estado del incidente' ) )
*            TO reported-Incident.
*
*            CONTINUE.
*
*        ENDIF.

        DATA(ls_key) = keys[
                            KEY entity
                            %tky = ls_incident-%tky
                            ].

        DATA(lv_new_status) = ls_key-%param-NewStatus.

" Regla de negocio
        IF ls_incident-Status = 'PE'
           AND ( lv_new_status = 'CO'
            OR lv_new_status = 'CL' ).

*            APPEND VALUE #(
*                %tky = ls_incident-%tky
*                %msg = new_message(
*                id = 'ZINCIDENT'
*                number = '001'
*                severity = if_abap_behv_message=>severity-error
*                v1 = 'No se puede pasar de Pending a Completed o Closed'
*                )
*                ) TO reported-incident.

            APPEND VALUE #( %tky = ls_incident-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'No se puede pasar de Pending a Completed o Closed') ) TO reported-Incident.

            APPEND VALUE #(
                %tky = ls_incident-%tky
                ) TO failed-incident.

            CONTINUE.

        ENDIF.

        IF ls_incident-Status = 'CN'
            OR ls_incident-Status = 'CO'
            OR ls_incident-Status = 'CL'.

                APPEND VALUE #(
                    %tky = ls_incident-%tky
                    ) TO failed-Incident.

*                APPEND VALUE #(
*                    %tky = ls_incident-%tky
*                    %msg = new_message(
*                    id = 'ZMC_INCT_053'
*                    number = '010'
*                    severity = if_abap_behv_message=>severity-error
*                    v1 = ls_incident-Status
*                    )
*                    ) TO reported-Incident.

                APPEND VALUE #( %tky = ls_incident-%tky
                                %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = ls_incident-Status ) ) TO reported-Incident.

                CONTINUE.

        ENDIF.

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

*  METHOD setuuid.
*
*    DATA : lv_uuid TYPE sysuuid_x16,
*           lv_incident_id TYPE n LENGTH 8.
*
*    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
*
*    LOOP AT keys INTO DATA(ls_key).
*
*        TRY.
*            lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
*        CATCH cx_uuid_error.
*            " No se genera UUID.
*        ENDTRY.
*
*        SELECT SINGLE MAX( incident_id )
*        FROM zdt_inct_053
*        INTO @lv_incident_id.
*
*        lv_incident_id += 1.
*
*        MODIFY ENTITIES OF zi_inct_053 IN LOCAL MODE
*        ENTITY Incident
*        UPDATE FIELDS ( IncUuid IncidentId CreationDate Status )
*        WITH VALUE #(
*            (
*                %tky = ls_key-%tky
*                IncUuid = lv_uuid
*                IncidentId = lv_incident_id
*                CreationDate = lv_date
*                Status = 'OP'
*            )
*        ).
*
*
*    ENDLOOP.
*  ENDMETHOD.


METHOD setUuid.

    DATA lv_uuid TYPE sysuuid_x16.

    LOOP AT keys INTO DATA(ls_key).

        TRY.
        lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        MODIFY ENTITIES OF zi_inct_053 IN LOCAL MODE
        ENTITY Incident
        UPDATE FIELDS (
                        IncUuid
                        Status
                        ChangedDate
                      )
        WITH VALUE #(
                (
                    %tky = ls_key-%tky
                    IncUuid = lv_uuid
                    Status = 'OP'
                    ChangedDate = cl_abap_context_info=>get_system_date( )
                )
            ).
        CATCH cx_uuid_error.
            CONTINUE.
        ENDTRY.
    ENDLOOP.
ENDMETHOD.
  METHOD createHistory.

    DATA:
    lv_his_uuid TYPE sysuuid_x16,
    lv_his_id TYPE n LENGTH 8.

    READ ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    LOOP AT lt_incidents INTO DATA(ls_incident).

        TRY.
            lv_his_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
*            CONTINUE.
        ENDTRY.

        SELECT SINGLE MAX( his_id )
        FROM zdt_inct_h_053
        INTO @lv_his_id.

        lv_his_id += 1.

        MODIFY ENTITIES OF zi_inct_053 IN LOCAL MODE
        ENTITY Incident
        CREATE BY \_History
        FROM VALUE #(
            (
                %tky = ls_incident-%tky
                %target = VALUE #(
                    (
                        HisUuid = lv_his_uuid
                        HisId = lv_his_id
                        IncUuid = ls_incident-IncUuid
                        PreviousStatus = ''
                        NewStatus = 'OP'
                        text = 'First Incident'
                     )
            )
          )
        ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validatemandatoryfields.
    READ ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incident).

    LOOP AT lt_incident INTO DATA(ls_incident).

        IF ls_incident-Title IS INITIAL
            OR ls_incident-Description IS INITIAL
            OR ls_incident-Priority IS INITIAL
            OR ls_incident-Status IS INITIAL
            OR ls_incident-CreationDate IS INITIAL.

            APPEND VALUE #(
            %tky = ls_incident-%tky
            ) TO failed-Incident.

*            APPEND VALUE #(
*                    %tky = ls_incident-%tky
*                    %msg = new_message(
*                    id = 'ZMC_INCT_053'
*                    number = '001'
*                    severity = if_abap_behv_message=>severity-error
*                    v1 = 'Campos obligatorios vacíos'
*                    )
*                ) TO reported-Incident.

            APPEND VALUE #( %tky = ls_incident-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-success
                            text     = 'Campos obligatorios vacíos' ) ) TO reported-Incident.

        ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validatedates.

  READ ENTITIES OF zi_inct_053 IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_incidents INTO DATA(ls_incident).

    "--------------------------------------------------
    " CHANGE_DATE no puede ser menor que CREATION_DATE
    "--------------------------------------------------
        IF ls_incident-ChangedDate < ls_incident-CreationDate.

            APPEND VALUE #(
                %tky = ls_incident-%tky
                ) TO failed-incident.

*            APPEND VALUE #(
*                    %tky = ls_incident-%tky
*                    %msg = new_message(
*                    id = 'ZINCIDENT'
*                    number = '002'
*                    severity = if_abap_behv_message=>severity-error
*                    )
*                ) TO reported-incident.

            APPEND VALUE #( %tky = ls_incident-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'Fecha de modificación no puede ser menor que fecha de creación' ) ) TO reported-Incident.

        ENDIF.

    "--------------------------------------------------
    " CREATION_DATE no puede ser futura
    "--------------------------------------------------
        IF ls_incident-CreationDate > lv_today.

            APPEND VALUE #(
                %tky = ls_incident-%tky
                ) TO failed-incident.

*            APPEND VALUE #(
*                    %tky = ls_incident-%tky
*                    %msg = new_message(
*                    id = 'ZINCIDENT'
*                    number = '003'
*                    severity = if_abap_behv_message=>severity-error
*                    )
*                ) TO reported-incident.
            APPEND VALUE #( %tky = ls_incident-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'Fecha de creación no puede ser a futuro' ) ) TO reported-Incident.

        ENDIF.

"--------------------------------------------------
" CHANGE_DATE no puede ser futura
"--------------------------------------------------
        IF ls_incident-ChangedDate > lv_today.

            APPEND VALUE #(
                %tky = ls_incident-%tky
                ) TO failed-incident.

*            APPEND VALUE #(
*                    %tky = ls_incident-%tky
*                    %msg = new_message(
*                    id = 'ZINCIDENT'
*                    number = '004'
*                    severity = if_abap_behv_message=>severity-error
*                    )
*             ) TO reported-incident.

            APPEND VALUE #( %tky = ls_incident-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'No se permiten futuras' ) ) TO reported-Incident.

        ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateResponsible.
*    READ ENTITIES OF zi_inct_053 IN LOCAL MODE
*    ENTITY Incident
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_incidents).
*
*    LOOP AT lt_incidents INTO DATA(ls_incident).
*
*        IF ls_incident-Status = 'IP'
*            AND ls_incident-Responsible IS INITIAL.
*
*            APPEND VALUE #(
*                %tky = ls_incident-%tky
*                ) TO failed-Incident.
*
**            APPEND VALUE #(
**                %tky = ls_incident-%tky
**                %element-Responsible = if_abap_behv=>mk-on
**                %msg = new_message(
**                id = 'ZMC_INCT_053'
**                number = '020'
**                severity = if_abap_behv_message=>severity-error )
**            ) TO reported-Incident.
*
*            APPEND VALUE #( %tky = ls_incident-%tky
*                            %msg = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-error
*                            text     = 'Debe asignarse un responsable cuando el incidente pase a estado In Progress.' ) ) TO reported-Incident.
*
*        ENDIF.
*
*    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
