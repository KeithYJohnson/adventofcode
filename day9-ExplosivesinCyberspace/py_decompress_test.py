from py_decompress import Decompress

action = Decompress('test_input.txt')

def test_find_next_marker():
    action.compressed = "X(8x2)(3x3)ABCY"
    marker, sre_match = action.find_next_marker()
    assert marker     == "8x2"
    assert sre_match

def test_append_uncompressed_text():
    action.compressed = "X(8x2)(3x3)ABCY"
    action.append_uncompressed_text(0,2)
    assert action.uncompressed == action.compressed[0:2]

def test_parse_marker():
    action.compressed = "X(8x2)(3x3)ABCY"
    result = action.parse_marker("8x2")
    assert result[0] == 8
    assert result[1] == 2

def test_perform_on_various_inputs():
    action = Decompress('test_input.txt')
    action.compressed = "X(8x2)(3x3)ABCY"
    action.perform()
    assert action.uncompressed == "X(3x3)ABC(3x3)ABCY"

    action = Decompress('test_input.txt')
    action.compressed = "ADVENT"
    action.perform()
    assert action.uncompressed == "ADVENT"

    action = Decompress('test_input.txt')
    action.compressed = "A(1x5)BC"
    action.perform()
    assert action.uncompressed == "ABBBBBC"

    # (3x3)XYZ becomes XYZXYZXYZ
    action = Decompress('test_input.txt')
    action.compressed = "(3x3)XYZ"
    action.perform()
    assert action.uncompressed == "XYZXYZXYZ"

    #A(2x2)BCD(2x2)EFG doubles the BC and EF, becoming ABCBCDEFEFG
    action = Decompress('test_input.txt')
    action.compressed = "A(2x2)BCD(2x2)EFG"
    action.perform()
    assert action.uncompressed == "ABCBCDEFEFG"

    # (6x1)(1x3)A simply becomes (1x3)A
    action = Decompress('test_input.txt')
    action.compressed = "(6x1)(1x3)A"
    action.perform()
    assert action.uncompressed == "(1x3)A"

    # X(8x2)(3x3)ABCY  becomes X(3x3)ABC(3x3)ABCY
    action = Decompress('test_input.txt')
    action.compressed = "X(8x2)(3x3)ABCY"
    action.perform()
    assert action.uncompressed == "X(3x3)ABC(3x3)ABCY"
