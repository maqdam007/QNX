TARGET_LIB := libTest.so

BUILD_DIR := ./build
SRC_DIRS := ./src

CXX := q++

SRCS := $(shell find $(SRC_DIRS) -name '*.cpp')

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))
LIB_DESTDIR?= /usr/local/lib/

INC_SRCDIR?= src/private/include
INC_DESTDIR?= /usr/local/include/


CPPFLAGS := $(INC_FLAGS) -MMD -MP -fPIC
LDFLAGS  := -shared
QCCFLAGS := -V gcc_ntoaarch64le

$(BUILD_DIR)/$(TARGET_LIB): $(OBJS)
        $(CXX) $(QCCFLAGS) $(OBJS) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
        mkdir -p $(dir $@)
        $(CXX) $(QCCFLAGS) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
        rm -r $(BUILD_DIR)/*

.PHONY: install
install:
        cp -r ${INC_SRCDIR}/*.hpp ${INC_DESTDIR}
        cp -r ${BUILD_DIR}/*.so ${LIB_DESTDIR}

-include $(DEPS)
