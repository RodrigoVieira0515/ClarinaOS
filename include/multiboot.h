#pragma once
namespace Multiboot {
    constexpr uint32_t magic = 0x2BADB002;
    struct info {
        uint32_t flags;

        uint32_t mem_lower;
        uint32_t mem_upper;

        uint32_t boot_device;
        //dont care about the rest
    };
}