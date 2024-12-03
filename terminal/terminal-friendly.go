package main

import (
	"fmt"
	"strings"
)

func isControlCharacter(char rune) bool {
	return (char >= 0 && char <= 31 && char != 9 && char != 10 && char != 13) || // Exclude \t, \n, \r
		char == 127 || // DEL (Delete)
		(char >= 128 && char <= 159) // Extended ASCII control characters
}

func toCaretNotation(char rune) string {
	charCode := uint32(char)
	switch {
	case charCode <= 31:
		return fmt.Sprintf("^%c", charCode+64)
	case charCode == 127:
		return "^?"
	default:
		return fmt.Sprintf("\\x%02x", charCode)
	}
}

func getTerminalFriendlyString(text string) string {
	var result strings.Builder
	for _, char := range text {
		if isControlCharacter(char) {
			result.WriteString(toCaretNotation(char))
		} else {
			result.WriteRune(char)
		}
	}
	return result.String()
}

func main() {
	// Test cases
	testCases := []struct {
		input    string
		expected string
	}{
		{
			input:    "Hello\x00World\x1F\x7F",
			expected: "Hello^@World^_^?",
		},
		{
			input:    "\x1B[5;31mEmbrace the Red\x1B[0m",
			expected: "^[[5;31mEmbrace the Red^[[0m",
		},
		{
			input:    "\x03Control\x04Codes",
			expected: "^CControl^DCodes",
		},
		{
			input:    "Normal Text",
			expected: "Normal Text",
		},
		{
			input:    "\x01Start\x02End\x1A",
			expected: "^AStart^BEnd^Z",
		},
		{
			input:    "Line\rBreak\nTab\t",
			expected: "Line\rBreak\nTab\t",
		},
	}

	// Run test cases
	for i, tc := range testCases {
		result := getTerminalFriendlyString(tc.input)
		fmt.Printf("Test Case %d:\n", i+1)
		fmt.Printf("Input:    %q\n", tc.input)
		fmt.Printf("Expected: %q\n", tc.expected)
		fmt.Printf("Result:   %q\n", result)

		if result != tc.expected {
			fmt.Println("❌ Test Failed")
		} else {
			fmt.Println("✅ Test Passed")
		}
		fmt.Println()
	}
}
