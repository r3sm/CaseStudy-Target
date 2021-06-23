"#autoformat

CLASS lhc_products DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA:
      lv_id   TYPE yproductdetails-id,
      lv_json TYPE string.
  PRIVATE SECTION.

    TYPES:
      lty_failed  TYPE TABLE FOR FAILED yproductdetails,
      lty_success TYPE TABLE FOR REPORTED yproductdetails.

*// Update Method
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE products.

    METHODS read FOR READ
      IMPORTING keys FOR READ products RESULT result.

ENDCLASS.

CLASS lhc_products IMPLEMENTATION.

  METHOD update.

    READ TABLE entities INTO DATA(ls_entity) INDEX 1.
    IF sy-subrc = 0.

      TRY.

*/ Calling Product Name method to Validate the ID

          ycl_product_query=>get_product_name(
            EXPORTING
              im_product_id =  ls_entity-id
            IMPORTING
             ex_Product_name = DATA(name) ).

*// If id is found, continue to check the changes requested and
*// create payload required for http PUT

*// value
          ASSIGN COMPONENT 'VALUE' OF STRUCTURE ls_entity-%control  TO FIELD-SYMBOL(<lfs_value>).
          IF <lfs_value> IS ASSIGNED AND <lfs_value> =  cl_abap_behavior_handler=>flag_changed.
            lv_json = '"productValue" : ' && ls_entity-value .
          ENDIF.
*// currencyCode
          ASSIGN COMPONENT 'CURRENCYCODE' OF STRUCTURE ls_entity-%control TO FIELD-SYMBOL(<lfs_currencycode>).
          IF <lfs_currencycode> IS ASSIGNED AND <lfs_currencycode> = cl_abap_behavior_handler=>flag_changed.
            lv_json = lv_json && ' , ' && '"currencyCode" : ' && '"' && ls_entity-currencyCode && '"'.
          ENDIF.
          IF lv_json IS NOT INITIAL.
            lv_id = ls_entity-id.
            CONCATENATE '{'  lv_json '}' INTO lv_json SEPARATED BY space.
          ENDIF.

*// If id Not Found
        CATCH ycx_rap_query_provider INTO DATA(lo_exp).

*// Populate Error Messages
          APPEND VALUE #( %cid = ls_entity-%cid_ref id = ls_entity-id
                          %fail = VALUE #( cause = if_abap_behv=>cause-not_found ) )
          TO failed-products.
          APPEND VALUE #( %cid = ls_entity-%cid_ref id = ls_entity-id
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = lo_exp->get_longtext( ) ) )
           TO reported-products.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

  METHOD read.
*// NO IMPLEMENTATION
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
*// NO IMPLEMENTATION
  ENDMETHOD.

  METHOD check_before_save.
*// NO IMPLEMENTATION
  ENDMETHOD.

  METHOD save.

*// Data Good to be updated
    IF lhc_products=>lv_id IS NOT INITIAL.

      DATA(lv_url) = ycl_utility=>c_nosql_url && lhc_products=>lv_id .

      TRY.
          DATA(lo_client) = ycl_utility=>create_client( url = lv_url  ).

          DATA(lo_request) = lo_client->get_http_request( ).

          lo_request->set_text( i_text   = lhc_products=>lv_json ).
          lo_request->set_header_field(
              i_name  = 'Content-Type'
              i_value = 'application/json').

*// Execute put Request
          lo_client->execute( if_web_http_client=>put ).

        CATCH cx_web_message_error.
        CATCH cx_static_check.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
*// NO IMPLEMENTATION
  ENDMETHOD.

  METHOD cleanup_finalize.
*// NO IMPLEMENTATION
  ENDMETHOD.

ENDCLASS.
