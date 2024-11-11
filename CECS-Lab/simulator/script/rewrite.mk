default: VCPU
include VCPU.mk
CXXFLAGS += -MMD -O3 -std=c++14 -fno-exceptions -fPIE -Wno-unused-result
CXXFLAGS += $(shell llvm-config --cxxflags) -fPIC -DDEVICE
LDFLAGS += -O3 -rdynamic -shared -fPIC
LIBS += $(shell llvm-config --libs)
LIBS += -lreadline -ldl -pie -lSDL2
LINK := g++