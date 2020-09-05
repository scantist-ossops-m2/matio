if(MATIO_WITH_HDF5)
    find_package(HDF5)
    if(HDF5_FOUND)
        if(HDF5_VERSION VERSION_LESS 1.8)
            message(FATAL_ERROR "HDF5 version ${HDF5_VERSION} is unsupported, minimum of 1.8 is required")
        endif()
        set(HAVE_HDF5 1)
    endif()
endif()

if(MATIO_WITH_ZLIB)
    find_package(ZLIB 1.2.3)
    if(ZLIB_FOUND)
        set(HAVE_ZLIB 1)
    endif()
endif()

if(HDF5_FOUND)
    add_library(HDF5::HDF5 INTERFACE IMPORTED)
    if(HDF5_USE_STATIC_LIBRARIES AND TARGET hdf5::hdf5-static)
        # static target from hdf5 1.10 or 1.12 config
        target_link_libraries(HDF5::HDF5 INTERFACE hdf5::hdf5-static)
    elseif(NOT HDF5_USE_STATIC_LIBRARIES AND TARGET hdf5::hdf5-shared)
        # shared target from hdf5 1.10 or 1.12 config
        target_link_libraries(HDF5::HDF5 INTERFACE hdf5::hdf5-shared)
    elseif(TARGET hdf5)
        # target from hdf5 1.8 config
        target_link_libraries(HDF5::HDF5 INTERFACE hdf5)
        if(NOT HDF5_USE_STATIC_LIBRARIES)
            target_compile_definitions(HDF5::HDF5 INTERFACE "H5_BUILT_AS_DYNAMIC_LIB")
        endif()
    else()
        # results from CMake FindHDF5
        target_include_directories(HDF5::HDF5 INTERFACE "${HDF5_INCLUDE_DIRS}")
        target_link_libraries(HDF5::HDF5 INTERFACE "${HDF5_LIBRARIES}")
        target_compile_definitions(HDF5::HDF5 INTERFACE "${HDF5_DEFINITIONS}")
    endif()
endif()

if(NOT HAVE_HDF5 AND MATIO_MAT73)
    message(FATAL_ERROR "MAT73 requires HDF5")
endif()
