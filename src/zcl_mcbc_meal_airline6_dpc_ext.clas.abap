CLASS zcl_mcbc_meal_airline6_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_mcbc_meal_airline6_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_sadl_gw_query_control~set_query_options REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_entityset REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      mc_max_pagesize        TYPE i VALUE 5.

    DATA:
      mv_skiptoken_enabled TYPE abap_bool VALUE abap_undefined,
      mv_skip_token        TYPE i.
ENDCLASS.



CLASS ZCL_MCBC_MEAL_AIRLINE6_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
**--Enable automated server-side paging for any MDS entity-set

    DATA lv_num TYPE n LENGTH 15.
    DATA lv_cnt TYPE i.

    lv_num = io_tech_request_context->get_skiptoken( ).
    IF lv_num > 0.
      me->mv_skip_token = lv_num.
      me->mv_skiptoken_enabled = abap_true.
    ENDIF.

    super->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
      EXPORTING
        iv_entity_name               = iv_entity_name    " Obsolete
        iv_entity_set_name           = iv_entity_set_name    " Obsolete
        iv_source_name               = iv_source_name    " Obsolete
        it_filter_select_options     = it_filter_select_options    " table of select options - Obsolete
        it_order                     = it_order    " the sorting order - Obsolete
        is_paging                    = is_paging    " paging structure - Obsolete
        it_navigation_path           = it_navigation_path    " table of navigation paths - Obsolete
        it_key_tab                   = it_key_tab    " table for name value pairs - Obsolete
        iv_filter_string             = iv_filter_string    " the filter as a string containing ANDs and ORs etc -Obsolete
        iv_search_string             = iv_search_string    " Obsolete
        io_tech_request_context      = io_tech_request_context
      IMPORTING
        er_entityset                 = er_entityset
        es_response_context          = es_response_context
    ).

*-- without System Query Option $inlinecount, skiptoken exist for last dataset as well
    IF me->mv_skiptoken_enabled = abap_true.
      lv_cnt = es_response_context-inlinecount.
      IF lv_cnt = 0 OR ( ( me->mv_skip_token + me->mc_max_pagesize ) < lv_cnt ).
        es_response_context-skiptoken = me->mv_skip_token + me->mc_max_pagesize.
        CONDENSE es_response_context-skiptoken NO-GAPS.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_sadl_gw_query_control~set_query_options.

    DATA: lv_skip TYPE i,
          lv_top  TYPE i.

    CASE iv_entity_set.
      WHEN 'Airlines'.
        io_query_options->set_text_search_scope( it_search_scope =
        VALUE #( ( `AIRLINEID` ) ( `NAME` ) ( `CURRENCYCODE` ) )
         ).
    ENDCASE.

**--Enable automated server-side paging for any MDS entity-set
    io_query_options->get_paging(
      IMPORTING
        ev_skip = lv_skip
        ev_top  = lv_top
    ).

    IF mv_skiptoken_enabled = abap_true.

      lv_skip = me->mv_skip_token.
      io_query_options->set_paging(
        EXPORTING
          iv_skip = lv_skip
          iv_top  = me->mc_max_pagesize
      ).

    ELSEIF ( lv_skip + lv_top <= 0 ) OR lv_top > me->mc_max_pagesize. " No client side paging

      io_query_options->set_paging(
        EXPORTING
          iv_skip = lv_skip
          iv_top  = me->mc_max_pagesize
      ).
      me->mv_skiptoken_enabled = abap_true.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
