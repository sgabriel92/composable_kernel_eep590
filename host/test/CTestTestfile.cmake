# CMake generated Testfile for 
# Source directory: /root/workspace/composable_kernel/test
# Build directory: /root/workspace/composable_kernel/host/test
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
subdirs("../_deps/googletest-build")
subdirs("magic_number_division")
subdirs("space_filling_curve")
subdirs("conv_util")
subdirs("reference_conv_fwd")
subdirs("gemm")
subdirs("gemm_layernorm")
subdirs("gemm_split_k")
subdirs("gemm_reduce")
subdirs("batched_gemm")
subdirs("batched_gemm_reduce")
subdirs("batched_gemm_gemm")
subdirs("batched_gemm_softmax_gemm")
subdirs("batched_gemm_softmax_gemm_permute")
subdirs("grouped_gemm")
subdirs("reduce")
subdirs("convnd_fwd")
subdirs("convnd_bwd_data")
subdirs("grouped_convnd_fwd")
subdirs("grouped_convnd_bwd_weight")
subdirs("block_to_ctile_map")
subdirs("softmax")
subdirs("normalization")
subdirs("data_type")
subdirs("elementwise_normalization")
subdirs("batchnorm")
subdirs("contraction")
subdirs("pool")
subdirs("batched_gemm_multi_d")
subdirs("grouped_convnd_bwd_data")
subdirs("image_to_column")