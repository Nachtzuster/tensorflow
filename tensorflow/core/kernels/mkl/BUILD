load(
    "@local_xla//xla/tsl/mkl:build_defs.bzl",
    "mkl_deps",
)
load(
    "//tensorflow:tensorflow.bzl",
    "tf_cc_test_mkl",
    "tf_mkl_kernel_library",
)

package(
    # copybara:uncomment default_applicable_licenses = ["//tensorflow:license"],
    default_visibility = [
        "//tensorflow:__subpackages__",
        "//tensorflow:internal",
    ],
    licenses = ["notice"],
)

# Public support libraries ----------------------------------------------------
MKL_SHORT_DEPS = [
    "//tensorflow/core:core_cpu",
    "//tensorflow/core:framework",
    "//tensorflow/core:lib",
    "//tensorflow/core:lib_internal",
    "//tensorflow/core/framework:bounds_check",
    "//tensorflow/core/kernels:ops_util",
    "//tensorflow/core/util:onednn_env_vars",
] + mkl_deps()

MKL_DEPS = MKL_SHORT_DEPS + [
    "@eigen_archive//:eigen3",
    "//tensorflow/core:array_grad",
    "//tensorflow/core:math_grad",
    "//tensorflow/core:nn_grad",
    "//tensorflow/core:protos_all_cc",
    "//tensorflow/core/kernels:concat_lib",
    "//tensorflow/core/kernels:conv_2d",
    "@local_xla//xla/tsl/framework/contraction:eigen_contraction_kernel",
    "//tensorflow/core/kernels:fill_functor",
    "//tensorflow/core/kernels:gather_functor",
    "//tensorflow/core/kernels:transpose_functor",
]

MKL_TEST_DEPS = [
    "//tensorflow/cc:cc_ops",
    "//tensorflow/core:core_cpu",
    "//tensorflow/core:framework",
    "//tensorflow/core:framework_internal",
    "//tensorflow/core:lib",
    "//tensorflow/core:protos_all_cc",
    "//tensorflow/core:test",
    "//tensorflow/core:test_main",
    "//tensorflow/core:testlib",
    "//tensorflow/core/kernels:ops_testutil",
    "//tensorflow/core/kernels:ops_util",
    "//tensorflow/core/util:onednn_env_vars",
] + mkl_deps()

tf_mkl_kernel_library(
    name = "mkl_batch_matmul_op",
    srcs = ["mkl_batch_matmul_op.cc"],
    hdrs = [
        "mkl_batch_matmul_helper.h",
        "mkl_kernel_util.h",
        "mkl_matmul_ops_common.h",
    ],
    deps = [
        "//tensorflow/core:graph",
        "//tensorflow/core/kernels:batch_matmul_op",
        "//tensorflow/core/kernels:matmul_op",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_einsum_op",
    srcs = ["mkl_einsum_op.cc"],
    hdrs = [
        "mkl_batch_matmul_helper.h",
        "mkl_kernel_util.h",
        "mkl_matmul_ops_common.h",
    ],
    deps = [
        "//tensorflow/core:graph",
        "//tensorflow/core/kernels/linalg:einsum_op",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_matmul_op",
    srcs = [
        "mkl_matmul_op.cc",
        "mkl_matmul_op_fused.cc",
    ],
    hdrs = [
        "mkl_kernel_util.h",
        "mkl_matmul_ops_common.h",
        "mkl_quantized_conv_ops.h",
    ],
    deps = [
        "//tensorflow/core:graph",
        "@com_google_absl//absl/container:inlined_vector",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_sparse_matrix_matmul_op",
    srcs = [
        "mkl_sparse_matrix_matmul_op.cc",
    ],
    hdrs = [
        "mkl_kernel_util.h",
        "mkl_matmul_ops_common.h",
    ],
    deps = [
        "//tensorflow/core:graph",
        "//tensorflow/core/kernels:cwise_op",
        "//tensorflow/core/kernels:dense_update_functor",
        "//tensorflow/core/kernels/sparse:kernels",
        "//tensorflow/core/kernels/sparse:sparse_matrix",
    ] + MKL_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_sparse_matrix_matmul_op_benchmark",
    size = "small",
    srcs = ["mkl_sparse_matrix_matmul_op_benchmark.cc"],
    linkstatic = 1,
    deps = [
        "//tensorflow/core/kernels/mkl:mkl_sparse_matrix_matmul_op",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_quantized_conv_ops_perchannel_test",
    size = "small",
    srcs = ["mkl_quantized_conv_ops_perchannel_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_conv_op",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_quantized_conv_ops_test",
    size = "small",
    srcs = ["mkl_quantized_conv_ops_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_conv_op",
        ":mkl_kernel_util",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:direct_session",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/kernels:bias_op",
        "//tensorflow/core/kernels:conv_ops",
        "//tensorflow/core/kernels:depthwise_conv_op",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
        "//tensorflow/core/kernels:relu_op",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_qmatmul_op_test",
    size = "small",
    srcs = ["mkl_qmatmul_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_matmul_op",
        ":mkl_qmatmul_op",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/framework:fake_input",
        "//tensorflow/core/framework:tensor_testutil",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_quantize_op",
    srcs = ["mkl_quantize_op.cc"],
    deps = [
        "//tensorflow/core/graph:mkl_graph_util",
        "//tensorflow/core/kernels:quantized_ops",
        "@gemmlowp",
    ] + MKL_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_quantize_op_test",
    size = "small",
    srcs = ["mkl_quantize_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_quantize_op",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_quantized_pooling_ops_test",
    size = "small",
    srcs = ["mkl_quantized_pooling_ops_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_kernel_util",
        ":mkl_pooling_ops",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_quantized_concat_op_test",
    size = "small",
    srcs = ["mkl_quantized_concat_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_concat_op",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:mkl_array_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_qmatmul_op",
    srcs = ["mkl_qmatmul_op.cc"],
    hdrs = [
        "mkl_kernel_util.h",
        "mkl_matmul_ops_common.h",
        "mkl_quantized_conv_ops.h",
    ],
    deps = [
        "//tensorflow/core:graph",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:mkl_nn_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/kernels:matmul_op",
        "//tensorflow/core/kernels:no_op",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_conv_op",
    hdrs = [
        "mkl_kernel_util.h",
        "mkl_quantized_conv_ops.h",
    ],
    prefix = "mkl_conv",
    deps = [
        "//tensorflow/core:graph",
        "//tensorflow/core/kernels:conv_grad_shape_utils",
        "//tensorflow/core/kernels:conv_ops",
        "//tensorflow/core/kernels:no_op",
        "@com_google_absl//absl/strings",
    ] + MKL_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_conv_ops_test",
    size = "small",
    srcs = ["mkl_conv_ops_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_relu_op_test",
    size = "small",
    srcs = ["mkl_relu_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = ["@com_google_absl//absl/strings"] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_swish_op_test",
    size = "small",
    srcs = ["mkl_swish_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_eltwise_activation_base_op",
        ":mkl_swish_op",
        "//tensorflow/cc:math_ops",
        "//tensorflow/core:direct_session",
        "//tensorflow/core/kernels:cwise_op",
        "@com_google_absl//absl/strings",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_tfconv_op",
    prefix = "mkl_tfconv",
    deps = MKL_SHORT_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_pooling_ops",
    srcs = [
        "mkl_avgpooling_op.cc",
        "mkl_maxpooling_op.cc",
        "mkl_pooling_ops_common.cc",
    ],
    hdrs = ["mkl_pooling_ops_common.h"],
    deps = MKL_SHORT_DEPS + ["//tensorflow/core/kernels:pooling_ops_hdrs"],
)

tf_mkl_kernel_library(
    name = "mkl_dequantize_op",
    srcs = ["mkl_dequantize_op.cc"],
    deps = [
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:framework",
        "//tensorflow/core:lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
        "//tensorflow/core/graph:mkl_graph_util",
        "//tensorflow/core/kernels:concat_lib_hdrs",
        "//tensorflow/core/kernels:conv_ops",
        "//tensorflow/core/kernels:cwise_op",
        "//tensorflow/core/kernels:eigen_helpers",
        "//tensorflow/core/kernels:meta_support",
        "//tensorflow/core/kernels:pooling_ops",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
        "//tensorflow/core/kernels:transpose_functor",
        "//tensorflow/core/util:image_resizer_state",
        "//tensorflow/core/util:onednn_env_vars",
        "@gemmlowp",
    ] + mkl_deps(),
)

tf_cc_test_mkl(
    name = "mkl_dequantize_op_test",
    size = "small",
    srcs = ["mkl_dequantize_op_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_dequantize_op",
        ":mkl_kernel_util",
        ":mkl_tfconv_op",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core:mkl_array_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_relu_op",
    prefix = "mkl_relu",
    deps = MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_eltwise_activation_base_op",
    prefix = "mkl_eltwise_activation_base",
    deps = MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_swish_op",
    hdrs = ["mkl_eltwise_activation_base_op.h"],
    prefix = "mkl_swish",
    deps = MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_fused_mish_op",
    hdrs = ["mkl_eltwise_activation_base_op.h"],
    prefix = "mkl_fused_mish",
    deps = MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_softmax_op",
    prefix = "mkl_softmax",
    deps = [
        "//tensorflow/core/graph:mkl_graph_util",
        "@eigen_archive//:eigen3",
    ] + MKL_SHORT_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_tmp_ops",
    prefix = "mkl_tmp_ops",
    deps = MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_fused_batch_norm_op",
    srcs = ["mkl_fused_batch_norm_op.cc"],
    deps = [
        "//tensorflow/core/kernels:fused_batch_norm_op",
        "//tensorflow/core/kernels:no_op",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_layer_norm_op",
    srcs = ["mkl_layer_norm_op.cc"],
    deps = [
        "//tensorflow/core:mkl_nn_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
    ] + MKL_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_fused_batch_norm_op_test",
    size = "small",
    srcs = ["mkl_fused_batch_norm_op_test.cc"],
    linkstatic = 1,
    deps = [
        ":mkl_conv_op",
        ":mkl_fused_batch_norm_op",
        "//tensorflow/core:direct_session",
        "//tensorflow/core/graph:mkl_graph_util",
        "//tensorflow/core/kernels:conv_ops_gpu_hdrs",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_fused_instance_norm_op",
    srcs = ["mkl_fused_instance_norm_op.cc"],
    deps = [
        "//tensorflow/core:mkl_nn_ops_op_lib",
        "//tensorflow/core:nn_ops_op_lib",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_concat_op",
    prefix = "mkl_concat_op",
    deps = [
        "//tensorflow/core/kernels:no_op",
        "//tensorflow/core/kernels:quantization_utils",
    ] + MKL_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_requantize_ops",
    srcs = [
        "mkl_requantization_range_per_channel_op.cc",
        "mkl_requantize_per_channel_op.cc",
    ],
    deps = [
        "//tensorflow/core/kernels:concat_lib_hdrs",
        "//tensorflow/core/kernels:conv_ops",
        "//tensorflow/core/kernels:eigen_helpers",
        "//tensorflow/core/kernels:meta_support",
        "//tensorflow/core/kernels:no_op",
        "//tensorflow/core/kernels:pooling_ops",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/util:image_resizer_state",
        "@gemmlowp",
    ] + MKL_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_requantize_ops_test",
    size = "small",
    srcs = ["mkl_requantize_ops_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_requantize_ops",
        "//tensorflow/core:array_ops_op_lib",
        "//tensorflow/core:math_ops_op_lib",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:quantized_ops",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "mkl_fused_ops_test",
    size = "small",
    srcs = ["mkl_fused_ops_test.cc"],
    linkstatic = 1,
    deps = [
        ":mkl_conv_op",
        ":mkl_matmul_op",
        ":mkl_tfconv_op",
        "//tensorflow/cc:cc_ops_internal",
        "//tensorflow/core:direct_session",
        "//tensorflow/core:tensorflow",
        "//tensorflow/core/graph:mkl_graph_util",
        "//tensorflow/core/kernels:bias_op",
        "//tensorflow/core/kernels:conv_ops",
        "//tensorflow/core/kernels:depthwise_conv_op",
        "//tensorflow/core/kernels:matmul_op",
        "//tensorflow/core/kernels:pad_op",
        "//tensorflow/core/kernels:relu_op",
        "//tensorflow/core/kernels/image",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_transpose_op",
    srcs = [
        "mkl_transpose_op.cc",
    ],
    deps = MKL_DEPS + ["//tensorflow/core/kernels:transpose_op"],
)

tf_cc_test_mkl(
    name = "mkl_matmul_op_benchmark",
    size = "small",
    srcs = ["mkl_matmul_op_benchmark.cc"],
    linkstatic = 1,
    deps = [
        "//tensorflow/core/kernels:matmul_op",
        "//tensorflow/core/kernels/mkl:mkl_batch_matmul_op",
        "//tensorflow/core/kernels/mkl:mkl_matmul_op",
    ] + MKL_TEST_DEPS,
)

tf_mkl_kernel_library(
    name = "mkl_kernel_util",
    srcs = ["mkl_kernel_util.cc"],
    hdrs = ["mkl_kernel_util.h"],
    deps = MKL_DEPS + [
        ":mkl_quantize_op",
        "//tensorflow/cc:cc_ops",
        "//tensorflow/cc:ops",
        "//tensorflow/cc:scope",
        "//tensorflow/core:core_cpu_base",
        "//tensorflow/core:direct_session",
        "//tensorflow/core:graph",
        "//tensorflow/core/kernels:quantization_utils",
    ],
)

tf_cc_test_mkl(
    name = "onednn_nn_ops_benchmark",
    size = "small",
    srcs = ["onednn_nn_ops_benchmark.cc"],
    linkstatic = 1,
    deps = [
        "//tensorflow/cc:cc_ops_internal",
        "//tensorflow/core/kernels:softmax_op",
        "//tensorflow/core/kernels/mkl:mkl_softmax_op",
    ] + MKL_TEST_DEPS,
)

tf_cc_test_mkl(
    name = "onednn_fused_matmul_ops_test",
    size = "medium",
    srcs = ["onednn_fused_matmul_ops_test.cc"],
    linkstatic = 1,  # Fixes dyld error on MacOS.
    deps = [
        ":mkl_kernel_util",
        ":mkl_matmul_op",
        "//tensorflow/cc:cc_ops_internal",
        "//tensorflow/core:direct_session",
        "//tensorflow/core/kernels:bias_op",
        "//tensorflow/core/kernels:matmul_op",
        "//tensorflow/core/kernels:quantization_utils",
        "//tensorflow/core/kernels:relu_op",
        "@com_google_absl//absl/strings",
    ] + MKL_TEST_DEPS,
)
