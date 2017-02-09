import re
paren_re = r"\(.*?\)"

class Decompress:
    def __init__(self, input_path):
        self.compressed    = open(input_path).read()
        self.uncompressed  = ""
        self.current_index = 0
        self.done          = False

    def perform(self):
        while not self.done:
            self.find_next_chunk()

    def find_next_chunk(self):
        marker, sre_match = self.find_next_marker()

        if sre_match:
            # For all indexing remember sre_match is based off of a substring hence all the current_index + sre_match.start() or end()
            self.append_uncompressed_text(self.current_index, self.current_index + sre_match.start())

            num_chars_to_repeat, times_to_repeat = self.parse_marker(marker)#map(lambda x: int(x), marker.split("x"))

            uncompressed = self.uncompress_chunk(
                               num_chars_to_repeat, times_to_repeat, sre_match
                           )
            self.uncompressed += uncompressed
            self.current_index += sre_match.end() + num_chars_to_repeat
        else:
            self.uncompressed += self.compressed[self.current_index:]
            self.uncompressed  = self.uncompressed.rstrip()
            self.done = True


    def find_next_marker(self):

        to_search = self.compressed[self.current_index:]
        match = re.search(paren_re, to_search)

        if match:
            return match.group(0)[1:-1], match
        else:
            return None, None

    def append_uncompressed_text(self, start, stop):
        self.uncompressed = self.uncompressed + self.compressed[start:stop]

    def parse_marker(self, marker):
        num_chars_to_repeat, times_to_repeat = map(lambda x: int(x), marker.split("x"))
        return num_chars_to_repeat, times_to_repeat

    def uncompress_chunk(self, num_chars_to_repeat, times_to_repeat, sre_match):
        start     = sre_match.end() + self.current_index
        to_repeat = self.compressed[start:(start + num_chars_to_repeat)]
        result = to_repeat * times_to_repeat
        return to_repeat * times_to_repeat

action = Decompress('input.txt')
action.perform()
print('FINAL uncompressed length: ', len(action.uncompressed))
