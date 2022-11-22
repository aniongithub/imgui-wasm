project (imgui)
cmake_minimum_required(VERSION 3.5.1)

option(JS_ONLY "Compile to native JS (No WASM)" ON)

set(CMAKE_TOOLCHAIN_FILE "${EMSDK_ROOT}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -std=c++11")

add_definitions(-std=c++11 -O3)
include_directories(include ${OPENGL_INCLUDE_DIR} $ENV{IMGUI_ROOT} $ENV{IMGUI_ROOT}/backends)

# file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.cpp)
add_executable(${PROJECT_NAME} "src/main.cpp"
	"$ENV{IMGUI_ROOT}/backends/imgui_impl_glfw.cpp"
	"$ENV{IMGUI_ROOT}/backends/imgui_impl_opengl3.cpp"
	"$ENV{IMGUI_ROOT}/imgui.cpp"
	"$ENV{IMGUI_ROOT}/imgui_draw.cpp"
	"$ENV{IMGUI_ROOT}/imgui_demo.cpp"
	"$ENV{IMGUI_ROOT}/imgui_widgets.cpp"
	"$ENV{IMGUI_ROOT}/imgui_tables.cpp")

target_include_directories(${PROJECT_NAME} PRIVATE ${OPENGL_INCLUDE_DIR} $ENV{IMGUI_ROOT})
target_link_libraries(${PROJECT_NAME} PRIVATE ${OPENGL_LIBRARIES} ${GLFW3_LIBRARIES})

if(JS_ONLY)
	message(STATUS "Setting compilation target to native JavaScript")
	set(CMAKE_EXECUTABLE_SUFFIX ".js")
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-s WASM=0 -s EXPORTED_FUNCTIONS='[_main]' -s USE_WEBGL2=1 -s USE_GLFW=3 -s FULL_ES3=1")
else(JS_ONLY)
	message(STATUS "Setting compilation target to WASM")
	set(CMAKE_EXECUTABLE_SUFFIX ".wasm.js")
	set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-s WASM=1 -s EXPORTED_FUNCTIONS='[_main]' -s USE_WEBGL2=1 -s USE_GLFW=3 -s FULL_ES3=1")
endif(JS_ONLY)