from operations import add


class TestBasicAddition:
    def test_add(self):
        assert add(2, 3) == 5
