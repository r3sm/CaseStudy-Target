CLASS ycx_rap_query_provider DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
     begin of no_data_requested,
      msgid type symsgid value 'SY',
      msgno type symsgno value '499',
      attr1 type scx_attrname value 'Data Not requested',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of no_data_requested,
    begin of no_single_id,
      msgid type symsgid value 'SY',
      msgno type symsgno value '499',
      attr1 type scx_attrname value 'Please provide unique Product ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of no_single_id,
    begin of product_not_found,
      msgid type symsgid value 'SY',
      msgno type symsgno value '499',
      attr1 type scx_attrname value 'Product Not Found',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of product_not_found.

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ycx_rap_query_provider IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
