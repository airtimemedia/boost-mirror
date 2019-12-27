#
# Copyright Airtime Media 2014
#

function(at_boost_add_library LIB)
  set(_sources ${ARGN})
  set(_target ${LIB})

  add_library(${_target} STATIC ${_sources})
  target_include_directories(${_target} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
endfunction(at_boost_add_library)


##
## THREAD
##
set(BOOST_THREAD_SOURCES
  src/libs/thread/src/future.cpp
  src/libs/thread/src/pthread/once.cpp
  src/libs/thread/src/pthread/thread.cpp
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
  src/libs/atomic/src/lockpool.cpp
)

at_boost_add_library(at_boost_atomic STATIC ${BOOST_ATOMIC_SOURCES})

##
## RANDOM
##
set(BOOST_RANDOM_SOURCES
  src/libs/random/src/random_device.cpp
)

at_boost_add_library(at_boost_random STATIC ${BOOST_RANDOM_SOURCES})


##
## FILESYSTEM
##
set(BOOST_FILESYSTEM_SOURCES
  src/libs/filesystem/src/codecvt_error_category.cpp
  src/libs/filesystem/src/operations.cpp
  src/libs/filesystem/src/path.cpp
  src/libs/filesystem/src/path_traits.cpp
  src/libs/filesystem/src/portability.cpp
  src/libs/filesystem/src/unique_path.cpp
  src/libs/filesystem/src/utf8_codecvt_facet.cpp
)
at_boost_add_library(at_boost_filesystem ${BOOST_FILESYSTEM_SOURCES})
set_target_properties(at_boost_filesystem
   PROPERTIES COMPILE_FLAGS "-Wno-unknown-warning-option -Wno-overloaded-virtual -Wno-undefined-bool-conversion -Wno-deprecated-declarations"
)

##
## REGEX
##

set(BOOST_REGEX_SOURCES
  src/libs/regex/src/c_regex_traits.cpp
  src/libs/regex/src/cpp_regex_traits.cpp
  src/libs/regex/src/cregex.cpp
  src/libs/regex/src/fileiter.cpp
  src/libs/regex/src/icu.cpp
  src/libs/regex/src/instances.cpp
  src/libs/regex/src/posix_api.cpp
  src/libs/regex/src/regex.cpp
  src/libs/regex/src/regex_debug.cpp
  src/libs/regex/src/regex_raw_buffer.cpp
  src/libs/regex/src/regex_traits_defaults.cpp
  src/libs/regex/src/static_mutex.cpp
  src/libs/regex/src/usinstances.cpp
  src/libs/regex/src/w32_regex_traits.cpp
  src/libs/regex/src/wc_regex_traits.cpp
  src/libs/regex/src/wide_posix_api.cpp
  src/libs/regex/src/winstances.cpp
)
at_boost_add_library(at_boost_regex ${BOOST_REGEX_SOURCES})

set_target_properties(at_boost_regex
   PROPERTIES COMPILE_FLAGS "-Wno-deprecated-declarations"
)

##
## LOG
##
set(BOOST_LOG_SOURCES
  src/libs/log/src/attribute_name.cpp
  src/libs/log/src/attribute_set.cpp
  src/libs/log/src/attribute_value_set.cpp
  src/libs/log/src/code_conversion.cpp
  src/libs/log/src/core.cpp
  src/libs/log/src/record_ostream.cpp
  src/libs/log/src/severity_level.cpp
  src/libs/log/src/global_logger_storage.cpp
  src/libs/log/src/named_scope.cpp
  src/libs/log/src/process_name.cpp
  src/libs/log/src/process_id.cpp
  src/libs/log/src/thread_id.cpp
  src/libs/log/src/timer.cpp
  src/libs/log/src/exceptions.cpp
  src/libs/log/src/default_attribute_names.cpp
  src/libs/log/src/default_sink.cpp
  src/libs/log/src/text_ostream_backend.cpp
  src/libs/log/src/text_file_backend.cpp
  src/libs/log/src/syslog_backend.cpp
  src/libs/log/src/thread_specific.cpp
  src/libs/log/src/once_block.cpp
  src/libs/log/src/timestamp.cpp
  src/libs/log/src/threadsafe_queue.cpp
  src/libs/log/src/event.cpp
  src/libs/log/src/trivial.cpp
  src/libs/log/src/spirit_encoding.cpp
  src/libs/log/src/format_parser.cpp
  src/libs/log/src/date_time_format_parser.cpp
  src/libs/log/src/named_scope_format_parser.cpp
  src/libs/log/src/dump.cpp

  # boost_log_setup
  src/libs/log/src/setup/default_filter_factory.cpp
  src/libs/log/src/setup/default_formatter_factory.cpp
  src/libs/log/src/setup/filter_parser.cpp
  src/libs/log/src/setup/formatter_parser.cpp
  src/libs/log/src/setup/init_from_settings.cpp
  src/libs/log/src/setup/init_from_stream.cpp
  src/libs/log/src/setup/matches_relation_factory.cpp
  src/libs/log/src/setup/parser_utils.cpp
  src/libs/log/src/setup/settings_parser.cpp
)

at_boost_add_library(at_boost_log ${BOOST_LOG_SOURCES})
target_link_libraries(at_boost_log LINK_PUBLIC
  at_boost_thread
  at_boost_filesystem
  at_boost_regex
)
target_include_directories(at_boost_log PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/libs/log/src)
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
   PROPERTIES COMPILE_FLAGS "-ftemplate-depth-1024 -Wno-deprecated-declarations"
)

##
## UNITTEST
##
set(BOOST_EXECUTION_MONITOR_SOURCES
  src/libs/test/src/execution_monitor.cpp
  src/libs/test/src/debug.cpp
  src/libs/test/src/cpp_main.cpp
)

at_boost_add_library(at_boost_execution_monitor ${BOOST_EXECUTION_MONITOR_SOURCES})

target_compile_definitions(at_boost_execution_monitor
  PUBLIC BOOST_TEST_NO_MAIN=1
)

set_target_properties(at_boost_execution_monitor
   PROPERTIES COMPILE_FLAGS "-Wno-deprecated-declarations"
)

set(BOOST_UNITTEST_SOURCES
  src/libs/test/src/compiler_log_formatter.cpp
  src/libs/test/src/framework.cpp
  src/libs/test/src/plain_report_formatter.cpp
  src/libs/test/src/progress_monitor.cpp
  src/libs/test/src/results_collector.cpp
  src/libs/test/src/results_reporter.cpp
  src/libs/test/src/test_main.cpp
  src/libs/test/src/test_tools.cpp
  src/libs/test/src/unit_test_log.cpp
  src/libs/test/src/unit_test_main.cpp
  src/libs/test/src/unit_test_monitor.cpp
  src/libs/test/src/unit_test_parameters.cpp
  src/libs/test/src/xml_log_formatter.cpp
  src/libs/test/src/xml_report_formatter.cpp
  src/libs/test/src/test_tree.cpp
  src/libs/test/src/test_framework_init_observer.cpp
  src/libs/test/src/decorator.cpp
  src/libs/test/src/junit_log_formatter.cpp
  src/libs/test/src/test_framework_init_observer.cpp
  src/libs/test/src/unit_test_parameters.cpp
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
  src/libs/system/src/error_code.cpp
)

at_boost_add_library(at_boost_system ${BOOST_SYSTEM_SOURCES})

target_compile_definitions(at_boost_system
   PRIVATE BOOST_SYSTEM_STATIC_LINK=1
)

set(BOOST_PROGRAM_OPTIONS_SOURCES
  src/libs/program_options/src/cmdline.cpp
  src/libs/program_options/src/config_file.cpp
  src/libs/program_options/src/options_description.cpp
  src/libs/program_options/src/parsers.cpp
  src/libs/program_options/src/variables_map.cpp
  src/libs/program_options/src/value_semantic.cpp
  src/libs/program_options/src/positional_options.cpp
  src/libs/program_options/src/utf8_codecvt_facet.cpp
  src/libs/program_options/src/convert.cpp
  src/libs/program_options/src/split.cpp
)
at_boost_add_library(at_boost_program_options ${BOOST_PROGRAM_OPTIONS_SOURCES})
set_target_properties(at_boost_program_options
   PROPERTIES COMPILE_FLAGS "-Wno-overloaded-virtual"
)
