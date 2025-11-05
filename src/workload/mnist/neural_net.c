#include "../include/neural_net.h"

// Simple pseudo-random (declared in mnist.c)
extern int simple_rand();

// Simple exp approximation (Taylor series)
float simple_exp(float x) {
    if (x > 10.0f) return 22026.0f;  // e^10
    if (x < -10.0f) return 0.0f;
    
    float result = 1.0f;
    float term = 1.0f;
    for (int i = 1; i < 10; i++) {
        term *= x / i;
        result += term;
    }
    return result;
}

// Initialize network with random weights
void init_network(NeuralNetwork *nn) {
    for (int i = 0; i < INPUT_SIZE; i++) {
        for (int j = 0; j < HIDDEN_SIZE; j++) {
            nn->weights_input_hidden[i][j] = 0.01f * (simple_rand() % 100 - 50);
        }
    }
    
    for (int i = 0; i < HIDDEN_SIZE; i++) {
        for (int j = 0; j < OUTPUT_SIZE; j++) {
            nn->weights_hidden_output[i][j] = 0.01f * (simple_rand() % 100 - 50);
        }
        nn->bias_hidden[i] = 0.0f;
    }
    
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        nn->bias_output[i] = 0.0f;
    }
}

// ReLU activation
float relu(float x) {
    return (x > 0) ? x : 0;
}

// This version is now generic and works for any matrix size.
void matrix_multiply(float *input, float *weights, float *output, 
                     int input_size, int output_size, int weight_cols) {
    for (int i = 0; i < output_size; i++) {
        output[i] = 0.0f;
        for (int j = 0; j < input_size; j++) {
            // Manual index calculation: weights[j][i] -> weights[j * num_cols + i]
            output[i] += input[j] * weights[j * weight_cols + i];
        }
    }
}

// ... (softmax function) ...
void softmax(float *input, int size) {
    float max = input[0];
    for (int i = 1; i < size; i++) {
        if (input[i] > max) max = input[i];
    }
    
    float sum = 0.0f;
    for (int i = 0; i < size; i++) {
        input[i] = simple_exp(input[i] - max);
        sum += input[i];
    }
    
    for (int i = 0; i < size; i++) {
        input[i] /= sum;
    }
}


// --- PREDICT FUNCTION ---
int predict(NeuralNetwork *nn, float *input) {
    float hidden[HIDDEN_SIZE];
    float output[OUTPUT_SIZE];
    
    // Input -> Hidden
    matrix_multiply(input, (float*)nn->weights_input_hidden, hidden, 
                    INPUT_SIZE, HIDDEN_SIZE, HIDDEN_SIZE);
    
    // ReLU activation
    for (int i = 0; i < HIDDEN_SIZE; i++) {
        hidden[i] = relu(hidden[i] + nn->bias_hidden[i]);
    }
    
    // Hidden -> Output
    matrix_multiply(hidden, (float*)nn->weights_hidden_output, output, 
                    HIDDEN_SIZE, OUTPUT_SIZE, OUTPUT_SIZE);
    
    // Add bias
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        output[i] += nn->bias_output[i];
    }
    
    // Softmax
    softmax(output, OUTPUT_SIZE);
    
    // Return predicted class
    int predicted_class = 0;
    float max_prob = output[0];
    for (int i = 1; i < OUTPUT_SIZE; i++) {
        if (output[i] > max_prob) {
            max_prob = output[i];
            predicted_class = i;
        }
    }
    
    return predicted_class;
}