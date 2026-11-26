macro(patch_sources _inlist _outlist)
    foreach(_file IN ITEMS ${${_inlist}})
        cmake_path(GET _file FILENAME _name)
        if(EXISTS ${PROJECT_SOURCE_DIR}/patches/${_name}.patch)
            add_custom_command(
                OUTPUT
                    ${_file}
                COMMENT
                    "Patching ${_file}"
                COMMAND
                    ${Python_EXECUTABLE} ${PROJECT_SOURCE_DIR}/src/scripts/apply_patch.py
                        --input ${PROJECT_SOURCE_DIR}/vendor/LinearCapR/${_file}
                        --patch ${PROJECT_SOURCE_DIR}/patches/${_name}.patch
                        --output ${CMAKE_CURRENT_BINARY_DIR}/${_file}
                DEPENDS
                    ${PROJECT_SOURCE_DIR}/vendor/LinearCapR/${_file}
                    ${PROJECT_SOURCE_DIR}/patches/${_name}.patch
            )
        else()
            add_custom_command(
                OUTPUT
                    ${_file}
                COMMENT
                    "Copying ${_file}"
                COMMAND
                    cmake -E copy ${PROJECT_SOURCE_DIR}/vendor/LinearCapR/${_file} ${CMAKE_CURRENT_BINARY_DIR}/${_file}
                DEPENDS
                    ${PROJECT_SOURCE_DIR}/vendor/LinearCapR/${_file}
            )
        endif()
        set(${_outlist} ${${_outlist}} ${CMAKE_CURRENT_BINARY_DIR}/${_file})
    endforeach()
endmacro()

# --- Patch/copy headers -------------------------------------------------------

set(LINEARCAPR_HEADERS
    beam_prune.hpp
    debug.hpp
    dp_table_api.hpp
    energy_model.hpp
    energy_param.hpp
    FileReader.hpp
    intloops.hpp
    legacy_energy_param.hpp
    legacy_intloops.hpp
    LinCapR.hpp
    miscs.hpp
)
patch_sources(LINEARCAPR_HEADERS LINEARCAPR_PATCHED_HEADERS)

# --- Patch/copy sources -------------------------------------------------------

set(LINEARCAPR_SOURCES
    debug.cpp
    legacy_energy_param.cpp
    FileReader.cpp
    LinCapR.cpp
)
patch_sources(LINEARCAPR_SOURCES LINEARCAPR_PATCHED_SOURCES)

# --- Compile core library -----------------------------------------------------

add_library(linearcapr STATIC ${LINEARCAPR_PATCHED_HEADERS} ${LINEARCAPR_PATCHED_SOURCES})
target_include_directories(linearcapr PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
