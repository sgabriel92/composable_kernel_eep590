#pragma once

TYPED_TEST(TestTranspose, Test1)
{
    // for 16, 8, 16, 32, 8
    std::vector<int> Ms{1, 2, 3, 4, 5, 6};
    constexpr int N = 16;
    constexpr int C = 8;
    constexpr int D = 16;
    constexpr int H = 32;
    constexpr int W = 8;

    this->Run(N, C, D, H, W);
}


TYPED_TEST(TestTranpose, Test2)
{
    std::vector<int> Ms{127, 255, 312, 799, 1573};
    constexpr int N = 16;
    constexpr int C = 8;
    constexpr int D = 16;
    constexpr int H = 32;
    constexpr int W = 8;

    this->Run(N, C, D, H, W);
}
