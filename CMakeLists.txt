#
# Copyright © Airtime Media 2014-2019
#

function(at_boost_add_library LIB)
  set(_sources ${ARGN})
  set(_target ${LIB})

  add_library(${_target} STATIC ${_sources})
  target_include_directories(${_target} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
endfunction(at_boost_add_library)


##
## THREAD
##
set(BOOST_THREAD_SOURCES
  libs/thread/src/future.cpp
  libs/thread/src/pthread/once.cpp
  libs/thread/src/pthread/once_atomic.cpp
  libs/thread/src/pthread/thread.cpp
)

at_boost_add_library(at_boost_thread ${BOOST_THREAD_SOURCES})

target_compile_definitions(at_boost_thread
   PRIVATE BOOST_THREAD_USE_LIB=1
   PRIVATE BOOST_THREAD_POSIX=1
   PRIVATE BOOST_THREAD_DONT_USE_CHRONO=1
   PRIVATE BOOST_THREAD_THROW_IF_PRECONDITION_NOT_SATISFIED=1
   PUBLIC BOOST_SYSTEM_NO_DEPRECATED=1
 #  PUBLIC BOOST_THREAD_DONT_PROVIDE_INTERRUPTIONS=1
)

##
## ATOMIC
##
set(BOOST_ATOMIC_SOURCES
  libs/atomic/src/find_address_sse2.cpp
  libs/atomic/src/find_address_sse41.cpp
  libs/atomic/src/lock_pool.cpp
  libs/atomic/src/lock_pool_init1.ipp
  libs/atomic/src/lock_pool_init256.ipp
  libs/atomic/src/wait_ops_windows.cpp
)

at_boost_add_library(at_boost_atomic STATIC ${BOOST_ATOMIC_SOURCES})

##
## RANDOM
##
set(BOOST_RANDOM_SOURCES
  libs/random/src/random_device.cpp
)

at_boost_add_library(at_boost_random STATIC ${BOOST_RANDOM_SOURCES})


##
## FILESYSTEM
##
set(BOOST_FILESYSTEM_SOURCES
  libs/filesystem/src/codecvt_error_category.cpp
  libs/filesystem/src/directory.cpp
  libs/filesystem/src/exception.cpp
  libs/filesystem/src/operations.cpp
  libs/filesystem/src/path.cpp
  libs/filesystem/src/path_traits.cpp
  libs/filesystem/src/portability.cpp
  libs/filesystem/src/unique_path.cpp
  libs/filesystem/src/utf8_codecvt_facet.cpp
  libs/filesystem/src/windows_file_codecvt.cpp
)
at_boost_add_library(at_boost_filesystem ${BOOST_FILESYSTEM_SOURCES})
set_target_properties(at_boost_filesystem
   PROPERTIES COMPILE_FLAGS "-Wno-unknown-warning-option -Wno-overloaded-virtual -Wno-undefined-bool-conversion -Wno-deprecated-declarations"
)

##
## REGEX
##

set(BOOST_REGEX_SOURCES
  libs/regex/src/posix_api.cpp
  libs/regex/src/regex.cpp
  libs/regex/src/regex_debug.cpp
  libs/regex/src/static_mutex.cpp
  libs/regex/src/wide_posix_api.cpp
)
at_boost_add_library(at_boost_regex ${BOOST_REGEX_SOURCES})

set_target_properties(at_boost_regex
   PROPERTIES COMPILE_FLAGS "-Wno-deprecated-declarations"
)

##
## LOG
##
set(BOOST_LOG_SOURCES
  libs/log/src/attribute_name.cpp
  libs/log/src/attribute_set.cpp
  libs/log/src/attribute_value_set.cpp
  libs/log/src/code_conversion.cpp
  libs/log/src/core.cpp
  libs/log/src/date_time_format_parser.cpp
  libs/log/src/record_ostream.cpp
  libs/log/src/severity_level.cpp
  libs/log/src/global_logger_storage.cpp
  libs/log/src/named_scope.cpp
  libs/log/src/permissions.cpp
  libs/log/src/record_ostream.cpp
  libs/log/src/process_name.cpp
  libs/log/src/process_id.cpp
  libs/log/src/thread_id.cpp
  libs/log/src/thread_specific.cpp
  libs/log/src/timer.cpp
  libs/log/src/exceptions.cpp
  libs/log/src/default_attribute_names.cpp
  libs/log/src/default_sink.cpp
  libs/log/src/text_ostream_backend.cpp
  libs/log/src/text_file_backend.cpp
  libs/log/src/text_multifile_backend.cpp
  libs/log/src/syslog_backend.cpp
  libs/log/src/thread_specific.cpp
  libs/log/src/once_block.cpp
  libs/log/src/timestamp.cpp
  libs/log/src/threadsafe_queue.cpp
  libs/log/src/event.cpp
  libs/log/src/trivial.cpp
  libs/log/src/spirit_encoding.cpp
  libs/log/src/format_parser.cpp
  libs/log/src/date_time_format_parser.cpp
  libs/log/src/named_scope_format_parser.cpp
  libs/log/src/dump.cpp
  libs/log/src/dump_avx2.cpp
  libs/log/src/dump_ssse3.cpp

  # boost_log_setup
  libs/log/src/setup/default_filter_factory.cpp
  libs/log/src/setup/default_formatter_factory.cpp
  libs/log/src/setup/filter_parser.cpp
  libs/log/src/setup/formatter_parser.cpp
  libs/log/src/setup/init_from_settings.cpp
  libs/log/src/setup/init_from_stream.cpp
  libs/log/src/setup/matches_relation_factory.cpp
  libs/log/src/setup/parser_utils.cpp
  libs/log/src/setup/settings_parser.cpp
)

at_boost_add_library(at_boost_log ${BOOST_LOG_SOURCES})
target_link_libraries(at_boost_log LINK_PUBLIC
  at_boost_thread
  at_boost_filesystem
  at_boost_regex
)
target_include_directories(at_boost_log PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libs/log/src)
target_compile_definitions(at_boost_log
   PRIVATE BOOST_LOG_BUILDING_THE_LIB=1
  # PUBLIC BOOST_LOG_WITHOUT_EVENT_LOG=1
   PRIVATE BOOST_THREAD_DONT_USE_CHRONO=1
   PRIVATE BOOST_SPIRIT_USE_PHOENIX_V3=1
   PRIVATE BOOST_LOG_USE_NATIVE_SYSLOG=1   # CAR-255, CAR-261
)

if (NOT IOS)
  target_compile_definitions(at_boost_log 
    # without this, if some static object logs at its dtor, boost log crashes at __cxa_finalize_ranges
    PRIVATE BOOST_LOG_USE_COMPILER_TLS=1
  )
endif()

set_target_properties(at_boost_log
   PROPERTIES COMPILE_FLAGS "-ftemplate-depth-1024 -Wno-deprecated-declarations -march=native"
)

##
## UNITTEST
##
set(BOOST_EXECUTION_MONITOR_SOURCES
  libs/test/src/execution_monitor.cpp
  libs/test/src/debug.cpp
  libs/test/src/cpp_main.cpp
)

at_boost_add_library(at_boost_execution_monitor ${BOOST_EXECUTION_MONITOR_SOURCES})

target_compile_definitions(at_boost_execution_monitor
  PUBLIC BOOST_TEST_NO_MAIN=1
)

set_target_properties(at_boost_execution_monitor
   PROPERTIES COMPILE_FLAGS "-Wno-deprecated-declarations"
)

set(BOOST_UNITTEST_SOURCES
  libs/test/src/compiler_log_formatter.cpp
  libs/test/src/framework.cpp
  libs/test/src/plain_report_formatter.cpp
  libs/test/src/progress_monitor.cpp
  libs/test/src/results_collector.cpp
  libs/test/src/results_reporter.cpp
  libs/test/src/test_main.cpp
  libs/test/src/test_tools.cpp
  libs/test/src/unit_test_log.cpp
  libs/test/src/unit_test_main.cpp
  libs/test/src/unit_test_monitor.cpp
  libs/test/src/unit_test_parameters.cpp
  libs/test/src/xml_log_formatter.cpp
  libs/test/src/xml_report_formatter.cpp
  libs/test/src/test_tree.cpp
  libs/test/src/test_framework_init_observer.cpp
  libs/test/src/decorator.cpp
  libs/test/src/junit_log_formatter.cpp
  libs/test/src/test_framework_init_observer.cpp
  libs/test/src/unit_test_parameters.cpp
)

at_boost_add_library(at_boost_unittest ${BOOST_UNITTEST_SOURCES})

target_link_libraries(at_boost_unittest LINK_PUBLIC
  at_boost_execution_monitor
)

set_target_properties(at_boost_unittest
   PROPERTIES COMPILE_FLAGS "-Wno-deprecated-declarations"
)

##
## SYSTEM
##
set(BOOST_SYSTEM_SOURCES
  libs/system/src/error_code.cpp
)

at_boost_add_library(at_boost_system ${BOOST_SYSTEM_SOURCES})

target_compile_definitions(at_boost_system
   PRIVATE BOOST_SYSTEM_STATIC_LINK=1
)

set(BOOST_PROGRAM_OPTIONS_SOURCES
  libs/program_options/src/cmdline.cpp
  libs/program_options/src/config_file.cpp
  libs/program_options/src/convert.cpp
  libs/program_options/src/options_description.cpp
  libs/program_options/src/parsers.cpp
  libs/program_options/src/variables_map.cpp
  libs/program_options/src/value_semantic.cpp
  libs/program_options/src/positional_options.cpp
  libs/program_options/src/utf8_codecvt_facet.cpp
  libs/program_options/src/winmain.cpp
  libs/program_options/src/split.cpp
)
at_boost_add_library(at_boost_program_options ${BOOST_PROGRAM_OPTIONS_SOURCES})
set_target_properties(at_boost_program_options
   PROPERTIES COMPILE_FLAGS "-Wno-overloaded-virtual"
)

