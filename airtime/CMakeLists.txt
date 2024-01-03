cmake_minimum_required(VERSION 3.26.3)

set(libs
 assert
 config
 mp11
 describe
 container_hash
 static_assert
 core
 preprocessor
 detail
 io
 concept_check
 typeof
 conversion
 mpl
 function_types
 tuple
 bind
 function
 functional
 fusion
 optional
 iterator
 move
 smart_ptr
 throw_exception
 variant2
 winapi
 system
 type_traits
 preprocessor
 utility
 align
 atomic
 predef
 filesystem

 unordered
 regex
 tokenizer
 range
 numeric/conversion
 array
 rational
 ratio
 integer
 lexical_cast
 algorithm
 intrusive
 exception
 date_time
 container
 chrono
 thread

 serialization
 any
 format
 multi_index
 property_tree

 variant
 pool
 endian
 context
 dynamic_bitset
 spirit
 coroutine
 random
 interprocess
 asio
 type_index
 proto
 phoenix
 parameter
 log
 circular_buffer
 sort
 signals2
 random
 program_options
 heap
 tti
 uuid
 test
 )

 add_definitions(-DBOOST_TEST_NO_MAIN)


foreach(lib IN LISTS libs)
  add_subdirectory_once(${at_media_deps_dir}/boost/libs/${lib} ${CMAKE_BINARY_DIR}/boost/src/${lib})
endforeach()