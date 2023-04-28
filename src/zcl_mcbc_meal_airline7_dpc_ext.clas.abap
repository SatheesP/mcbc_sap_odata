CLASS zcl_mcbc_meal_airline7_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_mcbc_meal_airline7_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_sadl_gw_query_control~set_query_options
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCBC_MEAL_AIRLINE7_DPC_EXT IMPLEMENTATION.


  METHOD if_sadl_gw_query_control~set_query_options.

    CASE iv_entity_set.
      WHEN 'Airlines'.
        io_query_options->set_text_search_scope( it_search_scope =
        VALUE #( ( `AIRLINEID` ) ( `NAME` ) ( `CURRENCYCODE` ) )
         ).

        " Required for Meals->toAirline navigation access
        io_query_options->set_entity_parameters(
        it_parameters = VALUE #( ( entity_alias = 'Meals'
                                   parameters =  VALUE #( ( name = 'P_LOGON_LANGU' value = sy-langu )
                                                          ( name = 'P_SUPPL_LANGU' value = 'D' ) ) )  )
         ).

      WHEN 'Meals'.
        io_query_options->set_entity_parameters(
        it_parameters = VALUE #( ( entity_alias = iv_entity_set
                                   parameters =  VALUE #( ( name = 'P_LOGON_LANGU' value = sy-langu )
                                                          ( name = 'P_SUPPL_LANGU' value = 'D' ) ) )  )
         ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
