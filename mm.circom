pragma circom 2.0.0;

template DotProduct(n) {
    signal input a[n];
    signal input b[n];
    signal output out;

    signal terms[n];
    signal partialSums[n+1];

    // Initialize the first element of partialSums to zero
    partialSums[0] <== 0;

    for (var i = 0; i < n; i++) {
        // Compute the product of corresponding elements
        terms[i] <== a[i] * b[i];

        // Accumulate the sum in partialSums
        partialSums[i+1] <== partialSums[i] + terms[i];
    }

    // The final sum is the last element in partialSums
    out <== partialSums[n];
}

template MatrixMultiplication(n) {
    // 2D array inputs
    signal input Input[n][n];
    signal input Coefficient[n][n];

    // Output matrix
    signal output C[n][n];  
    signal input answer[n][n];
    signal input bios[n][n];
    component dp[n][n];

    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
            dp[i][j] = DotProduct(n);

            // Set the inputs of the dot product component
            for (var k = 0; k < n; k++) {
                dp[i][j].a[k] <== Input[i][k];
                dp[i][j].b[k] <== Coefficient[k][j];
            }

            // Assign the output to C[i][j]
            C[i][j] <== dp[i][j].out;
        }
    }
    for (var row_i = 0; row_i < n; row_i++) {
        for (var col_i = 0; col_i < n; col_i++) {
            C[row_i][col_i] + bios[row_i][col_i] === answer[row_i][col_i];
        }
    }   
}

component main {public [Input, answer]} = MatrixMultiplication(2);
