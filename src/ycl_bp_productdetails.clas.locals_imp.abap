CLASS lhc_products DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PUBLIC SECTION.
    CLASS-DATA:
        lv_id TYPE yproductdetails-id,
        lv_json TYPE string.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE products.

    METHODS read FOR READ
      IMPORTING keys FOR READ products RESULT result.

ENDCLASS.

CLASS lhc_products IMPLEMENTATION.

  METHOD update.
    READ TABLE entities INTO data(ls_entity) INDEX 1.
    if sy-subrc = 0.
         ASSIGN COMPONENT 'VALUE' OF STRUCTURE ls_entity-%control  TO FIELD-SYMBOL(<lfs_value>).
         if <lfs_value> is ASSIGNED and <lfs_value> =  cl_abap_behavior_handler=>flag_changed.
            lv_json = '"productValue" : ' && ls_entity-value .
         endif.
         ASSIGN COMPONENT 'CURRENCYCODE' OF STRUCTURE ls_entity-%control TO FIELD-SYMBOL(<lfs_currencycode>).
         if <lfs_currencycode> is ASSIGNED and <lfs_currencycode> = cl_abap_behavior_handler=>flag_changed.
            lv_json = lv_json && ' , ' && '"currencyCode" : ' && '"' && ls_entity-currencyCode && '"'.
         endif.

        if lv_json is NOT INITIAL.
            lv_id = ls_entity-id.
            CONCATENATE '{'  lv_json '}' INTO lv_json SEPARATED BY space.
        endif.
    endif.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_YPRODUCTDETAILS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_YPRODUCTDETAILS IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  if lhc_products=>lv_id is NOT INITIAL.
   DATA(lv_url) = ycl_utility=>c_nosql_url && lhc_products=>lv_id .


    TRY.
        DATA(lo_client) = ycl_utility=>create_client( url = lv_url  ).

        DATA(lo_request) = lo_client->get_http_request( ).

        lo_request->set_text( i_text   = lhc_products=>lv_json ).
        lo_request->set_header_field(
            i_name  = 'Content-Type'
            i_value = 'application/json'
        ).

           DATA(lo_response) = lo_client->execute( if_web_http_client=>put ).

      CATCH cx_web_message_error.
      CATCH cx_static_check.
      ENDTRY.
  ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
