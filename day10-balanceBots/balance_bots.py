from output import Output
from chip   import Chip
from bot    import Bot

class BalanceBots:

    def __init__(self, input_file):
        with open(input_file) as f:
            self.instructions = f.readlines()

        self.bots  = []
        self.chips = []
        self.outputs = []

    def perform(self):
        self.allocate_init_chip_config()
        while True:
            for line in self.instructions:
                if line[0:5] == 'value':
                    continue
                else:
                    things = self.parse_instruction(line.rstrip())

    def parse_instruction(self, line):
        # All instructions split to 12 element array so we know precisely what is at every index
        # ['bot', '171', 'gives', 'low', 'to', 'bot', '4', 'and', 'high', 'to', 'bot', '84']
        array         = line.split()
        giver         = self.find_or_create_object(array[1], array[0])

        receiver_low = self.find_or_create_object(array[6], array[5])
        receiver_high = self.find_or_create_object(array[-1], array[-2])

        try:
            low_chip, high_chip = giver.get_chips_asc_sorted()
            giver.chips = []
        except ValueError:
            print('giver.id: {} didnt have chips'.format(giver.id))
        else:
            receiver_low.chips.append(low_chip)
            if not receiver_low.__class__.__name__ == 'Output':
                receiver_low.is_comparing_chips_of_interest(61,17)

            receiver_high.chips.append(high_chip)
            if not receiver_high.__class__.__name__ == 'Output':
                receiver_high.is_comparing_chips_of_interest(61,17)

    def find_or_create_object(self, identifier, klass):
        store = eval("self.{}s".format(klass))
        for thing in store:
            if int(thing.id) == int(identifier):
                return thing

        # thing = Bot(identifier)
        #  globals()['Chip'](3)
        thing = globals()[klass.capitalize()](identifier)
        store.append(thing)
        return thing

    def allocate_init_chip_config(self):
        for line in self.instructions:
            if line[0:5] == 'value':
                chip, bot = self.parse_init_allocation_line(line.rstrip())

    def parse_init_allocation_line(self, line):
        chip_id, bot_id = [int(s) for s in line.split() if s.isdigit()]
        bot  = self.find_or_create_object(bot_id, 'bot')
        chip = self.find_or_create_object(chip_id, 'chip')

        bot.chips.append(chip)

        return chip, bot


if __name__ == '__main__':
    action = BalanceBots('input.txt')
    # Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?
    action.perform()
