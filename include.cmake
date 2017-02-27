find_package(Qt5 ${ARGS_CMAKE_VERSION} COMPONENTS ${ARGS_COMPONENTS} QUIET ${ARGS_FIND_OPTIONS})

if(NOT Qt5_FOUND)
  if(MSVC)
    set(QT_RUNTIME_DIR "msvc${CGET_MSVC_RUNTIME_YEAR}")
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    set(QT_RUNTIME_DIR "gcc")
  endif()

  if(CGET_ARCH MATCHES "x64")
    set(QT_RUNTIME_DIR "${QT_RUNTIME_DIR}_64")
  endif()
  
  set(QT_VERSIONS 5.10 5.9 5.8 5.7 5.6 5.5 5.4) # future proof-ish
  set(DEFAULT_BASE_PATHS
    "C:/Qt/\${QT_VERSION}"
    "/opt/Qt/\${QT_VERSION}"
    "$ENV{HOME}/Qt/\${QT_VERSION}"
    "C:/Qt/\${QT_VERSION}.0/\${QT_VERSION}"
    "/Library/Qt\${QT_VERSION}.0/\${QT_VERSION}"    
    "/opt/Qt\${QT_VERSION}.0/\${QT_VERSION}/")

  SET(FOUND_BASE_DIR OFF)
  SET(FOUND_BASE_COMPILER_DIR OFF)
  foreach(QT_VERSION ${QT_VERSIONS})
    foreach(DEFAULT_BASE_PATH_TEMPLATE ${DEFAULT_BASE_PATH})
      set(DEFAULT_BASE_PATH "${DEFAULT_BASE_PATH_TEMPLATE}")
      message("Checking ${DEFAULT_BASE_PATH}")

      if(EXISTS "${DEFAULT_BASE_PATH}")
	message("Found ${DEFAULT_BASE_PATH}")
	  SET(FOUND_BASE_DIR ON)
	  if(EXISTS "${DEFAULT_BASE_PATH}/${QT_RUNTIME_DIR}")
	    SET(FOUND_BASE_COMPILER_DIR ON)
	    
	    SET(Qt5_DIR "${DEFAULT_BASE_PATH}/${QT_RUNTIME_DIR}")
	    find_package(Qt5 ${ARGS_CMAKE_VERSION} COMPONENTS ${ARGS_COMPONENTS} QUIET ${ARGS_FIND_OPTIONS})

	    if(Qt5_FOUND)
	      message("Found viable candidate for QT5 at ${Qt5_DIR}")
	      return()
	    endif()
	    
	  endif()    
      endif()     
    endforeach()
  endforeach()

  IF(FOUND_BASE_DIR)
    IF(FOUND_BASE_COMPILER_DIR)
      MESSAGE(FATAL_ERROR "Found a viable installation path, with the correct run-time installed but some of the components could not be found.")
    ELSE()
      MESSAGE(FATAL_ERROR "Found a viable installation path, but the correct runtime directory didn't exist. Please make sure you have the runtime for ${QT_RUNTIME_DIR} installed.")
    ENDIF()
  ELSE(FOUND_BASE_DIR)
    MESSAGE(FATAL_ERROR "Could not find any Qt5 installations. You will have to set Qt5_DIR manually. \n\t * If you don't have QT5 installed, please go here: https://www.qt.io/download-open-source/ \n\t * If you do have QT5 installed, and it is at a custom location, you have to set Qt5_DIR\n\t * If you do have it installed to a default location, please file a bug here: https://github.com/cget/Qt5.cget/issues")
  ENDIF()
  
endif()
