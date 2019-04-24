;;; filename : sa-except.inc
;;; copyright: (c) Simon Nielsen Knights <tauoverpi@yandex.com>
;;; license  : GPLv3
;;; synopsis : 64bit Forth system written in FASM
; vim: ft=fasm et
except.abort                                         equ -1
except.abort_dquote                                  equ -2
except.stack_overflow                                equ -3
except.stack_underflow                               equ -4
except.return_stack_overflow                         equ -5
except.return_stack_underflow                        equ -6
except.do_loops_nested_too_deeply_during_execution   equ -7
except.dictionary_overflow                           equ -8
except.invalid_memory_address                        equ -9
except.division_by_zero                              equ -10
except.result_out_of_range                           equ -11
except.argument_type_mismatch                        equ -12
except.undefined_word                                equ -13
except.interpreting_a_compile-only_word              equ -14
except.invalid_forget                                equ -15
except.attempt_to_use_zero_length_string_as_a_name   equ -16
except.pictured_numeric_output_string_overflow       equ -17
except.parsed_string_overflow                        equ -18
except.definition_name_too_long                      equ -19
except.write_to a_read_only_location                 equ -20
except.unsupported_operation                         equ -21
except.control_structure_mismatch                    equ -22
except.address_alignment_exception                   equ -23
except.invalid_numeric_argument                      equ -24
except.return_stack_imbalance                        equ -25
except.loop_parameters_unavailable                   equ -26
except.invalid_recursion                             equ -27
except.user_interrupt                                equ -28
except.compiler_nesting                              equ -29
except.obsolescent_feature                           equ -30
except.to_body_used_on_non_created_definition        equ -31
except.invalid_name_argument                         equ -32
except.block_read_exception                          equ -33
except.block_write_exception                         equ -34
except.invalid_block_number                          equ -35
except.invalid_file_position                         equ -36
except.file_i/o_exception                            equ -37
except.non_existent_file                             equ -38
except.unexpected_end_of_file                        equ -39
except.invalid_base_for_floating_point_conversion    equ -40
except.loss_of_precision                             equ -41
except.floating_point_divide_by_zero                 equ -42
except.floating_point_result_out_of_range            equ -43
except.floating_point_stack_overflow                 equ -44
except.floating_point_stack_underflow                equ -45
except.floating_point_invalid_argument               equ -46
except.compilation_word_list_deleted                 equ -47
except.invalid_postpone                              equ -48
except.search_order_overflow                         equ -49
except.search_order_underflow                        equ -50
except.compilation_word_list_changed                 equ -51
except.control_flow_stack_overflow                   equ -52
except.exception_stack_overflow                      equ -53
except.floating_point_underflow                      equ -54
except.floating_point_unidentified_fault             equ -55
except.quit                                          equ -56
except.exception_in_sending_or_receiving_a_character equ -57
except.if_else_or_then_exception                     equ -58
except.allocate                                      equ -59
except.free                                          equ -60
except.resize                                        equ -61
except.close_file                                    equ -62
except.create_file                                   equ -63
except.delete_file                                   equ -64
except.file_position                                 equ -65
except.file_size                                     equ -66
except.file_status                                   equ -67
except.flush_file                                    equ -68
except.open_file                                     equ -69
except.read_file                                     equ -70
except.read_line                                     equ -71
except.rename_file                                   equ -72
except.reposition_file                               equ -73
except.resize_file                                   equ -74
except.write_file                                    equ -75
except.write_line                                    equ -76
except.malformed_xchar                               equ -77
except.substitute                                    equ -78
except.replaces                                      equ -79

macro pushexcept {
  pushrsp kernel.ip
  pushrsp kernel.sp
  pushrsp kernel.rsp
}

macro popexcept {
  poprsp kernel.ip
  poprsp kernel.sp
  poprsp kernel.rsp
}

prim__catch:
  pushexcept
  next

prim__throw:
  popexcept
  next

prim__abort:
prim__abort_str:
