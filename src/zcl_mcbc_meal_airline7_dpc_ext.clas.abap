class ZCL_MCBC_MEAL_AIRLINE7_DPC_EXT definition
  public
  inheriting from ZCL_MCBC_MEAL_AIRLINE7_DPC
  create public .

public section.

  methods IF_SADL_GW_QUERY_CONTROL~SET_QUERY_OPTIONS
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MCBC_MEAL_AIRLINE7_DPC_EXT IMPLEMENTATION.


  METHOD if_sadl_gw_query_control~set_query_options.


    CASE iv_entity_set.
      WHEN 'Airlines'.
        io_query_options->set_text_search_scope( it_search_scope =
        VALUE #( ( `AIRLINEID` ) ( `NAME` ) ( `CURRENCYCODE` ) )
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
