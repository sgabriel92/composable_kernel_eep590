#pragma once
#include <unistd.h>
#include "device.hpp"
#include "gridwise_direct_convolution_2.cuh"

template <class T, class InDesc, class WeiDesc, class OutDesc>
void device_direct_convolution_2(InDesc,
                                 const Tensor<T>& in,
                                 WeiDesc,
                                 const Tensor<T>& wei,
                                 OutDesc,
                                 Tensor<T>& out,
                                 unsigned nrepeat)
{
    std::size_t data_sz = sizeof(T);
    DeviceMem in_device_buf(data_sz * in.mDesc.GetElementSpace());
    DeviceMem wei_device_buf(data_sz * wei.mDesc.GetElementSpace());
    DeviceMem out_device_buf(data_sz * out.mDesc.GetElementSpace());

    int num_thread = std::thread::hardware_concurrency();

    in_device_buf.ToDevice(in.mData.data());
    wei_device_buf.ToDevice(wei.mData.data());
    out_device_buf.ToDevice(out.mData.data());

    constexpr auto I0 = Number<0>{};
    constexpr auto I1 = Number<1>{};
    constexpr auto I2 = Number<2>{};
    constexpr auto I3 = Number<3>{};

    constexpr auto in_desc  = InDesc{};
    constexpr auto wei_desc = WeiDesc{};
    constexpr auto out_desc = OutDesc{};

#if 1
    // 3x3, 34x34, 128 thread
    constexpr unsigned OutTileSizeH = 2;
    constexpr unsigned OutTileSizeW = 2;
    constexpr unsigned NPerBlock    = 2;
    constexpr unsigned KPerBlock    = 32;
    constexpr unsigned CPerBlock    = 4;
    constexpr unsigned YPerBlock    = 1;
    constexpr unsigned XPerBlock    = 16;

    constexpr unsigned NPerThread = 2;
    constexpr unsigned KPerThread = 4;
    constexpr unsigned CPerThread = 2;

    constexpr unsigned BlockSize = 128;
#elif 0
    // 3x3, 34x34, 256 thread
    constexpr unsigned OutTileSizeH = 2;
    constexpr unsigned OutTileSizeW = 2;
    constexpr unsigned NPerBlock    = 2;
    constexpr unsigned KPerBlock    = 32;
    constexpr unsigned CPerBlock    = 4;
    constexpr unsigned YPerBlock    = 1;
    constexpr unsigned XPerBlock    = 32;

    constexpr unsigned NPerThread = 2;
    constexpr unsigned KPerThread = 4;
    constexpr unsigned CPerThread = 2;

    constexpr unsigned BlockSize = 256;
#endif

    constexpr unsigned GridSize = (out_desc.GetLength(I0) / NPerBlock) *
                                  (out_desc.GetLength(I1) / KPerBlock) *
                                  (out_desc.GetLength(I2) / (OutTileSizeH * YPerBlock)) *
                                  (out_desc.GetLength(I3) / (OutTileSizeW * XPerBlock));

    dim3 block_dim(BlockSize);
    dim3 grid_dim(GridSize);

    printf("%s: BlockSize %u, GridSize %u \n", __func__, BlockSize, GridSize);

    for(unsigned i = 0; i < nrepeat; ++i)
    {
        const void* f = reinterpret_cast<const void*>(gridwise_direct_convolution_2<T,
                                                                                    InDesc,
                                                                                    WeiDesc,
                                                                                    OutDesc,
                                                                                    OutTileSizeH,
                                                                                    OutTileSizeW,
                                                                                    NPerBlock,
                                                                                    KPerBlock,
                                                                                    CPerBlock,
                                                                                    YPerBlock,
                                                                                    XPerBlock,
                                                                                    NPerThread,
                                                                                    KPerThread,
                                                                                    CPerThread,
                                                                                    BlockSize,
                                                                                    GridSize>);

        T* in_dev_ptr  = static_cast<T*>(in_device_buf.GetDeviceBuffer());
        T* wei_dev_ptr = static_cast<T*>(wei_device_buf.GetDeviceBuffer());
        T* out_dev_ptr = static_cast<T*>(out_device_buf.GetDeviceBuffer());

        void* args[] = {&in_dev_ptr, &wei_dev_ptr, &out_dev_ptr};

        float time = 0;

        launch_kernel(f, grid_dim, block_dim, args, time);

        printf("Elapsed time : %f ms\n", time);
        usleep(std::min(time * 1000, float(10000)));
    }

    out_device_buf.FromDevice(out.mData.data());
}
