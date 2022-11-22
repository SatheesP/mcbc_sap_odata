CLASS zcl_mcbc_meal_airline_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_mcbc_meal_airline_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS mealset_get_entityset
        REDEFINITION .
    METHODS mealset_get_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCBC_MEAL_AIRLINE_DPC_EXT IMPLEMENTATION.


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

*-- Just a Query to get all rows of the entity
    SELECT *
      FROM zmeals( p_logon_langu = @sy-langu, p_suppl_langu = 'D' )
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset.

  ENDMETHOD.
ENDCLASS.
