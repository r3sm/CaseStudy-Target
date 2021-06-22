"#autoformat
CLASS ycl_product_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*// Interface for Query
    INTERFACES  if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS ycl_product_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

*// Data Declaration
    DATA: lt_product_details TYPE TABLE OF YProductDetails,
          ls_product_details TYPE  YProductDetails,
          lo_exp             TYPE REF TO ycx_rap_query_provider.

*// If Data is requested
    IF io_request->is_data_requested( ).
      io_request->get_paging( ).

      TRY.
          "get and add filter
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
          "check if the request is a single read
          READ TABLE lt_filter_cond WITH KEY name = 'PRODUCTID' INTO DATA(ls_productid_filter_key).
          IF sy-subrc = 0 AND lines( ls_productid_filter_key-range ) = 1.
            READ TABLE ls_productid_filter_key-range INTO DATA(ls_id_option) INDEX 1.
            IF sy-subrc = 0 AND ls_id_option-sign = 'I' AND ls_id_option-option = 'EQ' AND ls_id_option-low IS NOT INITIAL.
              "read details for single record in list
              DATA(is_key_filter) = abap_true.
            ENDIF.
          ELSE.

            "        raise EXCEPTION lo_exp.
          ENDIF.
          ls_product_details-productid = '12344'.


          IF is_key_filter  <> abap_true.


          ENDIF.
          APPEND ls_product_details TO lt_product_details.


          io_response->set_data( lt_product_details ).
          io_response->set_total_number_of_records( lines( lt_product_details ) ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).


          "       raise EXCEPTION lo_exp.
      ENDTRY.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
