CLASS zcl_mcbc_meal_airline1_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_mcbc_meal_airline1_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS mealset_get_entityset
        REDEFINITION .
    METHODS mealset_get_entity
        REDEFINITION .

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCBC_MEAL_AIRLINE1_DPC_EXT IMPLEMENTATION.


  METHOD mealset_get_entity.

    DATA ls_meal TYPE zcl_mcbc_meal_airline_mpc=>ts_meal.

*-- Reads the key values of URI into data structure of Entity Type
    io_tech_request_context->get_converted_keys( IMPORTING es_key_values = ls_meal ).

*-- Reads a unique row based on keys passed in URI
    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF @er_entity
      FROM zmeals( p_logon_langu = @sy-langu, p_suppl_langu = 'D' )
     WHERE airlineid  = @ls_meal-airlineid
       AND mealnumber = @ls_meal-mealnumber.

  ENDMETHOD.


  METHOD mealset_get_entityset.

    DATA lt_meals TYPE zcl_mcbc_meal_airline_mpc=>tt_meal.

*-- /EntitySetName/$count - works neither filtering nor searching
    IF io_tech_request_context->has_count( ).
      SELECT COUNT( * )
        FROM zmeals( p_logon_langu = @sy-langu, p_suppl_langu = 'D' ).

      es_response_context-count = sy-dbcnt.
      RETURN.
    ENDIF.

*-- Meals?$format=json&$inlinecount=allpages&$filter=AirlineID eq 'AA'
    DATA(where_cond) = io_tech_request_context->get_osql_where_clause_convert( ).

*-- Just a Query to get all rows of the entity
    SELECT *
      FROM zmeals( p_logon_langu = @sy-langu, p_suppl_langu = 'D' )
     WHERE (where_cond)
      INTO CORRESPONDING FIELDS OF TABLE @lt_meals.

*-- Client side paging
*-- /EntitySetName?$format=json&$inlinecount=allpages
    IF io_tech_request_context->has_inlinecount( ).
      es_response_context-inlinecount = lines( lt_meals ).
    ENDIF.

*-- $top & $skip
    DATA(from) = io_tech_request_context->get_skip( ).
    DATA(to) = from + io_tech_request_context->get_top( ).
    IF ( from + to ) = 0.
      et_entityset[] = lt_meals[].
    ELSE.
      from = from + 1.

      LOOP AT lt_meals FROM from TO to ASSIGNING FIELD-SYMBOL(<fs_entity>).
        APPEND <fs_entity> TO et_entityset.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
