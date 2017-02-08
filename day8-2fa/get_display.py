import numpy as np

# TEST_SCREEN_DIMS   = (3, 7)
# The screen is 50 pixels wide and 6 pixels tall
PUZZLE_SCREEN_DIMS = (6, 50)
DIM_MAP = {
    "x": 0,
    "y": 1
}

class GetDisplay:
    def __init__(self, input, dims):
        with open(input) as f:
            instructions  = f.readlines()
        self.instructions = instructions
        self.screen       = np.zeros(dims)

    def perform(self):
        for instruction in self.instructions:
            self.perform_instruction(instruction)
        print(self.screen)
        print("pixels lit: ", np.count_nonzero(self.screen))

    def perform_instruction(self, instruction):
        self.parse_instruction(instruction)

    def parse_instruction(self, instruction):
        command, specifics = instruction.split(' ', 1) #split on first occurence of white space
        fn = eval("self. " + command)
        fn(specifics)

    def rect(self, specifics):
        #specifics look like: "3x2"
        x,y = specifics.split("x")
        x = int(x)
        y = int(y)
        self.screen[0:y, 0:x] = 1

    def rotate(self, specifics):
        # specifics look like: "column x=1 by 1"
        intermediate_var = specifics.split("=")
        shift_size       = int(intermediate_var[-1].rstrip().split(' ')[-1])
        dim_index        = int(intermediate_var[-1].split(' ')[0])
        axis              = DIM_MAP[intermediate_var[0][-1]]

        shifted = np.roll(self.screen, shift_size, axis)

        if axis == 0:
            self.screen[:, dim_index] = shifted[:, dim_index]
        else:
            self.screen[dim_index, :] = shifted[dim_index, :]



action = GetDisplay('input.txt', PUZZLE_SCREEN_DIMS)
action.perform()
