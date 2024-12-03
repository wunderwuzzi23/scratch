def is_control_character(char):
    """
    Determine if a character is a control character.
    
    Args:
        char (str): A single character to check.
    
    Returns:
        bool: True if the character is a control character, False otherwise.
    """
    char_code = ord(char)
    return (
        (0 <= char_code <= 31 and char_code not in {9, 10, 13}) or  # Exclude \t, \n, \r
        char_code == 127 or  # DEL (Delete)
        (128 <= char_code <= 159)  # Extended ASCII control characters
    )

def to_caret_notation(char):
    """
    Convert a control character to its caret notation or hex representation.
    
    Args:
        char (str): A single character to convert.
    
    Returns:
        str: Caret notation or hex representation of the character.
    """
    char_code = ord(char)
    if 0 <= char_code <= 31:
        return f"^{chr(char_code + 64)}"
    elif char_code == 127:
        return "^?"
    else:
        return f"\\x{char_code:02x}"

def get_terminal_friendly_string(text):
    """
    Convert a string to a terminal-friendly representation.
    
    Args:
        text (str): Input string to convert.
    
    Returns:
        str: Terminal-friendly string with control characters converted.
    """
    return ''.join(
        to_caret_notation(char) if is_control_character(char) else char 
        for char in text
    )

def run_tests():
    """
    Run test cases for the terminal-friendly string conversion.
    """
    # Test cases
    test_cases = [
        {
            'input': "Hello\x00World\x1F\x7F",
            'expected': "Hello^@World^_^?"
        },
        {
            'input': "\x1B[5;31mEmbrace the Red\x1B[0m",
            'expected': "^[[5;31mEmbrace the Red^[[0m"
        },
        {
            'input': "\x03Control\x04Codes",
            'expected': "^CControl^DCodes"
        },
        {
            'input': "Normal Text",
            'expected': "Normal Text"
        },
        {
            'input': "\x01Start\x02End\x1A",
            'expected': "^AStart^BEnd^Z"
        },
        {
            'input': "Line\rBreak\nTab\t",
            'expected': "Line\rBreak\nTab\t"
        }
    ]

    # Run tests
    for i, test_case in enumerate(test_cases, 1):
        input_text = test_case['input']
        expected = test_case['expected']
        result = get_terminal_friendly_string(input_text)

        print(f"Test Case {i}:")
        print(f"Input:    {repr(input_text)}")
        print(f"Expected: {repr(expected)}")
        print(f"Result:   {repr(result)}")

        if result == expected:
            print("✅ Test Passed")
        else:
            print("❌ Test Failed")
        print()

def main():
    """
    Main entry point for the script.
    """
    run_tests()

if __name__ == "__main__":
    main()

