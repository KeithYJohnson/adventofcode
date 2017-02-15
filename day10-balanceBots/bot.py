class Bot:

    def __init__(self, identifier):
        self.id = int(identifier)
        self.chips = []

    def get_chips_asc_sorted(self):
        chip_one, chip_two = self.chips
        if chip_one.id > chip_two.id:
            return chip_two, chip_one
        else:
            return chip_one, chip_two

    def is_comparing_chips_of_interest(self, first_chip_id, second_chip_id):
        ids = list(map(lambda x: x.id, self.chips))
        if first_chip_id in ids and second_chip_id in ids:
            print("BOT {} is comparing {} and {}".format(self.id, first_chip_id, second_chip_id))
            return Exception # Hacky I know but it kills that while True: in balance_bots.perform()
