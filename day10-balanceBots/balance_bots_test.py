from balance_bots import BalanceBots
from pdb import set_trace as st

def test_parse_init_allocation_line():
    action = BalanceBots('test_input.txt')
    chip, bot = action.parse_init_allocation_line(action.instructions[0]) #value 5 goes to bot 2
    assert chip.id == 5
    assert bot.id  == 2

def test_allocate_init_chip_config():
    action = BalanceBots('test_input.txt')
    action.allocate_init_chip_config()
    assert len(action.chips) == 3
    assert len(action.bots)  == 2
    # First line of text_input.txt refers to the bot with an id of 2
    bot_2 = action.bots[0]
    bot_1 = action.bots[-1]
    assert len(bot_2.chips) == 2
    assert len(bot_1.chips) == 1


def test_find_or_create_object():
    # With no bots
    action = BalanceBots('test_input.txt')
    assert len(action.bots) == 0
    action.find_or_create_object(1, 'bot')
    assert len(action.bots)  == 1
    assert action.bots[0].id == 1


def test_perform():
    action = BalanceBots('test_input.txt')
    action.perform()

    assert len(action.bots)    == 3
    assert len(action.chips)   == 3
    assert len(action.outputs) == 3

    #output 1 is created first, then output 2, then output 0
    # (Pdb) outs = action.outputs
    # (Pdb) outs[0].id
    # 1
    # (Pdb) outs[1].id
    # 2
    # (Pdb) outs[3].id
    # *** IndexError: list index out of range
    # (Pdb) outs[2].id
    # 0

    outputs = action.outputs
    output_1 = outputs[0]
    output_2 = outputs[1]
    output_0 = outputs[2]

    assert len(output_0.chips)  == 1
    assert output_0.chips[0].id == 5

    assert len(output_1.chips)  == 1
    assert output_1.chips[0].id == 2

    assert len(output_2.chips)  == 1
    assert output_2.chips[0].id == 3
