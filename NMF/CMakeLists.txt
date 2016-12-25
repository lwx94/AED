# project name
PROJECT(AED_NMF)
#head file paths
INCLUDE_DIRECTORIES(include)
#source file paths
AUX_SOURCE-DIRECTORIES(src DIR_SRCS)
SET(AED_NMF_PATH DIR_SRCS)
#add executable
ADD_EXECUTABLE(../bin/bin ${})
TARGET_LINK_LIBRARIES(../bin/bin m)